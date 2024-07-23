//
//  TaskListView.swift
//  akaPrep
//
//  Created by Naoto Abe on 7/3/24.
//

import SwiftUI
import CoreData

struct TaskListView: View {
    @ObservedObject var list: ListEntity
    @State private var isEditingTitle = false
    @State private var newTitle: String
    @EnvironmentObject var tasksViewModel: TasksViewModel
    
    private var timeStamp: String = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short)
    
    init(list: ListEntity) {
        self.list = list
        _newTitle = State(initialValue: list.name ?? "")
    }

    var body: some View {
        let dateString = DateUtils.formattedDate(list.createdDate ?? Date.now)
        let lastActivated = DateUtils.formattedDate(list.lastActivated ?? Date.now)
        Text(dateString)
            .font(.system(size: 32))
            .fontWeight(.bold)  // Make the text bold
            .padding(.horizontal, 16)
            .padding(.vertical, 0)
            .frame(maxWidth: .infinity, alignment: .leading)
        Text("Last activated: \(lastActivated)")
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .foregroundColor(.secondary)
            
        List {
            ForEach(list.taskArray, id: \.self) { task in
                Text(task.title ?? "No Title")
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Activate") {
                    list.lastActivated = Date.now
                    tasksViewModel.activateList(list)
                }
                .disabled(tasksViewModel.isListActive(list))
            }
        }
        .overlay(
            VStack {
                Spacer()
                if tasksViewModel.showToast {
                    ToastView(message: tasksViewModel.toastState.rawValue)
                }
            }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .frame(maxWidth: UIScreen.main.bounds.width * 0.9)
        )
    }
}

extension View {

    private func saveContext(for list: ListEntity) {
        do {
            try list.managedObjectContext?.save()
            print("Saved list name")
        } catch {
            print("Failed to save list name: \(error)")
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
            .environment(\.managedObjectContext, context)
            .environmentObject(TasksViewModel(context: context, useSampleData: true))
    }
}
