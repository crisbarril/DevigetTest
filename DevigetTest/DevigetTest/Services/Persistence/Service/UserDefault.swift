//
//  UserDefault.swift
//  Qliq
//
//  Created by Cristian Barril on May 03, 2020.
//  Copyright © 2020 Cristian Barril. All rights reserved.
//

import Foundation

@propertyWrapper
struct UserDefault<T: Codable> {
    let key: String
    let defaultValue: T
    
    private var cache: T? = nil
    
    init(_ key: String, defaultValue: T) {
        // Check if the key is unique
        UserDefaultKeyVerification.checkUniqueKeys(key)
        
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        mutating get {
            if let cache = cache {
                return cache
            }
            
            if let objectData = UserDefaults.standard.object(forKey: key) as? Data {
                
                do {
                    let object = try JSONDecoder().decode(T.self, from: objectData)
                    cache = object
                    return object
                } catch {
                    print(error)
                }
            }
            
            return defaultValue
        }
        
        set {            
            do {
                let encoded = try JSONEncoder().encode(newValue)
                UserDefaults.standard.set(encoded, forKey: key)
                cache = newValue
            } catch {
                print(error)
            }
        }
    }
}

private struct UserDefaultKeyVerification {
    static private var allKeys: Set<String> = []
    
    static func checkUniqueKeys(_ key: String) {
        guard !allKeys.contains(key) else {
            fatalError("Duplicated key in UserDefaults. Please create a different one.")
        }
        
        allKeys.insert(key)
    }
}
