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
    @EnvironmentObject var akaPrepViewModel: AkaPrepViewViewModel

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
    let akaPrepViewModel = AkaPrepViewViewModel(context: context, useSampleData: true)
    
    return ContentView()
        .environment(\.managedObjectContext, context)
        .environmentObject(akaPrepViewModel)
}
