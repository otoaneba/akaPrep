//
//  TaskListView.swift
//  akaPrep
//
//  Created by Naoto Abe on 7/3/24.
//

import SwiftUI
import CoreData

struct TaskListView: View {
    let list: ListEntity

    var body: some View {
        NavigationStack {
            List {
                ForEach(list.taskArray, id: \.self) { task in
                    HStack {                        Text(task.title ?? "No Title") // Unwrap optional title
                        Spacer()
                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    }
                }
            }
            .navigationTitle(list.name ?? "No Name") // Unwrap optional name
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
    }
}
