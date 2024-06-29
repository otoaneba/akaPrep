//
//  Config.swift
//  akaPrep
//
//  Created by Mengyuan Cynthia Li on 2024-06-29.
//

import Foundation

struct Config {
    static var openAIAPIKey: String {
        guard let filePath = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: filePath),
              let key = plist["OpenAIAPIKey"] as? String else {
            fatalError("Couldn't find key 'OpenAIAPIKey' in 'Config.plist'.")
        }
        return key
    }
}
