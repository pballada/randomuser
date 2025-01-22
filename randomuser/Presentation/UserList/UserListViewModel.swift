//
//  UserListViewModel.swift
//  randomuser
//
//  Created by Pau on 22/1/25.
//

import SwiftUI
import Combine

class UserListViewModel: ObservableObject {
    @Published var users: [User]

    init() {
        self.users = [
            User(
                id: UUID().uuidString,
                firstName: "John",
                lastName: "Doe",
                email: "john@doe.com",
                phone: "2222-2222",
                pictureURL: "https://randomuser.me/api/portraits/med/men/75.jpg"
            ),
            User(
                id: UUID().uuidString,
                firstName: "Jane",
                lastName: "Smith",
                email: "jane@smith.com",
                phone: "1111-1111",
                pictureURL: "https://randomuser.me/api/portraits/med/women/85.jpg"
            )
        ]
    }
}
