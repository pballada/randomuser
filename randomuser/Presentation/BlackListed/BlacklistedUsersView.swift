//
//  BlacklistedUsersView.swift
//  randomuser
//
//  Created by Pau on 23/1/25.
//

import SwiftUI

struct BlacklistedUsersView: View {
    @ObservedObject var viewModel: BlacklistedUsersViewModel

    var body: some View {
        
        List {
            ForEach(viewModel.blacklistedUsers) { user in
                UserRow(user: user)
            }
        }.onAppear {
            viewModel.load()
        }
    }
}
