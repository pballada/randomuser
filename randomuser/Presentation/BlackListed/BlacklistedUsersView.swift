//
//  BlacklistedUsersView.swift
//  randomuser
//
//  Created by Pau on 23/1/25.
//

import SwiftUI

struct BlacklistedUsersView: View {
    @EnvironmentObject var userRepository: UserRepositoryImplementation
    @StateObject private var viewModel: BlacklistedUsersViewModel

    init() {
        // We can't read @EnvironmentObject here,
        // so we'll create a placeholder and replace it in .onAppear
        _viewModel = StateObject(wrappedValue: BlacklistedUsersViewModel(repository: nil))
    }

    var body: some View {
        
        List {
            ForEach(viewModel.blacklistedUsers) { user in
                UserRow(user: user)
            }
        }.onAppear {
            // If the VM needs to store the repository
            // set it now and call load
            viewModel.repository = userRepository
            viewModel.load()
        }
    }
}
