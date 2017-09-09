//
//  LoginViewController.swift
//  ios-github-app
//
//  Created by Andrii Zaitsev on 6/27/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    public var connectedUser: GithubUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if connectedUser != nil {
            weak var weakSelf = self
            DispatchQueue.main.async {
                weakSelf?.performSegue(withIdentifier: "LoginSegue", sender: self)
            }
        }
    }
    
    @IBAction func unwindToLogin(with segue: UIStoryboardSegue) {
        if let source = segue.source as? GithubWebViewController {
            connectedUser = source.authorizedUser
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? SelectionMenuViewController {
            destination.user = connectedUser
        }
        
    }
    

}
