//
//  UserRepositoryImplementationTests.swift
//  randomuser
//
//  Created by Pau on 23/1/25.
//

import XCTest
@testable import randomuser

final class MockRemoteUserDataSource: RemoteUserDataSource {
    var usersToReturn: [User]
    
    init(usersToReturn: [User]) {
        self.usersToReturn = usersToReturn
    }
    
    func getRandomUsers(count: Int) async throws -> [User] {
        return usersToReturn
    }
}

final class MockLocalUserDataSource: LocalUserDataSource {
    private(set) var savedUsers: Set<User>
    private(set) var blacklistedUserIds: Set<String> = []
    
    init(preloadedUsers: [User], preloadedBlacklistedIds: Set<String> = []) {
        self.savedUsers = Set(preloadedUsers)
        self.blacklistedUserIds = preloadedBlacklistedIds
    }
    
    func loadPersistedUsers() -> Set<User> {
        return savedUsers
    }
    
    func saveUsers(_ users: Set<User>) {
        savedUsers = users
    }
    
    func loadBlacklistedUserIds() -> Set<String> {
        return blacklistedUserIds
    }
    
    func saveBlacklistedUserIds(_ userIds: Set<String>) {
        blacklistedUserIds = userIds
    }
    
    func addBlacklistedUserId(_ userId: String) {
        blacklistedUserIds.insert(userId)
    }
}

final class UserRepositoryTests: XCTestCase {
    
    func test_fetchRandomUsers_addsNewUsersAndSaves() async throws {
        let existingUser = User(id: "1", firstName: "Alice", lastName: "Anderson",
                                email: "alice@test.com", phone: "111", pictureURL: "url1")
        let newUserA = User(id: "2", firstName: "Bob", lastName: "Brown",
                            email: "bob@test.com", phone: "222", pictureURL: "url2")
        let newUserB = User(id: "3", firstName: "Cathy", lastName: "Clark",
                            email: "cathy@test.com", phone: "333", pictureURL: "url3")
        
        let mockRemote = MockRemoteUserDataSource(usersToReturn: [newUserA, newUserB])
        let mockLocal = MockLocalUserDataSource(preloadedUsers: [existingUser])
        let repository = UserRepositoryImplementation(
            remoteDataSource: mockRemote,
            localDataSource: mockLocal
        )
        
        let newlyAdded = try await repository.fetchRandomUsers(count: 2)
        XCTAssertEqual(newlyAdded.count, 2)
        XCTAssertTrue(newlyAdded.contains(newUserA))
        XCTAssertTrue(newlyAdded.contains(newUserB))
        
        let allUsers = repository.getAllUsers()
        XCTAssertEqual(allUsers.count, 3)
        XCTAssertEqual(mockLocal.savedUsers.count, 3)
    }
    
    func test_fetchRandomUsers_avoidsAddingDuplicates() async throws {
        let user1 = User(id: "1", firstName: "Existing", lastName: "User",
                         email: "existing@test.com", phone: "111", pictureURL: "url1")
        let mockRemote = MockRemoteUserDataSource(usersToReturn: [user1])
        let mockLocal = MockLocalUserDataSource(preloadedUsers: [user1])
        let repository = UserRepositoryImplementation(
            remoteDataSource: mockRemote,
            localDataSource: mockLocal
        )
        
        let newlyAdded = try await repository.fetchRandomUsers(count: 1)
        XCTAssertEqual(newlyAdded.count, 0)
        
        let allUsers = repository.getAllUsers()
        XCTAssertEqual(allUsers.count, 1)
    }
    
    func test_getAllUsers_returnsCurrentlyStoredUsers() {
        let user1 = User(id: "1", firstName: "Alice", lastName: "Test",
                         email: "a@test.com", phone: "123", pictureURL: "url1")
        let user2 = User(id: "2", firstName: "Bob", lastName: "Test",
                         email: "b@test.com", phone: "456", pictureURL: "url2")
        
        let mockRemote = MockRemoteUserDataSource(usersToReturn: [])
        let mockLocal = MockLocalUserDataSource(preloadedUsers: [user1, user2])
        let repository = UserRepositoryImplementation(
            remoteDataSource: mockRemote,
            localDataSource: mockLocal
        )
        
        let allUsers = repository.getAllUsers()
        XCTAssertEqual(allUsers.count, 2)
        XCTAssertTrue(allUsers.contains(user1))
        XCTAssertTrue(allUsers.contains(user2))
    }
    
