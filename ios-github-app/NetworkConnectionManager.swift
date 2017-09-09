//
//  NetworkConnectionManager.swift
//  ios-github-app
//
//  Created by Andrii Zaitsev on 9/5/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

import UIKit

class NetworkConnectionManager: NSObject {
    public static let shared = NetworkConnectionManager()
    public let urlSession = URLSession(configuration: URLSessionConfiguration.default)
    
    public func performDataRequest(with request: URLRequest, completion: @escaping(Data?, URLResponse?, Error?) -> Void) {
        urlSession.dataTask(with: request, completionHandler: completion).resume()
    }
    
    public func downloadImage(by url: URL, completion: @escaping (UIImage?, URLResponse?, Error?) -> Void) {
        let imageRequest = URLRequest.createGet(url: url)
        performDataRequest(with: imageRequest) { (data, response, error) in
            var avatar: UIImage?
            if data != nil {
                avatar = UIImage(data: data!)
            }
            completion(avatar, response, error)
        }
    }
}
