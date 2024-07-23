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
        NavigationStack {
            VStack {
                List {
                    Section(header: Text("Daily Lists")) {
                        ForEach(viewModel.dailySavedLists, id: \.id) { list in
                            NavigationLink(destination: TaskListView(list: list)) {
                                let dateString = DateUtils.formattedDate(list.createdDate ?? Date.now)
                                Text(dateString)
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    viewModel.removeList(list)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Weekly Lists")) {
                        ForEach(viewModel.weeklySavedLists, id: \.id) { list in
                            NavigationLink(destination: TaskListView(list: list)) {
                                let dateString = DateUtils.formattedDate(list.createdDate ?? Date.now)
                                Text(dateString)
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    viewModel.removeList(list)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Monthly Lists")) {
                        ForEach(viewModel.monthlySavedLists, id: \.id) { list in
                            NavigationLink(destination: TaskListView(list: list)) {
                                let dateString = DateUtils.formattedDate(list.createdDate ?? Date.now)
                                Text(dateString)
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    viewModel.removeList(list)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Saved Lists")
            .onAppear {
                viewModel.loadLists()
            }
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

