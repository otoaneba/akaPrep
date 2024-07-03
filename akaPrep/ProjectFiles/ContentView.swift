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
    @EnvironmentObject var personalInfoViewModel: PersonalInfoViewModel
    @EnvironmentObject var babyInfoViewModel: BabyInfoViewModel

    var body: some View {
//        BottomBarView()
//            .environmentObject(PersonalInfoViewModel(context: viewContext))
//            .environmentObject(AkaPrepViewViewModel(context: viewContext, useSampleData: false, savedListsViewModel: savedListsViewModel))
//            .environmentObject(BabyInfoViewModel(context: viewContext))
//            .environmentObject(SavedListsViewModel(context: viewContext))
        BottomBarView()
            .environmentObject(personalInfoViewModel)
            .environmentObject(akaPrepViewModel)
            .environmentObject(babyInfoViewModel)
            .environmentObject(savedListsViewModel)
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let savedListsViewModel = SavedListsViewModel(context: context)
    let akaPrepViewModel = AkaPrepViewViewModel(context: context, useSampleData: true, savedListsViewModel: savedListsViewModel)
    let personalInfoViewModel = PersonalInfoViewModel(context: context)
    let babyInfoViewModel = BabyInfoViewModel(context: context)
    
    return ContentView()
        .environment(\.managedObjectContext, context)
        .environmentObject(savedListsViewModel)
        .environmentObject(akaPrepViewModel)
        .environmentObject(personalInfoViewModel)
        .environmentObject(babyInfoViewModel)
}
