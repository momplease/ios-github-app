//
//  RepositoriesViewController.swift
//  ios-github-app
//
//  Created by Andrii Zaitsev on 7/23/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

import UIKit

class RepositoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {

    @IBOutlet weak var tableView: UITableView!
    
    private var selectedRepositoryIndex: Int?
    
    public var repositories: [Repository]?
    
    private var filteredRepositories = [Repository]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        weak var ws = self
        GithubConnectionManager.shared.requestUserRepositories(for: GithubUser.authorized!) { (repositories) -> (Void) in
            ws?.updateReposInMainQueue(repositories)
        }
    }
    
    private func updateReposInMainQueue(_ repos: [Repository]) {
        repositories = repos
        
        weak var weakSelf = self
        DispatchQueue.main.async {
            weakSelf?.loadViewIfNeeded()
            weakSelf?.tableView.reloadData()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        definesPresentationContext = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        definesPresentationContext = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching() {
            return filteredRepositories.count
        } else {
            return repositories != nil ? repositories!.count : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell")
        if cell == nil {
            cell = UITableViewCell()
        }
        
        if isSearching() {
            cell?.textLabel?.text = filteredRepositories[indexPath.row].name
        } else {
            cell?.textLabel?.text = repositories?[indexPath.row].name
        }
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRepositoryIndex = indexPath.row
        performSegue(withIdentifier: "RepositoryDetailSegueId", sender: self)
    }

    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentFor(searchText: searchController.searchBar.text!)
    }
    
    func filterContentFor(searchText: String) {
        if let repos = repositories {
            filteredRepositories = repos.filter({ (repository) -> Bool in
                return repository.name!.contains(searchText.lowercased())
            })
        }
        
        tableView.reloadData()
    }
    
    func isSearching() -> Bool {
        return searchController.isActive && !(searchController.searchBar.text?.isEmpty)!
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch segue.identifier! {
        case "RepositoryDetailSegueId":
            if let vc = segue.destination as? RepositoryDetailViewController {
                vc.repository = repositories?[selectedRepositoryIndex!]
            }
        default: break
        }
        
    }
    

}
