//
//  LocalUserDataSource.swift
//  randomuser
//
//  Created by Pau on 23/1/25.
//

import Foundation

protocol LocalUserDataSource {
    func loadPersistedUsers() -> Set<User>
    func saveUsers(_ users: Set<User>)
    func loadBlacklistedUsers() -> Set<User>
    func saveBlacklistedUsers(_ users: Set<User>)
    func addBlacklistedUser(_ user: User)
}

// MARK: - Implementation using UserDefaults as a minimal example

final class UserDefaultsDataSource: LocalUserDataSource {
    private let usersKey = "persisted_users"
    private let blacklistedKey = "blacklisted_users"
    
    func loadPersistedUsers() -> Set<User> {
        guard let data = UserDefaults.standard.data(forKey: usersKey),
              let loaded = try? JSONDecoder().decode(Set<User>.self, from: data)
        else {
            return []
        }
        return loaded
    }
    
    func saveUsers(_ users: Set<User>) {
        if let data = try? JSONEncoder().encode(users) {
            UserDefaults.standard.set(data, forKey: usersKey)
        }
    }
    
    func loadBlacklistedUsers() -> Set<User> {
        guard let data = UserDefaults.standard.data(forKey: blacklistedKey),
              let loaded = try? JSONDecoder().decode(Set<User>.self, from: data)
        else {
            return []
        }
        return loaded
    }
    
    func saveBlacklistedUsers(_ users: Set<User>) {
        if let data = try? JSONEncoder().encode(users) {
            UserDefaults.standard.set(data, forKey: blacklistedKey)
        }
    }
    
    func addBlacklistedUser(_ user: User) {
        var blacklistedUsers = loadBlacklistedUsers()
        blacklistedUsers.insert(user)
        saveBlacklistedUsers(blacklistedUsers)
    }
}
