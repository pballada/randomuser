//
//  UserDefaultsDataSourceTests.swift
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
    
    func testLoadPersistedUsers_WhenNoUsersStored_ReturnsEmptyArray() {
        let users = dataSource.loadPersistedUsers()
        XCTAssertTrue(users.isEmpty)
    }
    
    func testSaveAndLoadUsers_WithValidUsers_SuccessfullySavesAndLoads() {
        let testUsers: [User] = [
            User(id: "id-1", firstName: "Alice", lastName: "Smith",  email: "alice@example.com", phone: "111", pictureURL: ""),
            User(id: "id-2", firstName: "Bob",   lastName: "Brown",  email: "bob@example.com",   phone: "222", pictureURL: "")
        ]
        
        dataSource.saveUsers(testUsers)
        let loadedUsers = dataSource.loadPersistedUsers()
        
        XCTAssertEqual(loadedUsers, testUsers)
    }
    
    func testSaveUsers_WithEmptyArray_ClearsStoredUsers() {
        let initialUsers: [User] = [
            User(id: "id-1", firstName: "Alice", lastName: "Smith",  email: "alice@example.com", phone: "111", pictureURL: "")
        ]
        dataSource.saveUsers(initialUsers)
        
        // Save empty array to clear all users
        dataSource.saveUsers([])
        let loadedUsers = dataSource.loadPersistedUsers()
        
        XCTAssertTrue(loadedUsers.isEmpty)
    }
    
    func testLoadBlacklistedUsers_WhenNoUsersStored_ReturnsEmptyArray() {
        let blacklistedUsers = dataSource.loadBlacklistedUsers()
        XCTAssertTrue(blacklistedUsers.isEmpty)
    }
    
    func testSaveAndLoadBlacklistedUsers_WithValidUsers_SuccessfullySavesAndLoads() {
        let testBlacklistedUsers: [User] = [
            User(id: "id-1", firstName: "Alice", lastName: "Smith",  email: "alice@example.com", phone: "111", pictureURL: ""),
            User(id: "id-2", firstName: "Bob",   lastName: "Brown",  email: "bob@example.com",   phone: "222", pictureURL: "")
        ]
        
        dataSource.saveBlacklistedUsers(testBlacklistedUsers)
        let loadedBlacklistedUsers = dataSource.loadBlacklistedUsers()
        
        XCTAssertEqual(loadedBlacklistedUsers, testBlacklistedUsers)
    }
    
    func testSaveBlacklistedUsers_WithEmptyArray_ClearsStoredBlacklistedUsers() {
        let testBlacklistedUsers: [User] = [
            User(id: "id-1", firstName: "Alice", lastName: "Smith",  email: "alice@example.com", phone: "111", pictureURL: ""),
            User(id: "id-2", firstName: "Bob",   lastName: "Brown",  email: "bob@example.com",   phone: "222", pictureURL: "")
        ]
        dataSource.saveBlacklistedUsers(testBlacklistedUsers)
        
        // Save empty array to clear blacklisted users
        dataSource.saveBlacklistedUsers([])
        let loadedBlacklistedUsers = dataSource.loadBlacklistedUsers()
        
        XCTAssertTrue(loadedBlacklistedUsers.isEmpty)
    }
}
