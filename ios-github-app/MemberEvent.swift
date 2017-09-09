//
//  MemberEvent.swift
//  ios-github-app
//
//  Created by Andrii Zaitsev on 8/30/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

import UIKit

class MemberEvent: GithubUserEvent {
    struct Member {
        public var login: String?
    }
    
    struct Payload {
        public var member: Member?
        public var action: String?
    }
    
    public var payload: Payload?
    
    override init(_ dictionaryEvent: [String: Any]) {
        super.init(dictionaryEvent)
        
        if let payload = dictionaryEvent["payload"] as? [String: Any] {
            var p = Payload()
            p.action = payload["action"] as? String
            if let member = payload["member"] as? [String: Any] {
                p.member = Member(login: member["login"] as? String)
            }
            self.payload = p
        }
    }
    
    override func viewDescription() -> String {
        let user = GithubUser.authorized!
        let who = payload?.member?.login ?? ""
        let repoName = repo?.name ?? ""
        return user.login! + " " + (payload?.action ?? "") + " " + who + " as a collaborator to " + repoName
    }
}
