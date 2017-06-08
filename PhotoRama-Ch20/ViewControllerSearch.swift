//
//  ViewControllerSearch.swift
//  NewOMBD
//
//  Created by Ben Smith on 08/06/2017.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import Foundation
import UIKit


extension ViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    // MARK: UISearchResultsUpdating
    @available(iOS 8.0, *)
    public func updateSearchResults(for searchController: UISearchController) {
        //Filter content for search
        if searchController.isActive && isMoreThanTwoCharacter(searchController.searchBar) && hasSearchTextChanged(searchController.searchBar) {
            
            self.searchesArray = []
            self.currentSearchText = searchController.searchBar.text!
            self.scheduledSearch(searchBar: searchController.searchBar, page: 1)
            
        }
    }
    
    func scheduledSearch(searchBar: UISearchBar, page: Int) {
        let SEARCH_DELAY_IN_MS: Int = 3
        let popTime = DispatchTime.now() + .seconds(SEARCH_DELAY_IN_MS) // change 2 to desired number of seconds

        //the value of text is retained in the thread we spawn off main queue
        let text = searchBar.text ?? ""
        
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            if text == searchBar.text {
                //CALL THE OMDB SEARCH FUNCTION HERE
                OMDBService.searchMovieByTitle(title: text)
                
            }
        }
    }

    func isMoreThanTwoCharacter(_ searchBar: UISearchBar) -> Bool {
        return (searchBar.text?.characters.count)! >= 2
    }
    
    func hasSearchTextChanged(_ searchBar: UISearchBar) -> Bool{
        return self.currentSearchText != searchBar.text
    }

    // MARK: UISearchBarDelegate

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.currentPage = 1 //when we start typing reset the current page to 1 as new results will be loaded
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.returnKeyType = UIReturnKeyType.done // because of the update search results automatically being fired keyboard must say done not search
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchController.isActive && isMoreThanTwoCharacter(searchBar) && hasSearchTextChanged(searchBar) {
            let text = searchBar.text ?? ""
            if text == searchBar.text {
                self.currentSearchText = text
                OMDBService.searchMovieByTitle(title: text)
            }
        }
    }
}
