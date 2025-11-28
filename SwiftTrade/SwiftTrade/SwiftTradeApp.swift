//
//  SwiftTradeApp.swift
//  SwiftTrade
//
//  Created by Petr Homola on 02/11/2025.
//

import SwiftUI
import SwiftData

@main
struct SwiftTradeApp: App {
    var modelContainer: ModelContainer = {
        let schema = Schema([
            SymbolData.self,
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
            MainView()
        }
        .modelContainer(modelContainer)
    }
}
