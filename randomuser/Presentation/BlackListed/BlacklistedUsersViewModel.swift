//
//  Untitled.swift
//  randomuser
//
//  Created by Pau on 23/1/25.
//

import SwiftUI
import Combine

final class BlacklistedUsersViewModel: ObservableObject {
    private let repository: UserRepository
    @Published var blacklistedUsers: [User] = []
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func load() {
        blacklistedUsers = repository.getBlacklistedUsers()
    }
}
