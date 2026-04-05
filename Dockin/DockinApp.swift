//
//  DockinApp.swift
//  Dockin
//
//  Created by Hector on 5/4/26.
//

import SwiftUI

@main
struct DockinApp: App {
    @StateObject private var model = DockGuardModel()

    var body: some Scene {
        MenuBarExtra {
            ContentView(model: model)
                .preferredColorScheme(model.preferredColorScheme)
        } label: {
            Image(nsImage: DockinIcon.menuBarImage())
                .accessibilityLabel("Dockin")
        }
        .menuBarExtraStyle(.window)

        Window("Dockin", id: "main") {
            ContentView(model: model)
                .preferredColorScheme(model.preferredColorScheme)
                .frame(minWidth: 380)
        }
        .defaultSize(width: 400, height: 540)
    }
}
