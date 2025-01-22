//
//  GetUserDetailsUseCase.swift
//  randomuser
//
//  Created by Pau on 22/1/25.
//

public struct GetUserDetailsRequest {
    public let userId: String

    public init(userId: String) {
        self.userId = userId
    }
}

public struct GetUserDetailsResponse {
    public let user: User?
}

public protocol GetUserDetailsUseCase {
    func execute(request: GetUserDetailsRequest) -> GetUserDetailsResponse
}

public final class DefaultGetUserDetailsUseCase: GetUserDetailsUseCase {
    private let userRepository: UserRepository
    
    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    /// Simply fetch a user from the repository by ID.
    public func execute(request: GetUserDetailsRequest) -> GetUserDetailsResponse {
        let user = userRepository.getUser(by: request.userId)
        return GetUserDetailsResponse(user: user)
    }
}
