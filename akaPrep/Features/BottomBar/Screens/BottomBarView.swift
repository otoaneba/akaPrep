//
//  BottomBarView.swift
//  akaPrep
//
//  Created by Naoto Abe on 6/29/24.
//

import SwiftUI

struct BottomBarView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var akaPrepViewModel: TasksViewModel

    var body: some View {
        TabView {
            TasksView()
                .environmentObject(akaPrepViewModel)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Tasks")
                }
            
            GoalsView(context: viewContext)
                .tabItem {
                    Image(systemName: "target")
                    Text("Goals")
                }
            SavedListsView(context: viewContext, tasksViewModel: akaPrepViewModel)
                .tabItem {
                    Image(systemName: "heart")
                    Text("Saved Lists")
                }
            
            ProfileView(context: viewContext)
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
            .environmentObject(TasksViewModel(context: PersistenceController.preview.container.viewContext, useSampleData: false))
    }
}



