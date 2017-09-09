//
//  GithubWebViewController.swift
//  ios-github-app
//
//  Created by Andrii Zaitsev on 8/16/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

import UIKit

class GithubWebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    public var authorizedUser: GithubUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        // Do any additional setup after loading the view.
        
        startAuthorization()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func startAuthorization() {
        let authorizationRequest = GithubConnectionManager.shared.createAuthorizationRequest()
        webView.loadRequest(authorizationRequest)
    }

    
    // MARK: - UIWebViewDelegate
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if request.url!.absoluteString.contains("http://ios-github-app.com.ua") {
            if let url = request.url {
                let code = GithubConnectionManager.shared.getCodeFrom(url: url)
                weak var weakSelf = self
                GithubConnectionManager.shared.requestToken(with: code) { (token) in
                    GithubConnectionManager.shared.loginOAuth2(using: token, completion: { (user) in
                        DispatchQueue.main.async {
                            GithubUser.authorized = user
                            GithubUser.authorized?.accessToken = token
                            
                            weakSelf?.authorizedUser = user // deprecated
                            weakSelf?.authorizedUser?.accessToken = token // deprecated
                            weakSelf?.performSegue(withIdentifier: "UnwindToLoginSegueId", sender: self)
                        }
                        
                    })
                }
            }
            return false
        }
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
