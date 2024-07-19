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
    @Binding var editingTaskId: UUID?
    
    init(task: TaskEntity, editingTaskId: Binding<UUID?>) {
        self.task = task
        self._editingTaskId = editingTaskId
        _title = State(initialValue: task.title ?? "")
    }
    
    var body: some View {
        HStack {
            TextField("Title", text: $title, onCommit: {
                task.title = title
                viewModel.saveTask(task)
                isEditing = false
                editingTaskId = nil
            })
            .textFieldStyle(PlainTextFieldStyle())
            Spacer()
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .onTapGesture {
                    viewModel.toggleTaskCompletion(task: task)
                    editingTaskId = nil
                }
        }
        .onChange(of: editingTaskId) {
            if editingTaskId != task.id {
                isEditing = false
            }
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let task = TaskEntity(context: context)
    task.title = "Sample Task"
    task.isCompleted = false
    task.taskType = "daily"
    return TaskRowView(task: task, editingTaskId: .constant(nil))
        .environment(\.managedObjectContext, context)
        .environmentObject(TasksViewModel.shared)
}
