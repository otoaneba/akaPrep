//
//  PromptTemplate.swift
//  akaPrep
//
//  Created by Mengyuan Cynthia Li on 2024-06-29.
//

import Foundation

struct PromptTemplate {
    static func generatePrompt(taskType: String, context: String, goal: String, workSchedule: String, babyAge: String) -> String {
        return """
        As a new parent, I need a list of \(taskType) tasks for my newborn. Here are some goals to generate the tasks: \(goal). 
        
        Here are some additional context: \(context); My current work schedule is \(workSchedule); and my baby's age is \(babyAge).
        
        Please provide a list of clear and actionable tasks in a complete JSON format as follows: {"tasks": ["Task 1", "Task 2", "Task 3", ...]}.
        
        Note:
        1. Each task should be less than 8 words.
        2. Please make sure the tasks are relevant to the goal.
        3. Please make sure the tasks take the context into consideration.
        """
    }
}

