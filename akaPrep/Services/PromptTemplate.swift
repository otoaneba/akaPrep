//
//  PromptTemplate.swift
//  akaPrep
//
//  Created by Mengyuan Cynthia Li on 2024-06-29.
//

import Foundation

struct PromptTemplate {
    static func generatePrompt(taskType: String, context: String) -> String {
        return """
        As a new parent, I need a list of \(taskType) tasks for my newborn. Here is some context: \(context). Please provide a list of clear and actionable tasks in a complete JSON format as follows: {"tasks": ["Task 1", "Task 2", "Task 3", ...]}. Each task should be less than 8 words.
        """
    }
}

