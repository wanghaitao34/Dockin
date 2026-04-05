//
//  SettingsView.swift
//  Dockin
//
//  Created by Codex on 5/4/26.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var model: DockGuardModel
    let onClose: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 16) {
                Text(model.strings.settings)
                    .font(.title3.weight(.semibold))

                Spacer()

                Button(model.strings.close) {
                    onClose()
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color(nsColor: .controlBackgroundColor))
                )
            }
            .padding(.bottom, 18)

            divider

            VStack(alignment: .leading, spacing: 18) {
                settingsRow(model.strings.languageTitle) {
                    Picker("", selection: $model.language) {
                        ForEach(AppLanguage.allCases) { language in
                            Text(languageTitle(for: language)).tag(language)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.menu)
                    .frame(width: 184)
                }

                settingsRow(model.strings.appearance) {
                    Picker("", selection: $model.appearance) {
                        ForEach(AppAppearance.allCases) { appearance in
                            Text(model.strings.appearanceTitle(appearance)).tag(appearance)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.menu)
                    .frame(width: 184)
                }
            }
            .padding(.vertical, 20)

            divider

            VStack(alignment: .leading, spacing: 12) {
                settingsRow(model.strings.launchAtLogin) {
                    Toggle(
                        "",
                        isOn: Binding(
                            get: { model.launchAtLoginEnabled },
                            set: { model.setLaunchAtLoginEnabled($0) }
                        )
                    )
                    .labelsHidden()
                    .toggleStyle(.switch)
                }

                if let notice = model.launchAtLoginNotice {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(notice)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)

                        if model.launchAtLoginRequiresApproval {
                            Button(model.strings.openSystemSettings) {
                                model.openSystemSettingsLoginItems()
                            }
                            .buttonStyle(.link)
                        }
                    }
                }
            }
            .padding(.top, 20)
        }
        .padding(22)
        .frame(width: 356)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 26, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .stroke(Color.black.opacity(0.08), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.16), radius: 20, y: 8)
    }

    private func settingsRow<Control: View>(_ title: String, @ViewBuilder control: () -> Control) -> some View {
        HStack(alignment: .center, spacing: 16) {
            Text(title)
            Spacer(minLength: 20)
            control()
        }
    }

    private func languageTitle(for language: AppLanguage) -> String {
        switch language {
        case .system:
            model.strings.followSystem
        default:
            language.nativeName
        }
    }

    private var divider: some View {
        Divider()
            .overlay(Color.black.opacity(0.04))
    }
}
