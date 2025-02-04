//
//  LocalUserDataSource.swift
//  randomuser
//
//  Created by Pau on 23/1/25.
//

import Foundation

//
//  UserDefaultsDataSource.swift
//  randomuser
//
//  Created by Pau on 23/1/25.
//

import Foundation

protocol LocalUserDataSource {
    func loadPersistedUsers() -> [User]
    func saveUsers(_ users: [User])
    func loadBlacklistedUsers() -> [User]
    func saveBlacklistedUsers(_ users: [User])
    func addBlacklistedUser(_ user: User)
}

final class UserDefaultsDataSource: LocalUserDataSource {
    private let usersKey = "persisted_users"
    private let blacklistedKey = "blacklisted_users"
    
    // MARK: - Persisted Users
    
    func loadPersistedUsers() -> [User] {
        guard let data = UserDefaults.standard.data(forKey: usersKey),
              let loaded = try? JSONDecoder().decode([User].self, from: data)
        else {
            return []
        }
        return loaded
    }
    
    func saveUsers(_ users: [User]) {
        if let data = try? JSONEncoder().encode(users) {
            UserDefaults.standard.set(data, forKey: usersKey)
        }
    }
    
    // MARK: - Blacklisted Users
    
    func loadBlacklistedUsers() -> [User] {
        guard let data = UserDefaults.standard.data(forKey: blacklistedKey),
              let loaded = try? JSONDecoder().decode([User].self, from: data)
        else {
            return []
        }
        return loaded
    }
    
    func saveBlacklistedUsers(_ users: [User]) {
        if let data = try? JSONEncoder().encode(users) {
            UserDefaults.standard.set(data, forKey: blacklistedKey)
        }
    }
    
    func addBlacklistedUser(_ user: User) {
        var blacklisted = loadBlacklistedUsers()
        
        // Only add if not already in the list
        if !blacklisted.contains(user) {
            blacklisted.append(user)
        }
        saveBlacklistedUsers(blacklisted)
    }
}
