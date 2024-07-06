//
//  SavedListsViewModel.swift
//  akaPrep
//
//  Created by Naoto Abe on 7/3/24.
//

import Foundation
import CoreData
import Combine

class SavedListsViewModel: ObservableObject {
    @Published var dailySavedLists: [SavedListEntity] = [] // for testing. Remove if not working, or replace dailyLists if working.
    @Published var weeklySavedLists: [SavedListEntity] = [] // for testing. Remove if not working, or replace weeklyLists if working.
    @Published var monthlySavedLists: [SavedListEntity] = [] // for testing. Remove if not working, or replace monthlyLists if working.
    
    private var context: NSManagedObjectContext
    private var cancellables = Set<AnyCancellable>()
    
    init(context: NSManagedObjectContext, tasksViewModel: TasksViewModel) {
        self.context = context
        loadLists()
        //        fetchSavedLists()
        tasksViewModel.listLikedSubject
            .sink { [weak self] in
                self?.loadLists()
            }
            .store(in: &cancellables)
    }
    
    private func loadLists() {
        let fetchSavedListRequest: NSFetchRequest<SavedListEntity> = SavedListEntity.fetchRequest()
        
        do {
            let lists = try context.fetch(fetchSavedListRequest)
            self.dailySavedLists = lists.filter { $0.frequency == .daily }
            self.weeklySavedLists = lists.filter { $0.frequency == .weekly }
            self.monthlySavedLists = lists.filter { $0.frequency == .monthly }
            print("loading lists: \(lists)")
        } catch {
            print("Failed to fetch tasks: \(error)")
        }
    }
    
    func removeList(_ list: ListEntity) {
        context.delete(list)
        saveContext()
        loadLists()
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
