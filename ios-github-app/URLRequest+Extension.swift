//
//  URLRequest+Extension.swift
//  ios-github-app
//
//  Created by Andrii Zaitsev on 9/5/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

import Foundation

extension URLRequest {
    static func createGet(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        return request
    }
}
