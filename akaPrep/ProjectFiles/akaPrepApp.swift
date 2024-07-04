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

    init() {
        let context = persistenceController.container.viewContext
        //PersistenceController.clearAllDataAgain(in: context)
        self.akaPrepViewModel = AkaPrepViewViewModel(context: context, useSampleData: false)
       
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(akaPrepViewModel)
        }
    }
}
