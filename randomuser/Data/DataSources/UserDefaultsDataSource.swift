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
    func loadBlacklistedUserIds() -> Set<String>
    func saveBlacklistedUserIds(_ userIds: Set<String>)
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
    
    func loadBlacklistedUserIds() -> Set<String> {
        guard let data = UserDefaults.standard.data(forKey: blacklistedKey),
              let loaded = try? JSONDecoder().decode(Set<String>.self, from: data)
        else {
            return []
        }
        return loaded
    }
    
    func saveBlacklistedUserIds(_ userIds: Set<String>) {
        if let data = try? JSONEncoder().encode(userIds) {
            UserDefaults.standard.set(data, forKey: blacklistedKey)
        }
    }
}
