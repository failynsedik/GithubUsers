//
//  UserListViewModel.swift
//  GithubUsers
//
//  Created by Failyn Kaye Sedik on 11/10/21.
//

import Foundation
import PromiseKit

class UserListViewModel {
    // MARK: - Properties

    private var users: [UserResponse]
    private(set) var lastFetchedUserID: Int = 0
    var isLoading: Bool = false

    // MARK: - Initializer

    let networkManager: NetworkManager

    // Ready for unit testing
    init(networkManager: NetworkManager = NetworkManager(), users: [UserResponse] = []) {
        self.networkManager = networkManager
        self.users = users
    }
}

// MARK: - TableView Data Source

extension UserListViewModel {
    func numberOfRows() -> Int {
        users.count
    }

    func getUserCellContent(for row: Int) -> UserTableViewCellContent? {
        guard let user = users[safe: row] else { return nil }

        let avatarURL = URL(string: user.avatarURL ?? "")
        let username = "@\(user.login)"
        return UserTableViewCellContent(
            avatarURL: avatarURL,
            username: username
        )
    }
}

// MARK: - Network Layer

extension UserListViewModel {
    func clearUsers() {
        users.removeAll()
    }

    func setLastFetchedUser() {
        guard let lastFetchedUser = users.map(\.id).sorted(by: { $0 > $1 }).first else {
            // Do not update the current one if it's nil
            return
        }

        lastFetchedUserID = lastFetchedUser
    }

    func getUsers() -> Promise<[UserResponse]> {
        let limit = 10
        let promise: Promise<[UserResponse]> = networkManager.request(target: .getUsers(since: lastFetchedUserID, limit: limit))

        promise.done { [weak self] userResponse in
            self?.users.append(contentsOf: userResponse)
        }.catch { error in
            #if DEBUG
                print("❌ Error: \(error.localizedDescription)")
            #endif
        }

        return promise
    }
}
