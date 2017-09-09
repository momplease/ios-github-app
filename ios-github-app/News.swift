//
//  News.swift
//  ios-github-app
//
//  Created by Andrii Zaitsev on 8/21/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

import UIKit

class News: NSObject {
    
    struct Commit {
        public var sha: String?
        public var message: String?
    }
    
    public var avatarUrl: URL?
    public var login: String?
    public var type: String?
    public var ref: String?
    public var repoName: String?
    
    public var commits = [Commit]()
    
    // Class methods
    class func news(from responseData: Data) -> [News] {
        var result = [News]()
        if let data = try? JSONSerialization.jsonObject(with: responseData) {
            if let array = data as? [Any] {
                for item in array {
                    let news = News()
                    if let i = item as? [String: Any] {
                        if let actor = i["actor"] as? [String: Any] {
                            news.login = actor["login"] as? String
                            news.avatarUrl = URL(string: actor["avatar_url"] as! String)
                        }
                        if let payload = i["payload"] as? [String: Any] {
                            news.ref = payload["ref"] as? String
                            if let commits = payload["commits"] as? [Any] {
                                for commit in commits {
                                    if let c = commit as? [String: Any] {
                                        var com = Commit()
                                        com.sha = c["sha"] as? String
                                        com.message = c["message"] as? String
                                        news.commits.append(com)
                                    }
                                }
                            }
                        }
                        if let repo = i["repo"] as? [String: Any] {
                            news.repoName = repo["name"] as? String
                        }
                        news.type = i["type"] as? String
                    }
                    result.append(news)
                }
            }
        }
        return result
    }
}
