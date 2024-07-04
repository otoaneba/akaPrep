//
//  akaPrepApp.swift
//  akaPrep
//
//  Created by Naoto Abe on 6/25/24.
//

import SwiftUI

@main
struct akaPrepApp: App {
    let persistenceController = PersistenceController.shared
    let akaPrepViewModel: TasksViewModel

    init() {
        let context = persistenceController.container.viewContext
//        PersistenceController.clearAllData(in: context) // For debugging and to clear all data in Core Data
        self.akaPrepViewModel = TasksViewModel(context: context, useSampleData: false)
       
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(akaPrepViewModel)
        }
    }
}