    func test_getUserById() {
        let user = User(id: "abc-123", firstName: "Foo", lastName: "Bar",
                        email: "foo@bar.com", phone: "999", pictureURL: "url")
        
        let mockRemote = MockRemoteUserDataSource(usersToReturn: [])
        let mockLocal = MockLocalUserDataSource(preloadedUsers: [user])
        let repository = UserRepositoryImplementation(
            remoteDataSource: mockRemote,
            localDataSource: mockLocal
        )
        
        let foundUser = repository.getUser(by: "abc-123")
        XCTAssertNotNil(foundUser)
        XCTAssertEqual(foundUser?.id, "abc-123")
        
        let notFound = repository.getUser(by: "XXX")
        XCTAssertNil(notFound)
    }
    
    func test_deleteUser_removesFromRepositoryAndLocal() {
        let userToKeep = User(id: "keep", firstName: "Keep", lastName: "User",
                              email: "keep@user.com", phone: "111", pictureURL: "url")
        let userToDelete = User(id: "delete", firstName: "Delete", lastName: "User",
                                email: "delete@user.com", phone: "222", pictureURL: "url")
        
        let mockRemote = MockRemoteUserDataSource(usersToReturn: [])
        let mockLocal = MockLocalUserDataSource(preloadedUsers: [userToKeep, userToDelete])
        let repository = UserRepositoryImplementation(
            remoteDataSource: mockRemote,
            localDataSource: mockLocal
        )
        
        repository.deleteUser(id: "delete")
        
        let allAfterDelete = repository.getAllUsers()
        XCTAssertEqual(allAfterDelete.count, 1)
        XCTAssertFalse(allAfterDelete.contains(userToDelete))
        
        XCTAssertEqual(mockLocal.savedUsers.count, 1)
        XCTAssertFalse(mockLocal.savedUsers.contains(userToDelete))
    }
    
    func test_findUsers_matching_query() {
        let userA = User(id: "1", firstName: "Alice", lastName: "Anderson",
                         email: "alice@demo.com", phone: "123", pictureURL: "")
        let userB = User(id: "2", firstName: "Bob", lastName: "Brown",
                         email: "bob@demo.com", phone: "456", pictureURL: "")
        let userC = User(id: "3", firstName: "Cathy", lastName: "Clark",
                         email: "cathy@demo.com", phone: "789", pictureURL: "")
        
        let mockRemote = MockRemoteUserDataSource(usersToReturn: [])
        let mockLocal = MockLocalUserDataSource(preloadedUsers: [userA, userB, userC])
        let repository = UserRepositoryImplementation(
            remoteDataSource: mockRemote,
            localDataSource: mockLocal
        )
        
        var results = repository.findUsers(matching: "")
        XCTAssertEqual(results.count, 3)
        
        results = repository.findUsers(matching: "bob")
        XCTAssertEqual(results.count, 1)
        XCTAssertTrue(results.contains(userB))
        
        results = repository.findUsers(matching: "demo")
        XCTAssertEqual(results.count, 3)
        
        results = repository.findUsers(matching: "anderson")
        XCTAssertEqual(results.count, 1)
        XCTAssertTrue(results.contains(userA))
        
        results = repository.findUsers(matching: "doesNotExist")
        XCTAssertEqual(results.count, 0)
    }
    
    func test_blacklistUser_persistsToLocalDataSource() {
        let userToBlacklist = User(id: "999", firstName: "Mark", lastName: "Zebra",
                                   email: "mark@test.com", phone: "999", pictureURL: "url")
        let mockRemote = MockRemoteUserDataSource(usersToReturn: [])
        let mockLocal = MockLocalUserDataSource(
            preloadedUsers: [userToBlacklist],
            preloadedBlacklistedIds: []
        )
        let repository = UserRepositoryImplementation(
            remoteDataSource: mockRemote,
            localDataSource: mockLocal
        )
        
        repository.deleteUser(id: "999")
        let blacklistedIds = mockLocal.loadBlacklistedUserIds()
        XCTAssertTrue(blacklistedIds.contains("999"))
    }
    
    func test_blacklistingRemovesUserFromLocalStorage() {
        let userX = User(id: "X", firstName: "Xavier", lastName: "Test",
                         email: "x@test.com", phone: "777", pictureURL: "urlX")
        let userY = User(id: "Y", firstName: "Yvonne", lastName: "Test",
                         email: "y@test.com", phone: "888", pictureURL: "urlY")
        
        let mockLocal = MockLocalUserDataSource(
            preloadedUsers: [userX, userY],
            preloadedBlacklistedIds: []
        )
        let mockRemote = MockRemoteUserDataSource(usersToReturn: [])
        let repository = UserRepositoryImplementation(
            remoteDataSource: mockRemote,
            localDataSource: mockLocal
        )
        
        repository.deleteUser(id: "X")
        let blacklisted = mockLocal.loadBlacklistedUserIds()
        XCTAssertTrue(blacklisted.contains("X"))
        
        let persistedUsers = mockLocal.loadPersistedUsers()
        XCTAssertFalse(persistedUsers.contains(where: { $0.id == "X" }))
        XCTAssertTrue(persistedUsers.contains(userY))
    }
}
