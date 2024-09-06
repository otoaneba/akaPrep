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
        I need your help to generate a list of \(taskType) tasks specifically designed for my newborn. The tasks should be concise, actionable, and focused on achieving the following goal: \(goal).

        **Here’s the context to consider:**
        - **Work schedule**: \(workSchedule)
        - **Baby’s age**: \(babyAge)
        - **Additional details**: \(context)

        **Your Task:**
        Generate a JSON list of tasks that meet the following criteria:
        - **Each task** must be **8 words or fewer**.
        - Ensure **each task aligns** with the specified goal.
        - **Consider the provided context** when designing the tasks.

        **Format the response as follows:**
        ```json
        {
          "tasks": ["Task 1", "Task 2", "Task 3", ...]
        }
        ```

        **Additional Guidelines:**
        - Prioritize clarity and relevance.
        - Focus on realistic, easy-to-complete tasks.
        - Ensure the tasks are suitable for a busy parent’s schedule.
        """
    }
}

