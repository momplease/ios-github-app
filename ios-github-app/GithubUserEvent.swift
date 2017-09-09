//
//  GithubUserEvent.swift
//  ios-github-app
//
//  Created by Andrii Zaitsev on 7/26/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

import UIKit

enum GithubEventType: String {
    case Member = "MemberEvent"
    case Create = "CreateEvent"
    
    static func type(fromString type: String) -> GithubEventType? {
        switch type {
        case "MemberEvent":
            return .Member
        case "CreateEvent":
            return .Create
        default:
            return nil
        }
    }
}

class GithubUserEvent: NSObject {
    struct Actor {
        public var login: String?
        public var avatarUrl: String?
    }
    
    struct Repo {
        public var name: String?
    }
    
    public var type: GithubEventType?
    public var actor: Actor?
    public var repo: Repo?
    
    init(_ dictionaryEvent: [String: Any]) {
        super.init()
        
        self.type = GithubEventType.type(fromString: dictionaryEvent["type"] as! String)
        
        if let actor = dictionaryEvent["actor"] as? [String: Any] {
            let actualActor = Actor(    login: actor["login"] as? String,
                                    avatarUrl: actor["avatar_url"] as? String)
            self.actor = actualActor
        }
        
        if let repository = dictionaryEvent["repo"] as? [String: Any] {
            self.repo = Repo(name: repository["name"] as? String)
        }
    }
    
    public func viewDescription() -> String {
        return (type?.rawValue)!
    }
    
    // Mark: Class Methods
    class func create(from repsonseEvent: Any) -> GithubUserEvent? {
        if let dictionaryEvent = repsonseEvent as? [String: Any] {
            let eventType = GithubEventType.type(fromString: dictionaryEvent["type"] as! String)
            if let type = eventType {
                switch type {
                case .Create:
                    return CreateEvent(dictionaryEvent)
                case .Member:
                    return MemberEvent(dictionaryEvent)
                }
            }
        }
        return nil
    }
    
}
