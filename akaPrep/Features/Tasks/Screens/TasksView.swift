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
    @State private var taskType = "daily"
    @Environment(\.managedObjectContext) private var managedObjectContext
    @State private var isAddingNewTask = false
    @State private var newTaskTitle = ""
    @State private var isShowingContextSheet = false
    @State private var context = ""
    @State private var editingTaskId: UUID? = nil
    @State private var isHoveringOverTrash = false

    var body: some View {
        NavigationStack {
            VStack {
                Picker("Task Type", selection: $viewModel.selectedTaskType) {
                    Text("Daily").tag("daily")
                    Text("Weekly").tag("weekly")
                    Text("Monthly").tag("monthly")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                if viewModel.tasksForSelectedType.isEmpty {
                    VStack {
                        Text("You do not have any \(viewModel.selectedTaskType) tasks")
                            .foregroundColor(.gray)
                        Button {
                            isShowingContextSheet = true
                        } label: {
                            HStack {
                                Image(systemName: "plus.app")
                                Text("Generate your tasks")
                            }
                        }
                    }
                }
            }
            .padding()

            List {
                ForEach(viewModel.tasksForSelectedType) { task in
                    TaskRowView(task: task, editingTaskId: $editingTaskId)
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.removeTask(task)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
                .onMove { indices, newOffset in
                    viewModel.moveTask(from: indices, to: newOffset)
                }
                if isAddingNewTask {
                    TextField("New Task", text: $newTaskTitle, onCommit: {
                        if !newTaskTitle.isEmpty {
                            viewModel.addTask(title: newTaskTitle)
                            newTaskTitle = ""
                            isAddingNewTask = false
                        }
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                } else {
                    HStack {
                        Text("Add one new task here")
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        isAddingNewTask = true
                    }
                }
            }
            .onTapGesture {
                editingTaskId = nil
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        isShowingContextSheet = true
                    } label: {
                        Text("Generate")

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
            .sheet(isPresented: $isShowingContextSheet) {
                VStack {
                    Text("Enter context to generate your \(viewModel.selectedTaskType) tasks")
                        .font(.headline)
                    TextField("Context", text: $context)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    HStack {
                        Button("Cancel") {
                            isShowingContextSheet = false
                        }
                        .padding()
                        Spacer()
                        Button("Generate") {
                            viewModel.generateTasks(taskType: viewModel.selectedTaskType, context: context)
                            isShowingContextSheet = false
                            context = ""
                        }
                        .padding()
                    }

                }
                .padding()
            }
        }
        .onAppear {
            viewModel.loadActiveLists()
        }
        .overlay(
            VStack {
                Spacer()
                if viewModel.showToast {
                    ToastView(message: viewModel.toastState.rawValue)
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
