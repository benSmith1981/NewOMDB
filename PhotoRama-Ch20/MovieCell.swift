//
//  MovieCellTableViewCell.swift
//  UItableJSONSerialisation
//
//  Created by Ben Smith on 25/01/17.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import UIKit
import Kingfisher

class MovieCell: UITableViewCell {

    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieText: UITextView!
    var movieData: Search?
    weak var delegate: favMovieDelegate?
    
    //This is called first when you are using a XIB file or from a storyboard
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //This is important method if you want to update the views contents, after it has loaded (say you receive data, important to know about
    override func layoutSubviews() {
        super.layoutSubviews()
    }

//    func setRealmDataForView (movieData : RealmSearchObject) {
//        self.movieTitle.text = movieData.title
//        if let urlString = movieData.poster {
//            let url = URL(string: urlString)
//            self.movieImageView.kf.setImage(with: url)
//        }
//    }

    func setDataForView (movieData : Search) {
        self.movieData = movieData
        self.movieTitle.text = movieData.title
        if let urlString = movieData.poster {
            let url = URL(string: urlString)
            self.movieImageView.kf.setImage(with: url)
        }
    }

    @IBAction func favouriteMovie(_ sender: AnyObject) {
        if let dataToSave = self.movieData {
            delegate?.favMovie(movieSearchData: dataToSave)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
