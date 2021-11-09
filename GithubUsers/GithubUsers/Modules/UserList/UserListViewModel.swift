//
//  UserListViewModel.swift
//  GithubUsers
//
//  Created by Failyn Kaye Sedik on 11/10/21.
//

import Foundation
import PromiseKit

struct UserListViewModel {
    // MARK: - Properties

    private var lastFetchedUser: Int = 0

    // MARK: - Initializer

    let networkManager: NetworkManager

    // Ready for unit testing
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
}

// MARK: - Network Calls

extension UserListViewModel {
    func getUsers() -> Promise<[UserResponse]> {
        let limit = 10
        return networkManager.request(target: .getUsers(since: lastFetchedUser, limit: limit))
    }
}
