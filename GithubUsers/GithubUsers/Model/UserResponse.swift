//
//  UserResponse.swift
//  GithubUsers
//
//  Created by Failyn Kaye Sedik on 11/10/21.
//

import Foundation

class UserResponse: Codable {
    let login: String
    let id: Int
    let nodeID: String?
    let avatarURL: String?
    let gravatarID: String?
    let url, htmlURL, followersURL: String?
    let followingURL, gistsURL, starredURL: String?
    let subscriptionsURL, organizationsURL, reposURL: String?
    let eventsURL: String?
    let receivedEventsURL: String?
    let type: String?
    let siteAdmin: Bool?

    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case url
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case organizationsURL = "organizations_url"
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case receivedEventsURL = "received_events_url"
        case type
        case siteAdmin = "site_admin"
    }

    init(login: String, id: Int, nodeID: String?, avatarURL: String?, gravatarID: String?, url: String?, htmlURL: String?, followersURL: String?, followingURL: String?, gistsURL: String?, starredURL: String?, subscriptionsURL: String?, organizationsURL: String?, reposURL: String?, eventsURL: String?, receivedEventsURL: String?, type: String?, siteAdmin: Bool?) {
        self.login = login
        self.id = id
        self.nodeID = nodeID
        self.avatarURL = avatarURL
        self.gravatarID = gravatarID
        self.url = url
        self.htmlURL = htmlURL
        self.followersURL = followersURL
        self.followingURL = followingURL
        self.gistsURL = gistsURL
        self.starredURL = starredURL
        self.subscriptionsURL = subscriptionsURL
        self.organizationsURL = organizationsURL
        self.reposURL = reposURL
        self.eventsURL = eventsURL
        self.receivedEventsURL = receivedEventsURL
        self.type = type
        self.siteAdmin = siteAdmin
    }
}

// MARK: User convenience initializers and mutators

extension UserResponse {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(UserResponse.self, from: data)
        self.init(login: me.login, id: me.id, nodeID: me.nodeID, avatarURL: me.avatarURL, gravatarID: me.gravatarID, url: me.url, htmlURL: me.htmlURL, followersURL: me.followersURL, followingURL: me.followingURL, gistsURL: me.gistsURL, starredURL: me.starredURL, subscriptionsURL: me.subscriptionsURL, organizationsURL: me.organizationsURL, reposURL: me.reposURL, eventsURL: me.eventsURL, receivedEventsURL: me.receivedEventsURL, type: me.type, siteAdmin: me.siteAdmin)
    }

    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func jsonData() throws -> Data {
        try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        String(data: try jsonData(), encoding: encoding)
    }
}

/*
 Sample Response

 [
 {
 "login": "octocat",
 "id": 1,
 "node_id": "MDQ6VXNlcjE=",
 "avatar_url": "https://github.com/images/error/octocat_happy.gif",
 "gravatar_id": "",
 "url": "https://api.github.com/users/octocat",
 "html_url": "https://github.com/octocat",
 "followers_url": "https://api.github.com/users/octocat/followers",
 "following_url": "https://api.github.com/users/octocat/following{/other_user}",
 "gists_url": "https://api.github.com/users/octocat/gists{/gist_id}",
 "starred_url": "https://api.github.com/users/octocat/starred{/owner}{/repo}",
 "subscriptions_url": "https://api.github.com/users/octocat/subscriptions",
 "organizations_url": "https://api.github.com/users/octocat/orgs",
 "repos_url": "https://api.github.com/users/octocat/repos",
 "events_url": "https://api.github.com/users/octocat/events{/privacy}",
 "received_events_url": "https://api.github.com/users/octocat/received_events",
 "type": "User",
 "site_admin": false
 }
 ]
 */
