//
//  AkaListView.swift
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
                        Text("Generate your daily tasks")
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
                                if let index = viewModel.dailyTasks.firstIndex(where: { $0.id == task.id }) {
                                    viewModel.dailyTasks[index].isCompleted.toggle()
                                }
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
//                        .disabled(viewModel.isSaveDisabled)
                    Button {
                        // Action to save
                        viewModel.saveCurrentList()
                    } label: {
                        Image(systemName: "heart")
                    }
//                        .disabled(viewModel.isSaveDisabled)
                }
                
            }.sheet(isPresented: $viewModel.showingAddNewTaskView) {
                AddNewTaskView(newTaskPresented: $viewModel.showingAddNewTaskView)
                    .presentationDetents([.medium])
            }
            
        }
    }
        
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let viewModel = TasksViewModel.shared
//        let viewModel = AkaPrepViewViewModel(context: context, useSampleData: true) // Use sample data for preview

        return TasksView()
            .environment(\.managedObjectContext, context)
            .environmentObject(viewModel)

    }
}

