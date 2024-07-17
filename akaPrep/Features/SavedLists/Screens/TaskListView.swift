//
//  TaskListView.swift
//  akaPrep
//
//  Created by Naoto Abe on 7/3/24.
//

import SwiftUI
import CoreData

struct TaskListView: View {
    @ObservedObject var list: ListEntity
    @State private var isEditingTitle = false
    @State private var newTitle: String
    @EnvironmentObject var tasksViewModel: TasksViewModel
    
    init(list: ListEntity) {
        self.list = list
        _newTitle = State(initialValue: list.name ?? "")
    }
    
    private var isCurrentActiveList: Bool {
        tasksViewModel.isListActive(list)
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(list.taskArray, id: \.self) { task in
                    Text(task.title ?? "No Title")
                }
            }
            .navigationTitleView(isEditingTitle: $isEditingTitle, newTitle: $newTitle, list: list)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarRole(.editor)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Activate") {
                        tasksViewModel.activateList(list)
                    }
                    .disabled(isCurrentActiveList)
                }
            }
        }
    }
}

extension View {
    func navigationTitleView(isEditingTitle: Binding<Bool>, newTitle: Binding<String>, list: ListEntity) -> some View {
        self.toolbar {
            ToolbarItem(placement: .principal) {
                if isEditingTitle.wrappedValue {
                    TextField("List Name", text: newTitle, onCommit: {
                        list.name = newTitle.wrappedValue
                        saveContext(for: list)
                        isEditingTitle.wrappedValue = false
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                } else {
                    Text(list.name ?? "No Name")
                        .onTapGesture {
                            isEditingTitle.wrappedValue = true
                        }
                }
            }
        }
    }
    
    private func saveContext(for list: ListEntity) {
        do {
            try list.managedObjectContext?.save()
            print("Saved list name")
        } catch {
            print("Failed to save list name: \(error)")
        }
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let sampleList = ListEntity(context: context)
        sampleList.name = "Sample List"
        sampleList.frequency = .daily
        sampleList.addToTasks(NSOrderedSet(array: [
            TaskEntity(context: context, title: "Sample Task 1", taskType: "daily"),
            TaskEntity(context: context, title: "Sample Task 2", taskType: "daily")
        ]))
        return TaskListView(list: sampleList)
            .environment(\.managedObjectContext, context)
            .environmentObject(TasksViewModel(context: context, useSampleData: true))
    }
}
