//
//  AkaListView.swift
//  akaPrep
//
//  Created by Naoto Abe on 6/26/24.
//

import SwiftUI
import CoreData

struct AkaPrepView: View {
    @StateObject var viewModel: AkaPrepViewViewModel
    @State private var context = ""
    @State private var taskType = "daily"
    
    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: AkaPrepViewViewModel(context: context))
    }
    
    
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
                        Text(task.title)
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
                Menu {
                    NavigationLink(destination: ProfileView()) {
                        HStack {
                            Image(systemName: "person.crop.circle")
                            VStack {
                                Text("Cynthia")
                                Text("Edit")
                            }
                        }
                    }
                    NavigationLink(destination: ProfileView()) {
                        Label("Personal Info", systemImage: "chevron.right")
                    }
                    NavigationLink(destination: ProfileView()) {
                        Label("Baby Info", systemImage: "chevron.right")
                    }
                    NavigationLink(destination: ProfileView()) {
                        Label("Settings", systemImage: "chevron.right")
                    }
                } label: {
                    Label("", systemImage: "person.crop.circle")
                }
            }.sheet(isPresented: $viewModel.showingAddNewTaskView) {
                AddNewTaskView(newTaskPresented: $viewModel.showingAddNewTaskView)
                    .presentationDetents([.medium])
            }
            
        }
    }
        
}

struct AkaPrepView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
                return AkaPrepView(context: context)
    }
}
