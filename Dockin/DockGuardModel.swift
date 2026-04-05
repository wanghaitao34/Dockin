//
//  DockGuardModel.swift
//  Dockin
//
//  Created by Codex on 5/4/26.
//

import AppKit
import ApplicationServices
import Combine
import ServiceManagement
import SwiftUI

struct DisplayInfo: Identifiable, Hashable {
    let id: CGDirectDisplayID
    let name: String
    let frame: CGRect
    let isMain: Bool
}

enum DockEdge: String {
    case bottom
    case left
    case right
}

private enum LaunchAtLoginNoticeKind {
    case approvalRequired
    case updateFailed
}

@MainActor
final class DockGuardModel: ObservableObject {
    @Published private(set) var displays: [DisplayInfo] = []
    @Published private(set) var dockEdge: DockEdge = .bottom
    @Published private(set) var launchAtLoginEnabled = false
    @Published private(set) var launchAtLoginRequiresApproval = false
    @Published private var launchAtLoginNoticeKind: LaunchAtLoginNoticeKind?
    @Published var isEnabled: Bool {
        didSet {
            defaults.set(isEnabled, forKey: Keys.isEnabled)
        }
    }
    @Published var selectedDisplayRawID: Int {
        didSet {
            defaults.set(selectedDisplayRawID, forKey: Keys.selectedDisplayID)
        }
    }
    @Published var safeInset: Double {
        didSet {
            defaults.set(safeInset, forKey: Keys.safeInset)
        }
    }
    @Published var language: AppLanguage {
        didSet {
            defaults.set(language.rawValue, forKey: Keys.language)
        }
    }
    @Published var appearance: AppAppearance {
        didSet {
            defaults.set(appearance.rawValue, forKey: Keys.appearance)
        }
    }

    private let defaults: UserDefaults
    private var timer: Timer?
    private var lastWarpAt = Date.distantPast
    private var screenObserver: NSObjectProtocol?
    private var dockObserver: NSObjectProtocol?
    private var localeObserver: NSObjectProtocol?

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.isEnabled = defaults.object(forKey: Keys.isEnabled) as? Bool ?? true
        self.selectedDisplayRawID = defaults.integer(forKey: Keys.selectedDisplayID)
        self.safeInset = defaults.object(forKey: Keys.safeInset) as? Double ?? 14
        self.language = AppLanguage(rawValue: defaults.string(forKey: Keys.language) ?? "") ?? .system
        self.appearance = AppAppearance(rawValue: defaults.string(forKey: Keys.appearance) ?? "") ?? .system

