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
                    // Action
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
                    HStack {
                        Text(task.title ?? "No Title") // Unwrap optional title
                        Spacer()
                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                            .onTapGesture {
                                viewModel.toggleTaskCompletion(task: task)
                            }
                    }
                }
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        // Action to save
                        viewModel.showingAddNewTaskView = true
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
                
            }.sheet(isPresented: $viewModel.showingAddNewTaskView) {
                AddNewTaskView(newTaskPresented: $viewModel.showingAddNewTaskView)
                    .presentationDetents([.medium])
            }
        }
        .onAppear {
            viewModel.loadActiveLists()
        }
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

