//
//  ContentView.swift
//  akaPrep
//
//  Created by Naoto Abe on 6/25/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TaskEntity.date, ascending: true)],
        animation: .default)
    private var tasks: FetchedResults<TaskEntity>

   
    @EnvironmentObject var savedListsViewModel: SavedListsViewModel
    @EnvironmentObject var akaPrepViewModel: AkaPrepViewViewModel

    var body: some View {
        BottomBarView()
            .environmentObject(akaPrepViewModel)
            .environmentObject(savedListsViewModel)
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let savedListsViewModel = SavedListsViewModel(context: context)
    let akaPrepViewModel = AkaPrepViewViewModel(context: context, useSampleData: true)
    
    return ContentView()
        .environment(\.managedObjectContext, context)
        .environmentObject(savedListsViewModel)
        .environmentObject(akaPrepViewModel)
}
