//
//  ContentView.swift
//  Dockin
//
//  Created by Hector on 5/4/26.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var model: DockGuardModel
    @State private var showingSettings = false

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                header

                Divider()

                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 14) {
                        preferenceRow(model.strings.enableDockLock) {
                            Toggle("", isOn: $model.isEnabled)
                                .labelsHidden()
                                .toggleStyle(.switch)
                        }

                        preferenceRow(model.strings.targetDisplay) {
                            Picker("", selection: $model.selectedDisplayRawID) {
                                ForEach(model.displays) { display in
                                    Text(model.displayPickerTitle(for: display)).tag(Int(display.id))
                                }
                            }
                            .labelsHidden()
                            .pickerStyle(.menu)
                            .frame(width: 190)
                            .disabled(model.displays.isEmpty)
                        }
                    }

                    Divider()

                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(model.strings.edgeBounceDistance)
                            Spacer()
                            Text("\(Int(model.safeInset)) px")
                                .monospacedDigit()
                                .foregroundStyle(.secondary)
                        }

                        Slider(value: $model.safeInset, in: 10 ... 32, step: 1)

                        preferenceRow(model.strings.currentDockPosition) {
                            Text(model.dockEdgeTitle)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Divider()

                    VStack(alignment: .leading, spacing: 12) {
                        Text(model.connectedDisplaysTitle)
                            .font(.headline)

                        if model.displays.isEmpty {
                            Text(model.strings.noDisplaysDetected)
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(model.displays) { display in
                                HStack(spacing: 12) {
                                    Text(display.name)
                                        .lineLimit(1)

                                    Spacer(minLength: 12)

                                    DisplayBadge(
                                        title: model.badgeText(for: display),
                                        tint: model.badgeColor(for: display)
                                    )
                                }
                            }
                        }
                    }

                    if let statusNote = model.statusNote {
                        Text(statusNote)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    HStack {
                        Button(model.strings.refreshDisplays) {
                            model.refreshDisplays()
                        }
                        .buttonStyle(.bordered)

                        Spacer()

                        Button(model.strings.quitApp) {
                            NSApp.terminate(nil)
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .padding(18)
            }
            .opacity(showingSettings ? 0.34 : 1)
            .allowsHitTesting(!showingSettings)

            if showingSettings {
                Rectangle()
                    .fill(.black.opacity(0.06))
                    .ignoresSafeArea()
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showingSettings = false
                    }

                SettingsView(model: model) {
                    showingSettings = false
                }
                .padding(.top, 92)
                .transition(.scale(scale: 0.96).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.16), value: showingSettings)
        .frame(width: 400)
    }

    private var header: some View {
        HStack(spacing: 12) {
            DockinIcon(size: 18)

            Text(model.strings.appName)
                .font(.title3.weight(.semibold))

            Circle()
                .fill(model.statusColor)
                .frame(width: 10, height: 10)

            Text(model.statusTitle)
                .font(.headline)
                .foregroundStyle(model.statusColor)

            Spacer()

            Button {
                showingSettings = true
            } label: {
                Image(systemName: "gearshape")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.blue)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(Color(nsColor: .windowBackgroundColor).opacity(0.9))
    }

    private func preferenceRow<Control: View>(_ title: String, @ViewBuilder control: () -> Control) -> some View {
        HStack(alignment: .center, spacing: 16) {
            Text(title)
            Spacer(minLength: 20)
            control()
        }
    }
}

private struct DisplayBadge: View {
    let title: String
    let tint: Color

    var body: some View {
        Text(title)
            .font(.caption.weight(.semibold))
            .foregroundStyle(tint)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(tint.opacity(0.12))
            .clipShape(Capsule())
    }
}

#Preview {
    ContentView(model: DockGuardModel())
}
