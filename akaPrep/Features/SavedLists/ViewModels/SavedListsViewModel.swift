//
//  SavedListsViewModel.swift
//  akaPrep
//
//  Created by Naoto Abe on 7/3/24.
//

import Foundation
import CoreData

class SavedListsViewModel: ObservableObject {
    @Published var savedLists: [ListEntity] = []
    private var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        fetchSavedLists()
    }
    
    func fetchSavedLists() {
        let fetchRequest: NSFetchRequest<ListEntity> = ListEntity.fetchRequest()
        
        do {
            savedLists = try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch saved lists: \(error)")
        }
    }

    func addList(name: String, frequency: ListEntity.Frequency, tasks: [TaskEntity]) {
        let newList = ListEntity(context: context)
        newList.name = name
        newList.frequency = frequency
        newList.expirationDate = Date().addingTimeInterval(24 * 60 * 60 * (frequency == .daily ? 1 : (frequency == .weekly ? 7 : 30))) // Example expiration logic
        newList.addToTasks(NSSet(array: tasks))
        
        saveContext()
        fetchSavedLists()
    }
    
    func deleteList(list: ListEntity) {
        context.delete(list)
        saveContext()
        fetchSavedLists()
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
