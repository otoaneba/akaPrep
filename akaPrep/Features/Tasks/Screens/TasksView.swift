//
//  TasksView.swift
//  akaPrep
//
//  Created by Naoto Abe on 6/26/24.
//

import SwiftUI
import CoreData

struct TasksView: View {
    @EnvironmentObject var viewModel: TasksViewModel
    @State private var context = ""
    @State private var taskType = "daily"
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    var body: some View {
        NavigationStack {
            
            VStack {
                TextField("Enter context", text: $context)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Picker("Task Type", selection: $viewModel.selectedTaskType) {
                    Text("Daily").tag("daily")
                    Text("Weekly").tag("weekly")
                    Text("Monthly").tag("monthly")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Button {
                    viewModel.generateTasks(taskType: viewModel.selectedTaskType, context: context)
                } label: {
                    HStack {
                        Image(systemName: "plus.app")
                        Text("Generate your tasks")
                    }
                }
            }
            .padding()
            Spacer()
            
            List {
                ForEach(viewModel.tasksForSelectedType) { task in
                    TaskRowView(task: task)
                        
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let task = viewModel.tasksForSelectedType[index]
                        viewModel.removeTask(task)
                    }
                }
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        // Add new task with empty title
                        viewModel.addTask(title: "New empty task")
                    } label: {
                        Image(systemName: "plus")
                    }
                    Button {
                        if viewModel.currentLikedLists[viewModel.selectedTaskType] != nil {
                            viewModel.unlikeCurrentList()
                        } else {
                            viewModel.likeCurrentList()
                        }
                    } label: {
                        Image(systemName: viewModel.currentLikedLists[viewModel.selectedTaskType] != nil ? "heart.fill" : "heart")
                    }
                    .disabled(viewModel.tasksForSelectedType.isEmpty) // Disable if the task list is empty
                }
            }
        }
        .onAppear {
            viewModel.loadActiveLists()
        }
        .overlay(
            VStack {
                Spacer()
                if viewModel.showToast {
                    ToastView(message: "Saved successfully!") {
                        viewModel.dismissToast()
                    }
                }
            }
            .transition(.move(edge: .bottom))
            .frame(maxWidth: UIScreen.main.bounds.width * 0.9)
            .animation(.spring(), value: viewModel.showToast)
        )
    }
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let viewModel = TasksViewModel.shared
        return TasksView()
            .environment(\.managedObjectContext, context)
            .environmentObject(viewModel)
    }
}

