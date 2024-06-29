//
//  AkaListViewViewModel.swift
//  akaPrep
//
//  Created by Naoto Abe on 6/26/24.
//

import Foundation

class AkaPrepViewViewModel: ObservableObject {
    @Published var showingAddNewTaskView = false
    @Published var tasks: [TaskItem] = []
    private let openAIService = OpenAIService()
    
    func generateTasks(taskType: String, context: String) {
        let prompt = PromptTemplate.generatePrompt(taskType: taskType, context: context)
        openAIService.fetchTasks(prompt: prompt) { [weak self] generatedTasks in
            DispatchQueue.main.async {
                self?.tasks = generatedTasks.map { TaskItem(title: $0) }
            }
        }
    }
    
    
    init() {}

}

struct TaskItem: Identifiable {
    let id = UUID()
    let title: String
    var isCompleted: Bool = false
}
