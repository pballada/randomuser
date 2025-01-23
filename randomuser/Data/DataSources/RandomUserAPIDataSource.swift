//
//  RemoteUserDataSource.swift
//  randomuser
//
//  Created by Pau on 23/1/25.
//

import Foundation

protocol RemoteUserDataSource {
    func getRandomUsers(count: Int) async throws -> [User]
}

final class RandomUserAPIDataSource: RemoteUserDataSource {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func getRandomUsers(count: Int) async throws -> [User] {

        let urlString = "https://randomuser.me/api/?results=\(count)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let data = try await networkClient.fetchData(from: url)
        
        // Parse JSON
        let decoder = JSONDecoder()
        let response = try decoder.decode(RandomUserResponse.self, from: data)
        
        // Map the JSON to the Domain Model
        let domainUsers: [User] = response.results.map { result in
            User(id: result.login.uuid,
                 firstName: result.name.first,
                 lastName: result.name.last,
                 email: result.email,
                 phone: result.phone,
                 pictureURL: result.picture.medium)
        }
        
        return domainUsers
    }
}

// MARK: - API Models

struct RandomUserResponse: Codable {
    let results: [RandomUserResult]
}

struct RandomUserResult: Codable {
    let name: Name
    let email: String
    let phone: String
    let picture: Picture
    let login: Login
    
    struct Name: Codable {
        let title: String
        let first: String
        let last: String
    }
    
    struct Picture: Codable {
        let large: String
        let medium: String
        let thumbnail: String
    }
    
    struct Login: Codable {
        let uuid: String
    }
}
