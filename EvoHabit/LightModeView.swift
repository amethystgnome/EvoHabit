//
//  LightModeView.swift
//  EvoHabit
//
//  Created by Aubrianna Sample on 5/16/24.
//

import SwiftUI

struct LightModeView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        VStack {
            Toggle("Dark Mode", isOn: $isDarkMode)
                .padding()
        }
        .onAppear {
            updateAppearance()
        }
        .onChange(of: isDarkMode) { _, _ in
            updateAppearance()
        }
        .navigationTitle("Light Mode")
    }

    private func updateAppearance() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let windows = windowScene?.windows
        windows?.forEach { window in
            window.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
        }
    }
}

