//
//  ViewController.swift
//  PhotoRama-Ch20
//
//  Created by Ben Smith on 30/05/2017.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {

    var currentSearchText: String = "" //current page we are scrolling on
    var currentPage: Int = 1 //current page we are scrolling on
    let searchController = UISearchController(searchResultsController: nil)

    var searchesArray = [Search]() {
        didSet{
            //everytime savedarticles is added to or deleted from table is refreshed
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.accessibilityLabel = "search"
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.delegate = self

        
        OMDBService.searchMovieByTitle(title: "Jaws")
        NotificationCenter.default.addObserver(self,
                                                selector: #selector(ViewController.notifyObservers),
                                                name:  NSNotification.Name(rawValue: "searchResults" ),
                                                object: nil)
        
    
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func notifyObservers(notification: NSNotification) {
        var searchesDict: Dictionary<String,[Search]> = notification.userInfo as! Dictionary<String,[Search]>
        searchesArray = searchesDict["searchResults"]!
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifier", for: indexPath) as! UITableViewCell
        let movie = searchesArray[indexPath.row]
        cell.textLabel?.text = movie.title
        return cell
    }

    
    @available(iOS 8.0, *)
    public func updateSearchResults(for searchController: UISearchController) {
        //Filter content for search
        if searchController.isActive && (searchController.searchBar.text?.characters.count)! >= 2 && self.currentSearchText != searchController.searchBar.text {
            self.currentSearchText = searchController.searchBar.text!
            OMDBService.searchMovieByTitle(title: searchController.searchBar.text!)

        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.currentPage = 1 //when we start typing reset the current page to 1 as new results will be loaded
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.returnKeyType = UIReturnKeyType.done // because of the update search results automatically being fired keyboard must say done not search
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        if searchController.isActive && (searchBar.text?.characters.count)! >= 2 && self.currentSearchText != searchBar.text {
//            let text = searchBar.text ?? ""
//            if text == searchBar.text {
//                self.currentSearchText = text
//                OMDBService.searchMovieByTitle(title: text)
//            }
//        }
    }
}

