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
    let akaPrepViewModel: AkaPrepViewViewModel
    let babyInfoViewModel: BabyInfoViewModel
    let savedListsViewModel: SavedListsViewModel

    init() {
        let context = persistenceController.container.viewContext
        //PersistenceController.clearAllDataAgain(in: context)
        self.savedListsViewModel = SavedListsViewModel(context: context)
        self.akaPrepViewModel = AkaPrepViewViewModel(context: context, useSampleData: false)
        self.babyInfoViewModel = BabyInfoViewModel(context: context)
       
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(akaPrepViewModel)
                .environmentObject(babyInfoViewModel)
                .environmentObject(savedListsViewModel)
        }
    }
}
