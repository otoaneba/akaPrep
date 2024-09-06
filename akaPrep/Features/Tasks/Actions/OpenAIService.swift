//
//  OpenAIService.swift
//  akaPrep
//
//  Created by Mengyuan Cynthia Li on 2024-06-29.
//

import Foundation

struct OpenAIService {
    private let apiKey = Config.azureOpenAIKey
    private let endpoint = Config.azureOpenAIEndpoint
    private let apiVersion = "2024-02-15-preview"
    private let deployment = "gpt-4o"
    
    func fetchTasks(prompt: String, completion: @escaping ([String]) -> Void) {
        
        guard let url = URL(string: "\(endpoint)/openai/deployments/\(deployment)/chat/completions?api-version=\(apiVersion)") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(apiKey, forHTTPHeaderField: "api-key")
        
        // Correctly structure the body to include model and messages
        let body: [String: Any] = [
            "messages": [
                ["role": "system", "content": "You are a helpful and professional midwife and pediatrician that only respond in JSON format."],
                ["role": "user", "content": prompt]
            ],
            "temperature": 0.7,
            "max_tokens": 256,
            "top_p": 0.95
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            print("Request: \(request)")
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
                // Parse the response JSON
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let message = choices.first?["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    
                    // Clean up the response by removing the ```json and surrounding newlines
                    let cleanedJsonString = content
                        .replacingOccurrences(of: "```json\n", with: "")
                        .replacingOccurrences(of: "\n```", with: "")
                    
                    // Parse the cleaned JSON string into a dictionary
                    if let cleanedData = cleanedJsonString.data(using: .utf8),
                       let parsedResponse = try JSONSerialization.jsonObject(with: cleanedData, options: []) as? [String: Any],
                       let tasks = parsedResponse["tasks"] as? [String] {
                        // Call the completion handler with the tasks
                        completion(tasks)
                    } else {
                        print("Failed to parse cleaned response")
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
