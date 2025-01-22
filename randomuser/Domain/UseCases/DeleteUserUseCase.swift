//
//  DeleteUserUseCase.swift
//  randomuser
//
//  Created by Pau on 22/1/25.
//

public struct DeleteUserRequest {
    public let userId: String

    public init(userId: String) {
        self.userId = userId
    }
}

public protocol DeleteUserUseCase {
    func execute(request: DeleteUserRequest)
}

public final class DefaultDeleteUserUseCase: DeleteUserUseCase {
    private let userRepository: UserRepository
    
    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    public func execute(request: DeleteUserRequest) {
        userRepository.deleteUser(id: request.userId)
    }
}
