//
//  MotivueApp.swift
//  Motivue
//
//  Created by JangeJason on 2025/9/20.
//

import SwiftUI

@main
struct MotivueApp: App {
    @StateObject private var appData = AppData()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appData)
                .task {
                    await appData.refreshAll(useReal: false)
                }
        }
    }
}