        refreshDockEdge()
        refreshDisplays()
        refreshLaunchAtLoginState()
        installObservers()
        startMonitoring()
    }

    deinit {
        timer?.invalidate()

        if let screenObserver {
            NotificationCenter.default.removeObserver(screenObserver)
        }

        if let dockObserver {
            DistributedNotificationCenter.default().removeObserver(dockObserver)
        }

        if let localeObserver {
            NotificationCenter.default.removeObserver(localeObserver)
        }
    }

    var strings: DockinStrings {
        DockinStrings(language: resolvedLanguage)
    }

    var preferredColorScheme: ColorScheme? {
        appearance.colorScheme
    }

    var statusTitle: String {
        if isActivelyGuarding {
            return strings.statusProtecting
        }

        if !isEnabled {
            return strings.statusOff
        }

        return strings.statusPaused
    }

    var statusColor: Color {
        if isActivelyGuarding {
            return .green
        }

        if !isEnabled {
            return .secondary
        }

        return .orange
    }

    var statusNote: String? {
        if !isEnabled {
            return strings.noteProtectionOff
        }

        guard displays.count > 1 else {
            return strings.noteSingleDisplay
        }

        guard selectedDisplay != nil else {
            return strings.noteMissingTargetDisplay
        }

        return nil
    }

    var dockEdgeTitle: String {
        strings.dockEdgeTitle(dockEdge)
    }

    var connectedDisplaysTitle: String {
        strings.connectedDisplays(displays.count)
    }

    var launchAtLoginNotice: String? {
        switch launchAtLoginNoticeKind {
        case .approvalRequired:
            return strings.launchAtLoginApprovalRequired
        case .updateFailed:
            return strings.launchAtLoginUpdateFailed
        case .none:
            return nil
        }
    }

    var isActivelyGuarding: Bool {
        isEnabled && displays.count > 1 && selectedDisplay != nil
    }

    private var resolvedLanguage: AppLanguage {
        language == .system ? .preferredDefault() : language
    }

    private var selectedDisplay: DisplayInfo? {
        displays.first { Int($0.id) == selectedDisplayRawID }
    }

    func refreshDisplays() {
        let updated = NSScreen.screens.compactMap(Self.makeDisplayInfo(from:))
            .sorted { lhs, rhs in
                if lhs.frame.minX == rhs.frame.minX {
                    return lhs.frame.minY > rhs.frame.minY
                }

                return lhs.frame.minX < rhs.frame.minX
            }

        displays = updated

        if selectedDisplayRawID == 0, let mainDisplay = updated.first(where: { $0.id == CGMainDisplayID() }) ?? updated.first {
            selectedDisplayRawID = Int(mainDisplay.id)
        }
    }

    func badgeText(for display: DisplayInfo) -> String {
        if Int(display.id) == selectedDisplayRawID {
            return strings.dockPinned
        }

        return strings.blocked
    }

    func badgeColor(for display: DisplayInfo) -> Color {
        Int(display.id) == selectedDisplayRawID ? .blue : .secondary
    }

    func displayPickerTitle(for display: DisplayInfo) -> String {
        display.isMain ? "\(display.name) · \(strings.mainDisplay)" : display.name
    }

    func setLaunchAtLoginEnabled(_ enabled: Bool) {
        let service = SMAppService.mainApp

        do {
            if enabled {
                try service.register()
            } else {
                try service.unregister()
            }

            refreshLaunchAtLoginState()
        } catch {
            refreshLaunchAtLoginState(resetNotice: false)
            launchAtLoginNoticeKind = .updateFailed
        }
    }

    func openSystemSettingsLoginItems() {
        SMAppService.openSystemSettingsLoginItems()
    }

    private func installObservers() {
        screenObserver = NotificationCenter.default.addObserver(
            forName: NSApplication.didChangeScreenParametersNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.refreshDisplays()
            }
        }

        dockObserver = DistributedNotificationCenter.default().addObserver(
            forName: Notification.Name("com.apple.dock.prefchanged"),
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.refreshDockEdge()
            }
        }

        localeObserver = NotificationCenter.default.addObserver(
            forName: NSLocale.currentLocaleDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.refreshLanguageIfNeeded()
            }
        }
    }

    private func refreshDockEdge() {
        let dockDefaults = UserDefaults(suiteName: "com.apple.dock")
        dockEdge = DockEdge(rawValue: dockDefaults?.string(forKey: "orientation") ?? "") ?? .bottom
    }

    private func refreshLanguageIfNeeded() {
        guard language == .system else {
            return
        }

        objectWillChange.send()
    }

    private func refreshLaunchAtLoginState(resetNotice: Bool = true) {
        switch SMAppService.mainApp.status {
        case .enabled:
            launchAtLoginEnabled = true
            launchAtLoginRequiresApproval = false
            if resetNotice {
                launchAtLoginNoticeKind = nil
            }
        case .requiresApproval:
            launchAtLoginEnabled = true
            launchAtLoginRequiresApproval = true
            launchAtLoginNoticeKind = .approvalRequired
        case .notRegistered, .notFound:
            launchAtLoginEnabled = false
            launchAtLoginRequiresApproval = false
            if resetNotice {
                launchAtLoginNoticeKind = nil
            }
        @unknown default:
            launchAtLoginEnabled = false
            launchAtLoginRequiresApproval = false
            launchAtLoginNoticeKind = .updateFailed
        }
    }

    private func startMonitoring() {
        timer?.invalidate()

        let newTimer = Timer(timeInterval: 1.0 / 60.0, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.handleTick()
            }
        }

        RunLoop.main.add(newTimer, forMode: .common)
        timer = newTimer
    }

    private func handleTick() {
        guard isActivelyGuarding, let selectedDisplay else {
            return
        }

        let mouseLocation = NSEvent.mouseLocation

        guard let hoveredDisplay = display(containing: mouseLocation), hoveredDisplay.id != selectedDisplay.id else {
            return
        }

        guard shouldBlock(mouseLocation, inside: hoveredDisplay.frame) else {
            return
        }

        let now = Date()
        guard now.timeIntervalSince(lastWarpAt) > 0.06 else {
            return
        }

        lastWarpAt = now
        moveCursorAway(from: hoveredDisplay, mouseLocation: mouseLocation)
    }

    private func display(containing point: CGPoint) -> DisplayInfo? {
        displays.first { display in
            point.x >= display.frame.minX &&
            point.x <= display.frame.maxX &&
            point.y >= display.frame.minY &&
            point.y <= display.frame.maxY
        }
    }

    private func shouldBlock(_ point: CGPoint, inside frame: CGRect) -> Bool {
        let triggerDistance = max(6, min(safeInset - 4, 18))

        switch dockEdge {
        case .bottom:
            return point.y - frame.minY <= triggerDistance
        case .left:
            return point.x - frame.minX <= triggerDistance
        case .right:
            return frame.maxX - point.x <= triggerDistance
        }
    }

    private func moveCursorAway(from display: DisplayInfo, mouseLocation: CGPoint) {
        let localX = mouseLocation.x - display.frame.minX
        let localYFromTop = display.frame.maxY - mouseLocation.y

        let targetPoint: CGPoint

        switch dockEdge {
        case .bottom:
            targetPoint = CGPoint(
                x: clamp(localX, min: safeInset, max: display.frame.width - safeInset),
                y: display.frame.height - safeInset
            )
        case .left:
            targetPoint = CGPoint(
                x: safeInset,
                y: clamp(localYFromTop, min: safeInset, max: display.frame.height - safeInset)
            )
        case .right:
            targetPoint = CGPoint(
                x: display.frame.width - safeInset,
                y: clamp(localYFromTop, min: safeInset, max: display.frame.height - safeInset)
            )
        }

        _ = CGDisplayMoveCursorToPoint(display.id, targetPoint)
    }

    private func clamp(_ value: Double, min lowerBound: Double, max upperBound: Double) -> Double {
        Swift.max(lowerBound, Swift.min(value, upperBound))
    }

    private static func makeDisplayInfo(from screen: NSScreen) -> DisplayInfo? {
        guard
            let screenNumber = screen.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? NSNumber
        else {
            return nil
        }

        let displayID = CGDirectDisplayID(screenNumber.uint32Value)

        return DisplayInfo(
            id: displayID,
            name: screen.localizedName,
            frame: screen.frame,
            isMain: displayID == CGMainDisplayID()
        )
    }
}

private enum Keys {
    static let isEnabled = "isEnabled"
    static let selectedDisplayID = "selectedDisplayID"
    static let safeInset = "safeInset"
    static let language = "language"
    static let appearance = "appearance"
}
