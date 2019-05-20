//
//  HomeViewController.swift
//  LoginGitHub
//
//  Created by Dinh Trac on 5/18/19.
//  Copyright © 2019 Dinh Trac. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    var searchBar: UISearchBar { return searchController.searchBar }
    var isSearch = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configButtonNavigation(isSearch)
        configSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configButtonNavigation(isSearch)
    }
    
    func configButtonNavigation(_ isSearch: Bool) {
        if isSearch {
            //Navigation have 2 button
            self.navigationItem.hidesBackButton = true
            let barbutton = UIBarButtonItem(title: "Most recent", style: .plain, target: self, action: #selector(self.didTapLogout))
            let barbuttonLeft = UIBarButtonItem(title: "Most popular", style: .plain, target: self, action: #selector(self.didTapLogout))
            self.navigationItem.rightBarButtonItem = barbutton
            self.navigationItem.leftBarButtonItem = barbuttonLeft
        }else {
            //Navigation have only one button
            self.navigationItem.hidesBackButton = true
            let barbutton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.didTapLogout))
        
            self.navigationItem.rightBarButtonItem = barbutton
        }
    }
    
    @objc func didTapLogout() {
        NSLog("Did tap logout")
    }
    
    func configSearchBar() {
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchBar.showsCancelButton = true
//        searchBar.text = "oLeThiVanAnh"
        searchBar.placeholder = "Enter GitHub ID, e.g., \"oLeThiVanAnh\""
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        searchBar.delegate = self
    }

}

extension HomeViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        NSLog("did tap cancel search")
        self.isSearch = !isSearch
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSLog("Text change")
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        NSLog("begin edit")
        if isSearch == false {
            isSearch = true
        }
    }
}
