//
//  RandomUserAPIDataSourceTests.swift
//  randomuser
//
//  Created by Pau on 23/1/25.
//

import XCTest
@testable import randomuser

final class MockNetworkClient: NetworkClient {
    enum MockError: Error {
        case testError
    }

    var shouldThrowError = false
    var mockedData: Data?

    func fetchData(from url: URL) async throws -> Data {
        if shouldThrowError {
            throw MockError.testError
        }
        // Return whatever data you need for your test.
        guard let data = mockedData else {
            throw MockError.testError
        }
        return data
    }
}

final class RandomUserAPIDataSourceTests: XCTestCase {

    func testGetRandomUsers_withValidData_returnsExpectedUsers() async throws {
        // 1. Create the mock client
        let mockClient = MockNetworkClient()

        // 2. Prepare some JSON that matches the expected structure
        let jsonString = """
        {
            "results": [
                {
                    "name": {
                        "title": "Mr",
                        "first": "John",
                        "last": "Doe"
                    },
                    "email": "john.doe@example.com",
                    "phone": "123-456-7890",
                    "picture": {
                        "large": "http://large.jpg",
                        "medium": "http://medium.jpg",
                        "thumbnail": "http://thumbnail.jpg"
                    },
                    "login": {
                        "uuid": "1234-5678-9012"
                    }
                }
            ]
        }
        """
        mockClient.mockedData = jsonString.data(using: .utf8)

        // 3. Create your data source
        let dataSource = RandomUserAPIDataSource(networkClient: mockClient)

        // 4. Call the method under test
        let users = try await dataSource.getRandomUsers(count: 1)

        // 5. Verify the result
        XCTAssertEqual(users.count, 1)
        let user = users[0]
        XCTAssertEqual(user.id, "1234-5678-9012")
        XCTAssertEqual(user.firstName, "John")
        XCTAssertEqual(user.lastName, "Doe")
        XCTAssertEqual(user.email, "john.doe@example.com")
        XCTAssertEqual(user.phone, "123-456-7890")
        XCTAssertEqual(user.pictureURL, "http://medium.jpg")
    }

    func testGetRandomUsers_withError_throwsError() async {
        let mockClient = MockNetworkClient()
        mockClient.shouldThrowError = true

        let dataSource = RandomUserAPIDataSource(networkClient: mockClient)
        do {
            _ = try await dataSource.getRandomUsers(count: 5)
            XCTFail("Expected to throw but did not.")
        } catch {
            // Success: we got an error
            XCTAssertTrue(error is MockNetworkClient.MockError)
        }
    }
}
