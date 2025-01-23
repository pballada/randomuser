//
//  UserRepositoryImplementation.swift
//  randomuser
//
//  Created by Pau on 23/1/25.
//

import Foundation

public final class UserRepositoryImplementation: UserRepository, ObservableObject {
    
    @Published private var storedUsers: Set<User> = []
    private let remoteDataSource: RemoteUserDataSource
    private let localDataSource: LocalUserDataSource
    
    init(remoteDataSource: RemoteUserDataSource,
         localDataSource: LocalUserDataSource) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
        
        // Load persisted users (if any) into memory
        self.storedUsers = localDataSource.loadPersistedUsers()
    }
    
    /// Fetch random users from remote API and merge them with stored users (avoiding duplicates).
    /// Returns just the newly added users (not all).
    public func fetchRandomUsers(count: Int) async throws -> [User] {
        let remoteUsers = try await remoteDataSource.getRandomUsers(count: count)
        
        // Filter out any users we already have
        let newUsers = remoteUsers.filter { !storedUsers.contains($0) }
        
        // Merge newly fetched users into in-memory store
        storedUsers.formUnion(newUsers)
        
        // Persist updated user set
        localDataSource.saveUsers(storedUsers)
        
        // Return only the newly added users
        return newUsers
    }
    
    /// Returns all users currently stored in memory (and persisted).
    public func getAllUsers() -> [User] {
        // Convert Set to Array and sort or transform if needed
        Array(storedUsers)
    }
    
    /// Returns a single user by matching ID, or `nil` if not found.
    public func getUser(by id: String) -> User? {
        storedUsers.first(where: { $0.id == id })
    }
    
    /// Removes a user from stored set, then persists the change.
    public func deleteUser(id: String) {
        guard let user = getUser(by: id) else { return }
        localDataSource.addBlacklistedUser(user)
        storedUsers.remove(user)
        localDataSource.saveUsers(storedUsers)
    }
    
    /// Returns users whose firstName, lastName, or email matches the given query.
    /// If query is empty, returns all users.
    public func findUsers(matching query: String) -> [User] {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else {
            return getAllUsers()
        }
        
        let lowercasedQuery = trimmedQuery.lowercased()
        
        // Filter in-memory set
        let matched = storedUsers.filter { user in
            user.firstName.lowercased().contains(lowercasedQuery) ||
            user.lastName.lowercased().contains(lowercasedQuery) ||
            user.email.lowercased().contains(lowercasedQuery)
        }
        
        return Array(matched)
    }
    
    public func getBlacklistedUsers() -> [User] {
        // Use local data source
        return Array(localDataSource.loadBlacklistedUsers())
    }
}
