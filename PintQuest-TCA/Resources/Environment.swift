//
//  Environment.swift
//  PintQuest-TCA
//
//  Created by Aleksandra Generowicz on 07/05/2023.
//

import Foundation

public enum Environment {
    
    enum ConfigKey {
        static let apiURL = "API_URL"
        static let apiVersion = "API_VERSION"
    }
    
    static let apiURL: URL = {
        guard let apiURL = Environment.infoDictionary[ConfigKey.apiURL] as? String else {
            fatalError("API URL not set in plist for this environment")
        }
        guard let url = URL(string: apiURL) else {
            fatalError("API URL is invalid")
        }
        return url
    }()
    
    static let apiVersion: String = {
        guard let apiVersion = Environment.infoDictionary[ConfigKey.apiVersion] as? String else {
            fatalError("API Version not set in plist for this environment")
        }
        
        return apiVersion
    }()
 
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()
    
}
