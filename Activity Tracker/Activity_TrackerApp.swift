//
//  Activity_TrackerApp.swift
//  Activity Tracker
//
//  Created by mehmet Çelik on 8.03.2025.
//

import SwiftUI
import SwiftData

@main
struct Activity_TrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ActivityView()
        }.modelContainer(for: Activity.self)
    }
}
