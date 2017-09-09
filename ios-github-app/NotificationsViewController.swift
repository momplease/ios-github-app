//
//  NotificationsViewController.swift
//  ios-github-app
//
//  Created by Andrii Zaitsev on 7/30/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

import UIKit

class NotificationsViewController: BaseViewController {

    public var notifications: [GithubNotification]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        weak var ws = self
        GithubConnectionManager.shared.requestUserNotifications(for: GithubUser.authorized!) { (notifications) in
            ws?.updateNotificationsInMainQueue(notifications)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func updateNotificationsInMainQueue(_ notifications: [GithubNotification]) {
        weak var ws = self
        DispatchQueue.main.async {
            ws?.notifications = notifications
            ws?.tableView?.reloadData()
        }
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
