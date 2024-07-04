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
    @EnvironmentObject var akaPrepViewModel: TasksViewModel

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TaskEntity.date, ascending: true)],
        animation: .default)
    private var tasks: FetchedResults<TaskEntity>

    var body: some View {
        BottomBarView()
            .environmentObject(akaPrepViewModel)
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let akaPrepViewModel = TasksViewModel(context: context, useSampleData: true)
    
    return ContentView()
        .environment(\.managedObjectContext, context)
        .environmentObject(akaPrepViewModel)
}
