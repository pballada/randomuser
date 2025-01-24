//
//  SearchUsersUseCaseTests.swift
//  randomuser
//
//  Created by Pau on 22/1/25.
//

import XCTest
@testable import randomuser

final class MockUserRepositoryForSearch: UserRepository {

    var findUsersQuery: String?
    var findUsersResult: [User] = []
    
    func fetchRandomUsers(count: Int) async throws -> [User] { [] }
    func getAllUsers() -> [User] { [] }
    func getUser(by id: String) -> User? { nil }
    func deleteUser(id: String) {}
    
    func findUsers(matching query: String) -> [User] {
        findUsersQuery = query
        return findUsersResult
    }
    
    func getBlacklistedUsers() -> [randomuser.User] {
        return []
    }
}

final class SearchUsersUseCaseTests: XCTestCase {
    
    func test_searchUsers_returnsMatchedUsers() {
        // GIVEN:
        let mockRepo = MockUserRepositoryForSearch()
        mockRepo.findUsersResult = [
            User(id: "id-5", firstName: "Jenny", lastName: "Jones", email: "jenny@example.com", phone: "", pictureURL: "")
        ]
        
        let useCase = DefaultSearchUsersUseCase(userRepository: mockRepo)
        
        // WHEN:
        let request = SearchUsersRequest(query: "jenny")
        let response = useCase.execute(request: request)
        
        // THEN:
        XCTAssertEqual(mockRepo.findUsersQuery, "jenny", "Repository should be called with the query 'jenny'.")
        XCTAssertEqual(response.users.count, 1, "Expected 1 user in search result.")
        XCTAssertEqual(response.users.first?.firstName, "Jenny", "Expected user named 'Jenny'.")
    }
}
