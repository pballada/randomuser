//
//  FetchRandomUsersUseCaseTests.swift
//  randomuser
//
//  Created by Pau on 22/1/25.
//

import XCTest
@testable import randomuser

final class MockUserRepository: UserRepository {
    
    var fetchRandomUsersCalled = false
    var fetchRandomUsersResult: [User] = []
    
    var getAllUsersResult: [User] = []
    
    // Conforming to UserRepository
    func fetchRandomUsers(count: Int) async throws -> [User] {
        fetchRandomUsersCalled = true
        return fetchRandomUsersResult
    }
    
    func getAllUsers() -> [User] {
        return getAllUsersResult
    }
    
    func getUser(by id: String) -> User? {
        return nil
    }
    
    func deleteUser(id: String) {}
    
    func findUsers(matching query: String) -> [User] {
        return []
    }
    
    func getBlacklistedUsers() -> [randomuser.User] {
        return []
    }
}

final class FetchRandomUsersUseCaseTests: XCTestCase {
    
    func test_execute_shouldFetchAndReturnNewlyAddedUsers() async throws {
        // GIVEN: a mock with some existing users and some new fetched users
        let existingUsers = [
            User(id: "id-1", firstName: "Alice", lastName: "Smith", email: "alice@example.com", phone: "111", pictureURL: "")
        ]
        let fetchedUsers = [
            User(id: "id-2", firstName: "Bob",   lastName: "Brown",  email: "bob@example.com",   phone: "222", pictureURL: ""),
            User(id: "id-1", firstName: "Alice", lastName: "Smith",  email: "alice@example.com", phone: "111", pictureURL: ""), // duplicate
            User(id: "id-3", firstName: "Carl",  lastName: "White",  email: "carl@example.com",  phone: "333", pictureURL: "")
        ]
        
        let mockRepo = MockUserRepository()
        mockRepo.getAllUsersResult = existingUsers
        mockRepo.fetchRandomUsersResult = fetchedUsers
        
        let useCase = DefaultFetchRandomUsersUseCase(userRepository: mockRepo)
        
        // WHEN: we call execute with request for 3 users
        let request = FetchRandomUsersRequest(count: 3)
        let response = try await useCase.execute(request: request)
        
        // THEN:
        XCTAssertTrue(mockRepo.fetchRandomUsersCalled, "Should have called fetchRandomUsers on the repository")
        
        // Expect the newly added users to exclude duplicates
        // "id-2" and "id-3" are new, "id-1" is a duplicate
        let newlyAdded = response.newlyAddedUsers.map { $0.id }
        XCTAssertEqual(newlyAdded, ["id-2", "id-3"], "Should only return newly added users (excluding duplicates).")
    }
}
