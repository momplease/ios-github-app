//
//  Repository.swift
//  ios-github-app
//
//  Created by Andrii Zaitsev on 7/24/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

import UIKit

class Repository: NSObject {
    
    public var name: String?
    
    
    // MARK: Class methods
    class func repositories(from reposArray: [Any]) -> [Repository] {
        var result = [Repository]()
        for repo in reposArray {
            if let r = repo as? [String: Any] {
                let newRepo = Repository()
                newRepo.name = r["name"] as? String
                result.append(newRepo)
            }
        }
        return result
    }
}
