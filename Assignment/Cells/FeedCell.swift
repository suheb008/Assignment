//
//  FeedCell.swift
//  Assignment
//
//  Created by Suheb Jamadar on 28/11/17
//  Copyright © 2017 com. Assignment.com. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.profilePic.layer.borderWidth = 1.5
         self.descriptionView.numberOfLines = -1
    }

    func cellConfigration(feed:Feed){
        self.titleLabel.text = feed.feedTitle
        self.descriptionView.text = feed.description;
        self.descriptionView.sizeToFit()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

