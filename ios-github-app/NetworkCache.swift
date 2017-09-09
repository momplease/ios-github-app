//
//  NetworkCache.swift
//  ios-github-app
//
//  Created by Andrii Zaitsev on 8/30/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

import UIKit


// TODO: implement fully
class NetworkCache: NSObject {
    public static let shared = NetworkCache()
    
    public func put(value: Any, forKey key: String) {
        cachedValues[key] = value
    }
    
    public func cachedValue(forKey key: String) -> Any? {
        return cachedValues[key]
    }
    
    private var cachedValues = [String: Any]()
    
    private override init() {
        super.init()
    }
}
