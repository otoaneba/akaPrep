//
//  OpenAIService.swift
//  akaPrep
//
//  Created by Mengyuan Cynthia Li on 2024-06-29.
//

import Foundation

struct OpenAIService {
    private let apiKey = Config.openAIAPIKey
    
    func fetchTasks(prompt: String, completion: @escaping ([String]) -> Void) {
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Correctly structure the body to include model and messages
        let body: [String: Any] = [
            "model": "gpt-4o",
            "messages": [
                ["role": "system", "content": "You are a helpful and professional midwife and pediatrician that only respond in JSON format."],
                ["role": "user", "content": prompt]
            ],
            "temperature": 1,
            "max_tokens": 256,
            "top_p": 1,
            "frequency_penalty": 0,
            "presence_penalty": 0
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            print("Request body: \(body)")
        } catch {
            print("Failed to serialize JSON body: \(error)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching tasks: \(error.localizedDescription)")
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("Response status code: \(response.statusCode)")
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response data: \(responseString)")
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let message = choices.first?["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    
                    // Extract the JSON string from the content
                    if let jsonString = content.components(separatedBy: "```json\n").last?.components(separatedBy: "\n```").first {
                        
                        // Parse the extracted JSON string
                        if let jsonData = jsonString.data(using: .utf8),
                           let parsedResponse = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                           let tasks = parsedResponse["tasks"] as? [String] {
                            completion(tasks)
                        } else {
                            print("Failed to parse cleaned response")
                        }
                    } else {
                        print("Failed to extract JSON string from content")
                    }
                } else {
                    print("Failed to parse response as JSON")
                }
            } catch {
                print("Failed to decode JSON response: \(error)")
            }
        }
        task.resume()
    }
}
