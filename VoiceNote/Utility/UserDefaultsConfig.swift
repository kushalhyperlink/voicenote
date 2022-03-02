//
//  UserDefaultsConfig.swift
//  VoiceNote
//
//  Created by Hyperlink on 01/03/22.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
}

struct UserDefaultsConfig {
    @UserDefault(UserDefaults.Keys.userID, defaultValue: nil)
    static var userID: String?
    
    @UserDefault(UserDefaults.Keys.nickName, defaultValue: nil)
    static var nickName: String?
}
