//
//  GetUserDetailsUseCaseTests.swift
//  randomuser
//
//  Created by Pau on 22/1/25.
//

import XCTest
@testable import randomuser

final class MockUserRepositoryForDetails: UserRepository {
    
    var userById: [String: User] = [:]
    
    func fetchRandomUsers(count: Int) async throws -> [User] { [] }
    func getAllUsers() -> [User] { [] }
    
    func getUser(by id: String) -> User? {
        return userById[id]
    }
    
    func deleteUser(id: String) {}
    func findUsers(matching query: String) -> [User] { [] }
}

final class GetUserDetailsUseCaseTests: XCTestCase {
    
    func test_getUserDetails_returnsCorrectUser() {
        // GIVEN:
        let user = User(id: "detail-123", firstName: "Mark", lastName: "Green", email: "mark@example.com", phone: "444", pictureURL: "")
        
        let mockRepo = MockUserRepositoryForDetails()
        mockRepo.userById["detail-123"] = user
        
        let useCase = DefaultGetUserDetailsUseCase(userRepository: mockRepo)
        
        // WHEN:
        let request = GetUserDetailsRequest(userId: "detail-123")
        let response = useCase.execute(request: request)
        
        // THEN:
        XCTAssertNotNil(response.user, "Should return a user for 'detail-123'.")
        XCTAssertEqual(response.user?.firstName, "Mark", "User name should be 'Mark'.")
    }
    
    func test_getUserDetails_returnsNilIfUserNotFound() {
        // GIVEN:
        let mockRepo = MockUserRepositoryForDetails()
        let useCase = DefaultGetUserDetailsUseCase(userRepository: mockRepo)
        
        // WHEN:
        let request = GetUserDetailsRequest(userId: "non-existent")
        let response = useCase.execute(request: request)
        
        // THEN:
        XCTAssertNil(response.user, "Should return nil if user doesn't exist.")
    }
}
