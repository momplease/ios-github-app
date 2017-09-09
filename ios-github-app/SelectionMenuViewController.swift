//
//  SelectionMenuViewController.swift
//  ios-github-app
//
//  Created by Andrii Zaitsev on 6/26/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

import UIKit

class SelectionMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    public var user: GithubUser?
    
    public var isFirstLaunch = true
    
    private var topContoller: BaseNavigationController?
    private var currentViewControllerName: String?
    
    @IBOutlet var tableView: UITableView!
    var menuItems: [String: String] = [:]
    var menuItemsKeys: Array<String>!
    
    // MARK: - Lazy
    
    lazy var mainStoryboard: UIStoryboard! = {
        return UIStoryboard(name: "Main", bundle: .main)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuItems.updateValue("SideSlideInNewsSegueId", forKey: "News")
        menuItems.updateValue("SideSlideInProfileSegueId", forKey: "Profile")
        menuItems.updateValue("SideSlideInNotificationsSegueId", forKey: "Notifications")
        menuItemsKeys = Array(menuItems.keys)
        
        currentViewControllerName = "News"
        performSegue(withIdentifier: "SideSlideInNewsSegueId", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "SelectionMenuCell")
        if cell == nil {
            cell = UITableViewCell()
        }
        cell?.textLabel?.text = menuItemsKeys[indexPath.row]
        return cell!
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (currentViewControllerName == menuItemsKeys[indexPath.row]) {
            topContoller?.closeViewAnimatedFully()
            return
        }
        currentViewControllerName = menuItemsKeys[indexPath.row]
        performSegue(withIdentifier: menuItems[menuItemsKeys[indexPath.row]]!, sender: self)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let nc = segue.destination as? BaseNavigationController {
            topContoller = nc
            nc.shouldAnimate = !isFirstLaunch
            
        }
        if isFirstLaunch {
            isFirstLaunch = false
        }
        
    }

   
    
}
