//
//  DetailTableViewCell.swift
//  NewOMBD
//
//  Created by ben smith on 13/06/17.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    weak var delegate: saveToCoreData?
    
    @IBOutlet weak var detailTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func save(_ sender: Any) {
        delegate?.saveDetailInfo()
    }
    
    func setup(detailData: MovieDetail) {
        self.detailTitle.text = detailData.title
    }
}
