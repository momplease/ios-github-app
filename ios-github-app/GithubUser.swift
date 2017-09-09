//
//  GithubUser.swift
//  ios-github-app
//
//  Created by Andrii Zaitsev on 7/24/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

import UIKit

class GithubUser: NSObject {
    public var login: String?
    public var password: String?
    
    public var name: String?
    public var avatarUrl: URL?
    public var repositoriesUrl: URL?
    public var eventsUrl: URL?
    public var url: URL?
    public var publicReposCount: Int?
    
    public var accessToken: String?
    
    public var responseObject: [String: Any]?
    
    public func logout() {
        GithubConnectionManager.shared.cleanCookie(for: self)
    }
    
    // MARK: Class methods
    public static var authorized: GithubUser?
    
    class func user(from data: Data) -> GithubUser {
        let user = GithubUser()
        if let json = try? JSONSerialization.jsonObject(with: data) {
            if let j = json as? [String: Any] {
                
                user.responseObject = j
                
                user.login = j["login"] as? String
                user.name = j["name"] as? String
                user.avatarUrl = URL(string: j["avatar_url"] as! String)
                user.repositoriesUrl = URL(string: j["repos_url"] as! String)
                user.url = URL(string: j["url"] as! String)
                user.publicReposCount = j["public_repos"] as? Int
                
                var events = j["events_url"] as! NSString
                let i = events.findSubstring("{")
                events = events.substring(from: 0, to: i - 1)!
                user.eventsUrl = URL(string: (events as String))
            }
        }
        return user
    }
    
}
