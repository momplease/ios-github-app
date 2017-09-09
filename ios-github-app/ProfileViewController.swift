//
//  ProfileViewController.swift
//  ios-github-app
//
//  Created by Andrii Zaitsev on 6/27/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    public var profileInfo = [Int: [Int: (cellName: String, hasSegue: Bool, segueId: String)]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileInfo.updateValue([0 : ("", false, "")], forKey: 0)
        profileInfo.updateValue([0 : ("Repositories", true, "ReposSegueId"),
                                 1 : ("Events", true, "EventsSegueId")], forKey: 1)
        
        
        tableView?.tableFooterView = UITableViewHeaderFooterView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func setupDetailProfileCell(_ cell: inout UITableViewCell?) {
        let nibCell = Bundle.main.loadNibNamed("DetailProfileTableViewCell", owner: self, options: nil)?.first as! DetailProfileTableViewCell
        nibCell.username.text = GithubUser.authorized!.login
        nibCell.imageLoadIndicator.startAnimating()
        GithubConnectionManager.shared.requestUserAvatar(for: GithubUser.authorized!) { (avatar) in
            if avatar != nil {
                DispatchQueue.main.async {
                    nibCell.imageLoadIndicator.stopAnimating()
                    nibCell.imageLoadIndicator.isHidden = true
                    nibCell.profileImage.image = avatar!
                }
            }
        }
        cell = nibCell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.layer.backgroundColor = UIColor.gray.withAlphaComponent(0.1).cgColor
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array(profileInfo[section]!.keys).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell")
        if cell == nil {
            if indexPath.section == 0 && indexPath.row == 0 {
                setupDetailProfileCell(&cell)
            } else {
                cell = ProfileTableViewCell()
                
            }
        }
        
        cell?.textLabel?.text = profileInfo[indexPath.section]?[indexPath.row]?.cellName
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 && indexPath.section == 0 {
            return 150
        } else {
            return tableView.rowHeight
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (profileInfo[indexPath.section]?[indexPath.row]?.hasSegue)! {
            performSegue(withIdentifier: (profileInfo[indexPath.section]?[indexPath.row]?.segueId)!, sender: self)
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    //}
 

}
