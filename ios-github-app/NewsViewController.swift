//
//  NewsViewController.swift
//  ios-github-app
//
//  Created by Andrii Zaitsev on 6/27/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

import UIKit

class NewsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var newsTableView: UITableView!
    private var news = [News]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weak var ws = self
        GithubConnectionManager.shared.requestUserNews(for: GithubUser.authorized!, from: 0, to: 20) { (news) in
            ws?.updateNewsInMainQueue(news)
        }
        newsTableView.allowsSelection = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    private func updateNewsInMainQueue(_ news: [News]) {
        weak var weakSelf = self
        DispatchQueue.main.async {
            weakSelf?.news = news
            weakSelf?.newsTableView.reloadData()
        }
    }
    
    private func createNewsText(_ news: News) -> String {
        let mainText = news.login! + " " + newsTypeToDescription(news.type!)! + " " + news.ref! + " " + "at" + " " + news.repoName!        
        return mainText
    }
    
    private func newsTypeToDescription(_ type: String) -> String? {
        switch type {
        case "PushEvent":
            return "pushed to"
        case "CreateEvent":
            return "created"
        default:
            return nil
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell")
        if cell == nil {
            let c = Bundle.main.loadNibNamed("NewsTableViewCell", owner: self, options: nil)?.first as! NewsTableViewCell
            
            NetworkConnectionManager.shared.downloadImage(by: news[indexPath.row].avatarUrl!, completion: { (avatar, response, error) in
                c.updateAvatarInMainQueue(avatar)
            })
            c.newsTextView.text = createNewsText(news[indexPath.row])
            
            cell = c
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
