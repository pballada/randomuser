//
//  UserDefaultsDatasourceTests.swift
//  randomuser
//
//  Created by Pau on 23/1/25.
//

import XCTest
@testable import randomuser

class UserDefaultsDataSourceTests: XCTestCase {
    var dataSource: UserDefaultsDataSource!
    var userDefaults: UserDefaults!
    
    override func setUp() {
        super.setUp()
        // Create a unique user defaults for testing to avoid affecting the app's actual defaults
        userDefaults = UserDefaults(suiteName: "TestUserDefaults")
        
        // Reset UserDefaults before each test
        userDefaults.removePersistentDomain(forName: "TestUserDefaults")
        
        // Initialize the data source with the test user defaults
        dataSource = UserDefaultsDataSource()
    }
    
    override func tearDown() {
        // Clean up after each test
        userDefaults.removePersistentDomain(forName: "TestUserDefaults")
        userDefaults = nil
        dataSource = nil
        super.tearDown()
    }
    
    func testLoadPersistedUsers_WhenNoUsersStored_ReturnsEmptySet() {
        let users = dataSource.loadPersistedUsers()
        XCTAssertTrue(users.isEmpty)
    }
    
    func testSaveAndLoadUsers_WithValidUsers_SuccessfullySavesAndLoads() {
        
        let testUsers: Set<User> = [
            User(id: "id-1", firstName: "Alice", lastName: "Smith",  email: "alice@example.com", phone: "111", pictureURL: ""),
            User(id: "id-2", firstName: "Bob",   lastName: "Brown",  email: "bob@example.com",   phone: "222", pictureURL: "")
        ]
        
        dataSource.saveUsers(testUsers)
        let loadedUsers = dataSource.loadPersistedUsers()
        
        XCTAssertEqual(loadedUsers, testUsers)
    }
    
    func testSaveUsers_WithEmptySet_ClearsStoredUsers() {
        
        let initialUsers: Set<User> = [
            User(id: "id-1", firstName: "Alice", lastName: "Smith",  email: "alice@example.com", phone: "111", pictureURL: "")
        ]
        dataSource.saveUsers(initialUsers)
        
        dataSource.saveUsers([])
        let loadedUsers = dataSource.loadPersistedUsers()
        
        XCTAssertTrue(loadedUsers.isEmpty)
    }
    
    func testLoadBlacklistedUserIds_WhenNoIdsStored_ReturnsEmptySet() {
        let blacklistedIds = dataSource.loadBlacklistedUserIds()
        XCTAssertTrue(blacklistedIds.isEmpty)
    }
    
    func testSaveAndLoadBlacklistedUserIds_WithValidIds_SuccessfullySavesAndLoads() {

        let testBlacklistedIds: Set<String> = ["user1", "user2", "user3"]
        
        dataSource.saveBlacklistedUserIds(testBlacklistedIds)
        let loadedBlacklistedIds = dataSource.loadBlacklistedUserIds()
        
        XCTAssertEqual(loadedBlacklistedIds, testBlacklistedIds)
    }
    
    func testSaveBlacklistedUserIds_WithEmptySet_ClearsStoredBlacklistedIds() {
        
        let initialBlacklistedIds: Set<String> = ["user1", "user2"]
        dataSource.saveBlacklistedUserIds(initialBlacklistedIds)
        
        dataSource.saveBlacklistedUserIds([])
        let loadedBlacklistedIds = dataSource.loadBlacklistedUserIds()
        
        XCTAssertTrue(loadedBlacklistedIds.isEmpty)
    }
}
