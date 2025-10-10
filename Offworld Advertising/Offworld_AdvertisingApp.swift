//
//  Offworld_AdvertisingApp.swift
//  Offworld Advertising
//
//  Created by Joel Gaikwad on 10/10/25.
//

import SwiftUI
import SwiftData

@main
struct Offworld_AdvertisingApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
