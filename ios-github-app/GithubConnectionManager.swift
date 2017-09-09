//
//  GithubConnectionManager.swift
//  ios-github-app
//
//  Created by Andrii Zaitsev on 7/23/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

import UIKit

class GithubConnectionManager: NSObject {
    public static let shared = GithubConnectionManager()
    
    public let authorizationUrl = URL(string: "http://github.com/login/oauth/authorize/")!
    public let tokenRequestUrl = URL(string: "https://github.com/login/oauth/access_token/")!
    public let logoutUrl = URL(string: "https://github.com/logout/")!
    public let searchUrl = URL(string: "https://api.github.com/search/")!
    public let clientId = "1d2cbb9bd2bd31a8c621"
    public let clientSecret = "ca54f78732e009ca74394e1846dac7832e1c6100"
    
    public func loginOAuth2(using token: String, completion: @escaping (GithubUser?) -> Void) {
        let loginRequest = createOAuthLoginRequest(with: token)
        NetworkConnectionManager.shared.performDataRequest(with: loginRequest) { (data, response, error) in
            if data != nil {
                completion(GithubUser.user(from: data!))
            }
        }
    }
    
    public func requestToken(with code: String, completion: @escaping (String) -> Void) {
        let tokenRequest = createTokenRequest(with: code)
        URLSession.shared.dataTask(with: tokenRequest) { (data, response, error) in
            if data != nil {
                let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                if let jsonAsDictionary = json as? [String: Any] {
                    completion(jsonAsDictionary["access_token"] as! String)
                }
            }
        }.resume()
    }
    
    public func getCodeFrom(url: URL) -> String {
        var result = NSString(string: url.absoluteString)
        let keyword: NSString = "code"
        var index = result.findSubstring(keyword)
        if index != NotFound {
            index += keyword.length
            result = result.substring(from: index, to: url.absoluteString.characters.count)!
        }
        return result as String
    }
    
    public func createAuthorizationRequest() -> URLRequest {
        var urlAsString = authorizationUrl.absoluteString
        urlAsString += "?client_id=" + clientId + "&scope=repo%20user"
        return URLRequest.createGet(url: URL(string: urlAsString)!)
    }
    
    public func createTokenRequest(with code: String) -> URLRequest {
        let url = URL(string: tokenRequestUrl.absoluteString + "?"
            + "client_id=" + clientId + "&"
            + "client_secret=" + clientSecret + "&"
            + "code=" + code)
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        
        return request
    }
    
    public func createOAuthLoginRequest(with token: String) -> URLRequest {
        let url = URL(string: "https://api.github.com/user?access_token=" + token)
        return URLRequest.createGet(url: url!)
    }
    
    public func requestUserNews(for user: GithubUser, from: Int, to: Int, completion: @escaping ([News]) -> Void) {
        let urlString = user.url!.absoluteString + "/received_events" + "?" + "access_token=" + user.accessToken! + "&" + "page=" + String(from) + "&" + "per_page=" + String(to)
        
        let request = URLRequest.createGet(url: URL(string: urlString)!)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if data != nil {
                completion(News.news(from: data!))
            }
        }.resume()
    }
    
    public func requestUserAvatar(for user: GithubUser, completion: @escaping (UIImage?) -> Void) {
        NetworkConnectionManager.shared.downloadImage(by: user.avatarUrl!) { (image, response, error) in
            // response, error not used
            completion(image)
        }
    }
    
    
    public func requestUserRepositories(for user: GithubUser, completion: @escaping ([Repository]) -> (Void)) {
        var repos = [Repository]()
        let repoRequest = URLRequest(url: user.repositoriesUrl!)
        
        URLSession.shared.dataTask(with: repoRequest) { (data, response, error) in
            if data != nil {
                if let reposArray = try? JSONSerialization.jsonObject(with: data!) as? [Any] {
                    repos.append(contentsOf: Repository.repositories(from: reposArray!))
                }
            }
            completion(repos)
        }.resume()
    }
    
    public func requestUserNotifications(for user: GithubUser, completion: @escaping ([GithubNotification]) -> Void) {
        let notifications = [GithubNotification]()
        let urlString = user.url!.absoluteString + "/notifications?access_token=" + user.accessToken!
        let notificationsRequest = URLRequest.createGet(url: URL(string: urlString)!)
        URLSession.shared.dataTask(with: notificationsRequest) { (data, response, error) in
            if data != nil {
                if let json = try? JSONSerialization.jsonObject(with: data!) {
                    if json is [Any] {
                        print("UNIMPLEMENTED: Notifications")
                        completion(notifications)
                    }
                }
            }
        }.resume()
    }
    
    public func requestUserEvents(for user: GithubUser, completion: @escaping ([GithubUserEvent]) -> Void) {
        var events = [GithubUserEvent]()
        let eventsUrlString = user.eventsUrl!.absoluteString + "?access_token=" + user.accessToken!
        let eventsRequest = URLRequest.createGet(url: URL(string: eventsUrlString)!)
        URLSession.shared.dataTask(with: eventsRequest) { (data, response, error) in
            if data != nil {
                if let json = try? JSONSerialization.jsonObject(with: data!) {
                    if let eventsArray = json as? [Any] {
                        for event in eventsArray {
                            events.append(GithubUserEvent.create(from: event)!)
                        }
                        completion(events)
                    }
                }
            }
        }.resume()
    }
    
    
    public func searchRepositories(by name: String,
                                      from: Int,
                                        to: Int,
                                completion: @escaping ([Repository]) -> Void) {
        var repos = [Repository]()
        let searchString = searchUrl.absoluteString + "repositories?" + "q=\(name)" + "&page=" + String(from) + "&per_page=" + String(to)
        let searchRequest = URLRequest.createGet(url: URL(string: searchString)!)
        URLSession.shared.dataTask(with: searchRequest) { (data, response, error) in
            if data != nil {
                if let json = try? JSONSerialization.jsonObject(with: data!) as? [String: Any] {
                    if let items = json?["items"] as? [Any] {
                        repos.append(contentsOf: Repository.repositories(from: items))
                    }
                }
            }
            completion(repos)
        }.resume()
    }
    
    public func cleanCookie(for user: GithubUser) {
        let maybeCookies = HTTPCookieStorage.shared.cookies
        if let cookies = maybeCookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
    }
    
    // MARK: Deprecated
    public func loginBasic(username: String, password: String, completionHandler: @escaping ((Bool, GithubUser)) -> Void) {
        let user = GithubUser()
        var accessAllowed = false
        let userUrl = URL(string: "https://api.github.com/user")!
        var urlRequest = URLRequest(url: userUrl)
        
        let base64Encoded = (username + ":" + password).data(using: .utf8)!.base64EncodedString()
        urlRequest.setValue("Basic " + base64Encoded, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                if data != nil {
                    if httpResponse.statusCode == 200 {
                        user.password = password
                        user.name = username
                        accessAllowed = true
                    }
                    let json = try? JSONSerialization.jsonObject(with: data!, options: [.mutableContainers])
                    user.responseObject = json as? [String: Any]
                }
            }
            
            completionHandler((accessAllowed, user))
            }.resume()
    }
    
}
