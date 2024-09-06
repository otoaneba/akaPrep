//
//  Config.swift
//  akaTask
//
//  Created by Mengyuan Cynthia Li on 2024-09-06.
//

import Foundation

struct Config {
    static var azureOpenAIKey: String {
        guard let filePath = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: filePath),
              let key = plist["AzureOpenAIKey"] as? String else {
            fatalError("Couldn't find key 'AzureOpenAIKey' in 'Config.plist'.")
        }
        return key
    }
    
    static var azureOpenAIEndpoint: String {
        guard let filePath = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: filePath),
              let endpoint = plist["AzureOpenAIEndpoint"] as? String else {
            fatalError("Couldn't find key 'AzureOpenAIEndpoint' in 'Config.plist'.")
        }
        return endpoint
    }
}
