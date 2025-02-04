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
        let newlyAdded = try await userRepository.fetchRandomUsers(count: request.count)
        return FetchRandomUsersResponse(newlyAddedUsers: newlyAdded)
    }
}
