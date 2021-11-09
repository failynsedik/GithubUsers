//
//  UserListViewModelTests.swift
//  GithubUsersTests
//
//  Created by Failyn Kaye Sedik on 11/10/21.
//

import Nimble
import XCTest
@testable import GithubUsers

// NOTE: Can be moved to its own folder
class MockUserResponse: UserResponse {
    init(login: String, id: Int, avatarURL: String?) {
        super.init(login: login, id: id, nodeID: nil, avatarURL: avatarURL, gravatarID: nil, url: nil, htmlURL: nil, followersURL: nil, followingURL: nil, gistsURL: nil, starredURL: nil, subscriptionsURL: nil, organizationsURL: nil, reposURL: nil, eventsURL: nil, receivedEventsURL: nil, type: nil, siteAdmin: nil)
    }

    required init(from _: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

// NOTE: Only added a few at the moment for the sake of starting with unit tests
class UserListViewModelTests: XCTestCase {
    override class func setUp() {
        super.setUp()
    }

    // MARK: - TableView Data Source

    func testOutOfBoundsUserCellContent() {
        // If row is out of bounds, should return nil instead of causing an
        // out of bounds crash

        let viewModel = UserListViewModel(users: [
            MockUserResponse(login: "fatto_catto", id: 1, avatarURL: "https://wallpaperaccess.com/full/106449.jpg"),
        ])

        let row = 2 // Out of bounds
        let content = viewModel.getUserCellContent(for: row)

        expect(content).to(beNil())
    }

    func testCellContentValues() {
        // Avatar URL string should be formatted to a URL format
        // and username should be prepended with "@"

        let viewModel = UserListViewModel(users: [
            MockUserResponse(login: "fatto_catto", id: 1, avatarURL: "https://wallpaperaccess.com/full/106449.jpg"),
        ])

        let row = 0 // Purrfectly within bounds!
        let content = viewModel.getUserCellContent(for: row)

        expect(content?.avatarURL).to(beAKindOf(URL.self))
        expect(content?.username).to(equal("@fatto_catto"))
    }

    func testRetainCurrentLastFetchedUserIfNil() {
        // Should retain the current value of `lastFetchedUserID` if the
        // data being checked returned nil

        // Since we're not mocking `users` here, the current value of
        // `lastFetchedUserID` should be the default 0
        let viewModel = UserListViewModel()
        viewModel.setLastFetchedUser()
        expect(viewModel.lastFetchedUserID).to(equal(0))
    }

    func testLastFetchedUserValue() {
        // The sorting should be correct. If it's correct, the first value out of
        // the sorted array should return the highest ID number, which will be
        // used for pagination

        let users = [
            MockUserResponse(login: "fatto_catto", id: 1, avatarURL: nil),
            MockUserResponse(login: "snowbell", id: 2, avatarURL: nil),
            MockUserResponse(login: "random", id: 30, avatarURL: nil),
            MockUserResponse(login: "random731", id: 4, avatarURL: nil),
            MockUserResponse(login: "random222", id: 100, avatarURL: nil),
        ]
        let viewModel = UserListViewModel(users: users)

        viewModel.setLastFetchedUser()

        expect(viewModel.lastFetchedUserID).to(equal(100))
    }
}
