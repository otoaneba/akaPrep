//
//  TasksRowView.swift
//  akaPrep
//
//  Created by Mengyuan Cynthia Li on 2024-07-07.
//

import SwiftUI
import CoreData

struct TaskRowView: View {
    @ObservedObject var task: TaskEntity
    @State private var isEditing = false
    @State private var title: String
    @EnvironmentObject var viewModel: TasksViewModel
    
    init(task: TaskEntity) {
        self.task = task
        _title = State(initialValue: task.title ?? "")
    }
    
    var body: some View {
        HStack {
            if isEditing {
                TextField("Title", text: $title, onCommit: {
                    task.title = title
                    viewModel.saveTask(task)
                    isEditing = false
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onTapGesture {
                    isEditing = true
                }
            } else {
                Text(task.title ?? "No Title")
                    .onTapGesture {
                        isEditing = true
                    }
            }
            Spacer()
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .onTapGesture {
                    viewModel.toggleTaskCompletion(task: task)
                }
        }
        .animation(.easeInOut)
        .transition(.move(edge: .bottom))
        .onTapGesture {
            if isEditing {
                task.title = title
                viewModel.saveTask(task)
                isEditing = false
            }
        }    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let task = TaskEntity(context: context)
    task.title = "Sample Task"
    task.isCompleted = false
    task.taskType = "daily"
    return TaskRowView(task: task)
        .environment(\.managedObjectContext, context)
        .environmentObject(TasksViewModel.shared)
}
