//
//  SavedListsView.swift
//  akaPrep
//
//  Created by Naoto Abe on 7/3/24.
//

import SwiftUI
import CoreData

struct SavedListsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: SavedListsViewModel
    
    init(context: NSManagedObjectContext, tasksViewModel: TasksViewModel) {
        _viewModel = StateObject(wrappedValue: SavedListsViewModel(context: context, tasksViewModel: tasksViewModel))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("Daily Lists")) {
                        ForEach(viewModel.dailyLists, id: \.id) { list in
                            NavigationLink(destination: TaskListView(list: list)) {
                                Text(list.name ?? "No Name")
                            }
                        }
                    }
                    
                    Section(header: Text("Weekly Lists")) {
                        ForEach(viewModel.weeklyLists, id: \.id) { list in
                            NavigationLink(destination: TaskListView(list: list)) {
                                Text(list.name ?? "No Name")
                            }
                        }
                    }
                    
                    Section(header: Text("Monthly Lists")) {
                        ForEach(viewModel.monthlyLists, id: \.id) { list in
                            NavigationLink(destination: TaskListView(list: list)) {
                                Text(list.name ?? "No Name")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Saved Lists")
        }
    }
}

struct SavedTasksView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let tasksViewModel = TasksViewModel(context: context, useSampleData: false)
        return SavedListsView(context: context, tasksViewModel: tasksViewModel)
    }
}

