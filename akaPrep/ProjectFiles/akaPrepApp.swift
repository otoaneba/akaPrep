//
//  akaPrepApp.swift
//  akaPrep
//
//  Created by Naoto Abe on 6/25/24.
//

import SwiftUI

@main
struct akaPrepApp: App {
    @StateObject private var settingsViewModel = SettingsViewModel()
    @StateObject private var goalsViewModel: GoalsViewModel
    let persistenceController = PersistenceController.shared
    let tasksViewModel: TasksViewModel
    
    init() {
        let context = persistenceController.container.viewContext
//        PersistenceController.clearAllData(in: context) // For debugging and to clear all data in Core Data
        self.tasksViewModel = TasksViewModel(context: context, useSampleData: false)
        self._goalsViewModel = StateObject(wrappedValue: GoalsViewModel(context: context)) // Initialize GoalsViewModel
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(tasksViewModel)
                .environmentObject(goalsViewModel) // Provide GoalsViewModel as an environment object
                .environmentObject(settingsViewModel) // Ensure SettingsViewModel is available to all views
                .preferredColorScheme(settingsViewModel.colorScheme)
                .onAppear {
                    preloadKeyboard()
                }
        }
    }
}
