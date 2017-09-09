//
//  CreateEvent.swift
//  ios-github-app
//
//  Created by Andrii Zaitsev on 8/30/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

import UIKit

class CreateEvent: GithubUserEvent {
    struct Payload {
        public var refType: String?
    }
    
    public var payload: Payload?
    
    override init(_ dictionaryEvent: [String: Any]) {
        super.init(dictionaryEvent)
        if let payload = dictionaryEvent["payload"] as? [String: Any] {
            self.payload = Payload(refType: payload["ref_type"] as? String)
        }
    }
    
    override func viewDescription() -> String {
        let user = GithubUser.authorized!
        return user.login! + " created " + (payload?.refType ?? "") + " " + repo!.name!
    }
}
