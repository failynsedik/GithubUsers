//
//  UserTableViewCellContent.swift
//  GithubUsers
//
//  Created by Failyn Kaye Sedik on 11/10/21.
//

import Foundation

/// The model used for the data needed on `UserTableViewCell`.
struct UserTableViewCellContent {
    /// If this is `nil`, we will still show the placeholder
    let avatarURL: URL?
    /// Prepended with "@"
    let username: String
}
