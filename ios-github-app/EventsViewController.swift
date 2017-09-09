//
//  EventsViewController.swift
//  ios-github-app
//
//  Created by Andrii Zaitsev on 7/26/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    public var events: [GithubUserEvent]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        weak var ws = self
        GithubConnectionManager.shared.requestUserEvents(for: GithubUser.authorized!) { (events) in
            ws?.updateEventsInMainQueue(events)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func updateEventsInMainQueue(_ events: [GithubUserEvent]) {
        weak var ws = self
        DispatchQueue.main.async {
            ws?.events = events
            ws?.tableView?.reloadData()
        }
    }
    
    private func configureCell(_ cell: inout EventsTableViewCell, for indexPath: IndexPath) {
        let c = cell
        weak var ws = self
        GithubConnectionManager.shared.requestUserAvatar(for: GithubUser.authorized!) { (avatar) in
            let event = ws?.events![indexPath.row]
            DispatchQueue.main.async {
                c.avatarImageView.image = avatar
                c.eventTextView.text = event?.viewDescription()
            }
        }
    }
    
    // MARK: UITableViewDelegate/DataSource
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events == nil ? 0 : events!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "EventsTableViewCell") as? EventsTableViewCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("EventsTableViewCell", owner: self, options: nil)?.first as? EventsTableViewCell
        }
        configureCell(&cell!, for: indexPath)
        return cell!
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
