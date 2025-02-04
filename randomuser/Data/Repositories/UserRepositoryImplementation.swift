//
//  UserRepositoryImplementation.swift
//  randomuser
//
//  Created by Pau on 23/1/25.
//

import Foundation

public final class UserRepositoryImplementation: UserRepository, ObservableObject {
    
    @Published private var storedUsers: [User] = []
    
    private let remoteDataSource: RemoteUserDataSource
    private let localDataSource: LocalUserDataSource
    
    init(remoteDataSource: RemoteUserDataSource,
         localDataSource: LocalUserDataSource) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
        
        // Load persisted users (if any) into memory
        self.storedUsers = localDataSource.loadPersistedUsers()
    }
    
    // MARK: - Fetch
    
    public func fetchRandomUsers(count: Int) async throws -> [User] {
        let remoteUsers = try await remoteDataSource.getRandomUsers(count: count)
        
        var newUsers: [User] = []
        
        // Add only those users not yet in storedUsers by id
        for user in remoteUsers {
            if !storedUsers.contains(where: { $0.id == user.id }) {
                storedUsers.append(user)
                newUsers.append(user)
            }
        }
        
        // Persist updated user list
        localDataSource.saveUsers(storedUsers)
        
        return newUsers
    }
    
    // MARK: - Get
    
    public func getAllUsers() -> [User] {
        storedUsers
    }
    
    public func getUser(by id: String) -> User? {
        storedUsers.first(where: { $0.id == id })
    }
    
    // MARK: - Delete
    
    public func deleteUser(id: String) {
        guard let user = getUser(by: id) else { return }
        
        // Move user to blacklisted
        localDataSource.addBlacklistedUser(user)
        
        // Remove from memory
        if let index = storedUsers.firstIndex(of: user) {
            storedUsers.remove(at: index)
        }
        
        // Update persistence
        localDataSource.saveUsers(storedUsers)
    }
    
    // MARK: - Search
    
    public func findUsers(matching query: String) -> [User] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            // Return all users if query is empty
            return getAllUsers()
        }
        
        let lowercased = trimmed.lowercased()
        
        return storedUsers.filter { user in
            user.firstName.lowercased().contains(lowercased) ||
            user.lastName.lowercased().contains(lowercased) ||
            user.email.lowercased().contains(lowercased)
        }
    }
    
    public func getBlacklistedUsers() -> [User] {
        localDataSource.loadBlacklistedUsers()
    }
}
