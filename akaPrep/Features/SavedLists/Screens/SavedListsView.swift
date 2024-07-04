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
    @StateObject private var viewModel = SavedListsViewModel(context: PersistenceController.shared.container.viewContext)

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.savedLists, id: \.self) { list in
                    NavigationLink(destination: TaskListView(list: list)) {
                        Text(list.name)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let list = viewModel.savedLists[index]
                        viewModel.deleteList(list: list)
                    }
                }
            }
            .navigationTitle("Saved Lists")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
    }
}

struct SavedListsView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        return SavedListsView()
            .environment(\.managedObjectContext, context)
    }
}
