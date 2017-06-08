//
//  ViewController.swift
//  PhotoRama-Ch20
//
//  Created by Ben Smith on 30/05/2017.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import UIKit
import Foundation

protocol favMovieDelegate: class {
    func favMovie(movieSearchData: Search)
}

class ViewController: UITableViewController, favMovieDelegate {

    var currentSearchText: String = "" //current page we are scrolling on
    var currentPage: Int = 1 //current page we are scrolling on
    let searchController = UISearchController(searchResultsController: nil)
    var currentMovie: Search?
    var currentDetailMovie: MovieDetail?

    var searchesArray = [Search]() {
        didSet{
            //everytime savedarticles is added to or deleted from table is refreshed
            self.tableView.reloadData()
            //added coredatae
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

        let nib = UINib(nibName: "MovieCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "MovieCell")
        
        NotificationCenter.default.addObserver(self,
                                                selector: #selector(ViewController.notifyObservers),
                                                name:  NSNotification.Name(rawValue: "searchResults" ),
                                                object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ViewController.movieDetailObserver),
                                               name:  NSNotification.Name(rawValue: "movieDetailNotification" ),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ViewController.notifyErrorResponse),
                                               name:  NSNotification.Name(rawValue: "omdbError" ),
                                               object: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func notifyObservers(notification: NSNotification) {
        var searchesDict: Dictionary<String,[Search]> = notification.userInfo as! Dictionary<String,[Search]>
        searchesArray = searchesDict["searchResults"]!
    }
    
    func notifyErrorResponse(notification: NSNotification) {
        var searchesDict: Dictionary<String,NSError> = notification.userInfo as! Dictionary<String,NSError>
        let errorObject = searchesDict["error"]!
        if let errorResponse = errorObject.userInfo["errorMessage"] as? ErrorResponse {
            let alert = UIAlertController(title: "Error", message: errorResponse.error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil ))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func movieDetailObserver(notification: NSNotification) {
        var searchesDict = notification.userInfo as! Dictionary<String,MovieDetail>
        currentDetailMovie = searchesDict["moviedetail"] as! MovieDetail
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
        let cell: MovieCell = self.tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = searchesArray[indexPath.row]
        cell.delegate = self
        cell.setDataForView(movieData: movie)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentMovie = searchesArray[indexPath.row]
        if let id = currentMovie?.imdbID {
            OMDBService.getMovieDetailsByID(ID: id)
            self.performSegue(withIdentifier: "detailView", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailView" {
            let dest = segue.destination as! DetailViewController
            dest.movieDetailObject = currentDetailMovie
        }
    }
    
    func favMovie(movieSearchData: Search) {
        //write to core data
    }
}

