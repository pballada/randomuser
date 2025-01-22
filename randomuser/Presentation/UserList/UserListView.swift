//
//  UserListView.swift
//  randomuser
//
//  Created by Pau on 22/1/25.
//

import SwiftUI

struct UserListView: View {
    @StateObject private var viewModel: UserListViewModel
    
    init(viewModel: UserListViewModel = UserListViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            List(viewModel.users) { user in
                HStack(spacing: 16) {
                    AsyncImage(url: URL(string: user.pictureURL)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        // Placeholder while image loads
                        ProgressView()
                    }
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    
                    VStack(alignment: .leading) {
                        Text("\(user.firstName) \(user.lastName)")
                            .font(.headline)
                        Text(user.email)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Users")
        }
    }
}

// MARK: - Preview

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
    }
}

