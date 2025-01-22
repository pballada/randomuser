//
//  UserRepository.swift
//  randomuser
//
//  Created by Pau on 22/1/25.
//

public protocol UserRepository {
    /// Fetch random users from the data source.
    func fetchRandomUsers(count: Int) async throws -> [User]
    
    /// Return all stored users
    func getAllUsers() -> [User]
    
    /// Return a single user if it exists in the repository.
    func getUser(by id: String) -> User?
    
    /// Deletes a specific user
    func deleteUser(id: String)
    
    /// Return users whose name, surname, or email matches the given query.
    func findUsers(matching query: String) -> [User]
}
