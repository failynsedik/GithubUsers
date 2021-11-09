//
//  UserAPI.swift
//  GithubUsers
//
//  Created by Failyn Kaye Sedik on 11/10/21.
//

import Moya

/// NOTE: Should hold endpoints related to users
enum UserAPI {
    /// - Parameters:
    ///   - since: A user ID. Only return users with an ID greater than this ID.
    ///   - limit: Results per page (max 100). If `nil`, the default will be **30**.
    case getUsers(since: Int, limit: Int?)
}

// MARK: - TargetType

extension UserAPI: TargetType {
    var baseURL: URL {
        URL(string: "https://api.github.com")!
    }

    var path: String {
        switch self {
        case .getUsers:
            return "/users"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getUsers:
            return .get
        }
    }

    var sampleData: Data {
        switch self {
        case .getUsers:
            return Data()
        }
    }

    var task: Task {
        switch self {
        case let .getUsers(since, limit):
            var parameters: [String: Any] = [:]
            parameters["since"] = since

            if let limit = limit {
                parameters["per_page"] = limit
            }

            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.default
            )
        }
    }

    var headers: [String: String]? {
        [
            "Content-Type": "application/json",
            "Accept": "application/vnd.github.v3+json",
        ]
    }

    var validationType: ValidationType {
        .successCodes
    }
}

// MARK: - CachePolicyGettable

extension UserAPI: CachePolicyGettable {
    var cachePolicy: URLRequest.CachePolicy {
        switch self {
        case .getUsers:
            return .returnCacheDataElseLoad
        }
    }
}
