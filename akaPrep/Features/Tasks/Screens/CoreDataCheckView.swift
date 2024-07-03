//
//  CoreDataCheckView.swift
//  akaPrep
//
//  Created by Naoto Abe on 7/3/24.
//

import SwiftUI

import SwiftUI

struct CoreDataCheckView: View {
    @FetchRequest(
        entity: TaskEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \TaskEntity.title, ascending: true)]
    ) var tasks: FetchedResults<TaskEntity>
    
    var body: some View {
        List(tasks) { task in
            VStack(alignment: .leading) {
                Text(task.title ?? "Untitled")
                    .font(.headline)
                Text(task.taskType ?? "No Type")
                    .font(.subheadline)
                Text(task.isCompleted ? "Completed" : "Not Completed")
                    .font(.caption)
            }
        }
    }
}

struct CoreDataCheckView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        return CoreDataCheckView()
            .environment(\.managedObjectContext, context)
    }
}
