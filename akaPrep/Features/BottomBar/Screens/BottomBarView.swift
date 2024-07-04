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
    @StateObject private var savedListsViewModel = SavedListsViewModel(context: PersistenceController.shared.container.viewContext)

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
                .tabItem {
                    Image(systemName: "heart")
                    Text("Saved Lists")
                }
            
            ProfileView(context: PersistenceController.preview.container.viewContext)
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
            .environmentObject(AkaPrepViewViewModel(context: PersistenceController.preview.container.viewContext, useSampleData: false))
    }
}



