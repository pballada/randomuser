//
//  SearchUserUseCase.swift
//  randomuser
//
//  Created by Pau on 22/1/25.
//

public struct SearchUsersRequest {
    public let query: String

    public init(query: String) {
        self.query = query
    }
}

public struct SearchUsersResponse {
    public let users: [User]
}

public protocol SearchUsersUseCase {
    func execute(request: SearchUsersRequest) -> SearchUsersResponse
}

public final class DefaultSearchUsersUseCase: SearchUsersUseCase {
    private let userRepository: UserRepository
    
    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    public func execute(request: SearchUsersRequest) -> SearchUsersResponse {
        let found = userRepository.findUsers(matching: request.query)
        return SearchUsersResponse(users: found)
    }
}
