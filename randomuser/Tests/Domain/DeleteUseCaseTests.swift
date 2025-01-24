//
//  DeleteUseCaseTests.swift
//  randomuser
//
//  Created by Pau on 22/1/25.
//

import XCTest
@testable import randomuser

final class MockUserRepositoryForDelete: UserRepository {
    
    var deletedUserID: String? = nil
    
    func fetchRandomUsers(count: Int) async throws -> [User] { return [] }
    func getAllUsers() -> [User] { return [] }
    func getUser(by id: String) -> User? { return nil }
    
    func deleteUser(id: String) {
        deletedUserID = id
    }
    
    func findUsers(matching query: String) -> [User] {
        return []
    }
    
    func getBlacklistedUsers() -> [randomuser.User] {
        return []
    }
}

final class DeleteUserUseCaseTests: XCTestCase {
    
    func test_deleteUser_shouldCallRepositoryDeleteWithCorrectID() {
        // GIVEN:
        let mockRepo = MockUserRepositoryForDelete()
        let useCase = DefaultDeleteUserUseCase(userRepository: mockRepo)
        
        // WHEN:
        let request = DeleteUserRequest(userId: "id-99")
        useCase.execute(request: request)
        
        // THEN:
        XCTAssertEqual(mockRepo.deletedUserID, "id-99", "User with ID 'id-99' should have been deleted.")
    }
}

