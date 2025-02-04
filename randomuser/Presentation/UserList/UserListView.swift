//
//  UserListView.swift
//  randomuser
//
//  Created by Pau on 22/1/25.
//

import SwiftUI

struct UserListView: View {
    @StateObject private var viewModel: UserListViewModel
    @State private var showBlacklistedView = false
    @EnvironmentObject var userRepository: UserRepositoryImplementation
    
    init(viewModel: UserListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search by name, surname or email", text: $viewModel.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                List {
                    ForEach(viewModel.users) { user in
                        NavigationLink {
                            UserDetailView(user: user)
                        } label: {
                            UserRow(user: user)
                                .onAppear {
                                    // Infinite scroll trigger
                                    if viewModel.shouldLoadMore(currentUser: user) {
                                        Task {
                                            await viewModel.loadMoreUsers()
                                        }
                                    }
                                }
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let user = viewModel.users[index]
                            viewModel.removeUser(user)
                        }
                    }
                }
            }
            .navigationTitle("Random Users")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Blacklisted") {
                        showBlacklistedView.toggle()
                    }
                }
            }
        }
        .sheet(isPresented: $showBlacklistedView) {
            BlacklistedUsersView(viewModel: BlacklistedUsersViewModel(repository: userRepository))
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

// MARK: - Preview

// REAL PREVIEW
//struct UserListView_Previews: PreviewProvider {
//    static var previews: some View {
//        let networkClient = URLSessionNetworkClient()
//        let remoteDataSource = RandomUserAPIDataSource(networkClient: networkClient)
//        let localDataSource = UserDefaultsDataSource()
//        let userRepository = UserRepositoryImplementation(
//            remoteDataSource: remoteDataSource,
//            localDataSource: localDataSource
//        )
//        
//        let fetchUseCase = DefaultFetchRandomUsersUseCase(userRepository: userRepository)
//        let removeUseCase = DefaultDeleteUserUseCase(userRepository: userRepository)
//        let searchUseCase = DefaultSearchUsersUseCase(userRepository: userRepository)
//        
//        let listViewModel = UserListViewModel(fetchUseCase: fetchUseCase,
//                                              removeUseCase: removeUseCase,
//                                              searchUseCase: searchUseCase)
//        
//        UserListView(viewModel: listViewModel)
//    }
//}

//MOCK PREVIEW
struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        let mockUsers = [
            User(id: "1", firstName: "Alice", lastName: "Anderson", email: "alice@test.com", phone: "111", pictureURL: "https://randomuser.me/api/portraits/med/men/75.jpg"),
            User(id: "2", firstName: "Jane", lastName: "Smith", email: "jane.smith@example.com", phone: "111", pictureURL: "https://randomuser.me/api/portraits/med/women/75.jpg")
        ]
        
        let mockViewModel = UserListViewModel(
            fetchUseCase: MockFetchRandomUsersUseCase(users: mockUsers),
            removeUseCase: MockDeleteUserUseCase(),
            searchUseCase: MockSearchUsersUseCase(users: mockUsers)
        )
        
        UserListView(viewModel: mockViewModel)
    }
    
    // Mock Use Cases for Previews
    class MockFetchRandomUsersUseCase: FetchRandomUsersUseCase {

        private let users: [User]
        init(users: [User]) {
            self.users = users
        }
        func execute(request: FetchRandomUsersRequest) async throws -> FetchRandomUsersResponse {
            FetchRandomUsersResponse(newlyAddedUsers: users)
        }
    }

    class MockDeleteUserUseCase: DeleteUserUseCase {
        func execute(request: DeleteUserRequest) {}
    }

    class MockSearchUsersUseCase: SearchUsersUseCase {

        private let users: [User]
        init(users: [User]) {
            self.users = users
        }
        func execute(request: SearchUsersRequest) -> SearchUsersResponse {
            SearchUsersResponse(users: users)
        }
    }
}



