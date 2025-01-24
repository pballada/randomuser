//
//  Untitled.swift
//  randomuser
//
//  Created by Pau on 23/1/25.
//

import SwiftUI
import Combine

final class BlacklistedUsersViewModel: ObservableObject {
    var repository: UserRepositoryImplementation?
    @Published var blacklistedUsers: [User] = []

    init(repository: UserRepositoryImplementation?) {
        self.repository = repository
    }

    func load() {
        guard let repository = repository else { return }
        blacklistedUsers = repository.getBlacklistedUsers()
    }
}
