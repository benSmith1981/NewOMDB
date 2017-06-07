//
//  DetailViewController.swift
//  NewOMBD
//
//  Created by Ben Smith on 07/06/2017.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var movieTitle: UILabel!
    var movieDetailObject: MovieDetail?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.movieTitle.text = movieDetailObject?.title
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func savetoFavs(_ sender: Any) {
        
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
