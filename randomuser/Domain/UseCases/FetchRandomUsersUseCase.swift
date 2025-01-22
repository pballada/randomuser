//
//  FetchRandomUsersUseCase.swift
//  randomuser
//
//  Created by Pau on 22/1/25.
//

/// Input parameters (if needed) for FetchRandomUsers
public struct FetchRandomUsersRequest {
    public let count: Int

    public init(count: Int) {
        self.count = count
    }
}

/// Output model, if you want to standarize the result
public struct FetchRandomUsersResponse {
    public let newlyAddedUsers: [User]
}

/// Defines how to fetch new random users and update the internal user list.
public protocol FetchRandomUsersUseCase {
    func execute(request: FetchRandomUsersRequest) async throws -> FetchRandomUsersResponse
}

public final class DefaultFetchRandomUsersUseCase: FetchRandomUsersUseCase {
    private let userRepository: UserRepository
    
    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    public func execute(request: FetchRandomUsersRequest) async throws -> FetchRandomUsersResponse {
        // Fetch new random users
        let fetchedUsers = try await userRepository.fetchRandomUsers(count: request.count)
        
        // Grab already existing users
        let existingUsers = userRepository.getAllUsers()
        let existingSet = Set(existingUsers)
        
        // Filter out duplicates
        let uniqueFetched = fetchedUsers.filter { !existingSet.contains($0) }
        
        // Return newly added users
        return FetchRandomUsersResponse(newlyAddedUsers: uniqueFetched)
    }
}
