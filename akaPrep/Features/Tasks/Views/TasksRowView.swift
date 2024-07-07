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
    
    var body: some View {
        HStack {
            Text(task.title ?? "No Title")
            Spacer()
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .onTapGesture {
                    task.isCompleted.toggle()
                    saveTask(task)
                }
        }
    }
    
    private func saveTask(_ task: TaskEntity) {
        do {
            try task.managedObjectContext?.save()
        } catch {
            print("Failed to save task: \(error)")
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let task = TaskEntity(context: context)
    task.title = "Sample Task"
    task.isCompleted = false
    task.taskType = "daily"
    return TaskRowView(task: task)
        .environment(\.managedObjectContext, context)
}
