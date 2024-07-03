//
//  BottomBarView.swift
//  akaPrep
//
//  Created by Naoto Abe on 6/29/24.
//

import SwiftUI

struct BottomBarView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var akaPrepViewModel: AkaPrepViewViewModel
    @EnvironmentObject private var personalInfoViewModel: PersonalInfoViewModel
    @EnvironmentObject private var babyInfoViewModel: BabyInfoViewModel
    @EnvironmentObject private var savedListsViewModel: SavedListsViewModel
    
    var body: some View {
        TabView {
            AkaPrepView()
                .environmentObject(akaPrepViewModel)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Tasks")
                }
            
            GoalsView(context: PersistenceController.preview.container.viewContext)
                .tabItem {
                    Image(systemName: "target")
                    Text("Goals")
                }
            SavedListsView()
                .environmentObject(savedListsViewModel)
                .tabItem {
                    Image(systemName: "heart")
                    Text("Saved Lists")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
    }
}

struct BottomBarView_Previews: PreviewProvider {
    static var previews: some View {
        
        BottomBarView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(AkaPrepViewViewModel(context: PersistenceController.preview.container.viewContext, useSampleData: false)) // initiallizer might need extra "SavedListsViewModel" passed in
            .environmentObject(PersonalInfoViewModel(context: PersistenceController.preview.container.viewContext))
            .environmentObject(BabyInfoViewModel(context: PersistenceController.preview.container.viewContext))
            .environmentObject(SavedListsViewModel(context: PersistenceController.preview.container.viewContext))
    }
}



