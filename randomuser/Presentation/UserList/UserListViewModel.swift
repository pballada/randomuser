//
//  UserListViewModel.swift
//  randomuser
//
//  Created by Pau on 22/1/25.
//

import SwiftUI
import Combine

@MainActor
class UserListViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var searchText: String = ""
    
    private let fetchUseCase: FetchRandomUsersUseCase
    private let removeUseCase: DeleteUserUseCase
    private let searchUseCase: SearchUsersUseCase
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let fetchBatchSize = 40
    private var isLoading = false
    
    init(fetchUseCase: FetchRandomUsersUseCase,
         removeUseCase: DeleteUserUseCase,
         searchUseCase: SearchUsersUseCase) {
        
        self.fetchUseCase = fetchUseCase
        self.removeUseCase = removeUseCase
        self.searchUseCase = searchUseCase
        
        // Listen for changes in search text and trigger search
        $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] newValue in
                self?.filterUsers(with: newValue)
            }
            .store(in: &cancellables)
    }
    
    func onAppear() {
        // If users are empty, fetch initial batch
        if users.isEmpty {
            Task {
                await loadMoreUsers()
            }
        }
    }
    
    func shouldLoadMore(currentUser: User) -> Bool {
        guard let currentIndex = users.firstIndex(where: { $0.id == currentUser.id }) else {
            return false
        }
        return currentIndex >= (users.count - 5)
    }
    
    func loadMoreUsers() async {
        guard !isLoading else { return }
        isLoading = true
        
        do {
            let _ = try await fetchUseCase.execute(request: FetchRandomUsersRequest(count: fetchBatchSize))
            filterUsers(with: searchText) // refresh the displayed users
        } catch {
            print("Error fetching users: \(error)")
        }
        
        isLoading = false
    }
    
    func filterUsers(with text: String) {
        let filtered = searchUseCase.execute(request: SearchUsersRequest(query: text)).users
        users = filtered
    }
    
    func removeUser(_ user: User) {
        removeUseCase.execute(request: DeleteUserRequest(userId: user.id))
        filterUsers(with: searchText)
    }
}
