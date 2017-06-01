//
//  ViewController.swift
//  PhotoRama-Ch20
//
//  Created by Ben Smith on 30/05/2017.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        OMDBService.searchMovieByTitle(tite: "Jaws")
        
        NotificationCenter.default.addObserver(self,
                                                selector: #selector(ViewController.notifyObservers),
                                                name:  NSNotification.Name(rawValue: "searchResults" ),
                                                object: nil)
        
    
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func notifyObservers(notification: NSNotification) {
        var searchesDict: Dictionary<String,[Search]> = notification.userInfo as! Dictionary<String,[Search]>
        var searchesArray = searchesDict["searchResults"]!
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

