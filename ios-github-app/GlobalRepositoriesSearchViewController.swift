//
//  GlobalRepositoriesSearchViewController.swift
//  ios-github-app
//
//  Created by Andrii Zaitsev on 7/30/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

import UIKit

class GlobalRepositoriesSearchViewController: UIViewController,
                                              UITableViewDelegate,
                                              UITableViewDataSource,
                                              UISearchResultsUpdating,
                                              UISearchBarDelegate {

    @IBOutlet weak var repositoriesTableView: UITableView!
    
    public let searchController = UISearchController(searchResultsController: nil)
    
    private var visibleRepos: (from: Int, to: Int) = (from: 0, to: 40)
    private var updateSearchResults: Bool = false
    
    public var repos = [Repository]()
    
    public var searchRepoName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.delegate = self
        navigationItem.titleView = searchController.searchBar
        navigationController?.navigationBar.isUserInteractionEnabled = true
        definesPresentationContext = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = repos[indexPath.row].name
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchRepoName = searchBar.text
        loadReposUsingSearchText()
        searchController.isActive = false
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == repos.count - 1 {
            visibleRepos.to += 40
            loadReposUsingSearchText()
        }
    }
    
    private func loadReposUsingSearchText() {
        loadRepos(for: searchRepoName!, from: visibleRepos.from, to: visibleRepos.to)
    }
    
    private func loadRepos(for name: String, from: Int, to: Int) {
        weak var ws = self
        GithubConnectionManager.shared.searchRepositories(by: name,
                                                          from: from,
                                                          to: to) { (repos) in
                                                            ws?.updateReposInMainQueue(repos)
        }
    }
    
    private func updateReposInMainQueue(_ repos: [Repository]) {
        weak var ws = self
        DispatchQueue.main.async {
            ws?.repos.append(contentsOf: repos)
            ws?.repositoriesTableView.reloadData()
        }
    }
    
    private func reloadDataInMainQueue() {
        weak var ws = self
        DispatchQueue.main.async {
            ws?.repositoriesTableView.reloadData()
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
