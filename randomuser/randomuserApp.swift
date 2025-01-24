//
//  randomuserApp.swift
//  randomuser
//
//  Created by Pau on 22/1/25.
//

import SwiftUI

@main
struct randomuserApp: App {
    var body: some Scene {
        WindowGroup {
            let networkClient = URLSessionNetworkClient()
            let remoteDataSource = RandomUserAPIDataSource(networkClient: networkClient)
            let localDataSource = UserDefaultsDataSource()
            let userRepository = UserRepositoryImplementation(
                remoteDataSource: remoteDataSource,
                localDataSource: localDataSource
            )
            
            let fetchUseCase = DefaultFetchRandomUsersUseCase(userRepository: userRepository)
            let removeUseCase = DefaultDeleteUserUseCase(userRepository: userRepository)
            let searchUseCase = DefaultSearchUsersUseCase(userRepository: userRepository)
            
            let listViewModel = UserListViewModel(fetchUseCase: fetchUseCase,
                                                  removeUseCase: removeUseCase,
                                                  searchUseCase: searchUseCase)
            
            UserListView(viewModel: listViewModel)
                .environmentObject(userRepository)
        }
    }
}
