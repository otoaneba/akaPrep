//
//  AddNewTaskViewViewModel.swift
//  akaPrep
//
//  Created by Naoto Abe on 6/26/24.
//

import Foundation

class AddNewTaskViewViewModel: ObservableObject {
    @Published var title = ""
    @Published var date = Date()
    @Published var details: String = "" 
    @Published var showAlert = false
    @Published var isFavorite = false
    
    
    init() {}
    
    func save() {
        
    }
    
    var canSave: Bool {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        return true
    }
}
