//
//  FeedCell.swift
//  Assignment
//
//  Created by Suheb Jamadar on 28/11/17
//  Copyright © 2017 com. Assignment.com. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {
    
    var profilePic: UIImageView!
    var titleLabel: UILabel!
    var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // self.profilePic.layer.borderWidth = 1.5
        //self.descriptionView.numberOfLines = -1
        
    }
    
    func cellConfigration(feed:Feed){
//        
//        titleLabel = UILabel()
//        titleLabel.frame = CGRect.init(x: 93, y: 9, width: 260 , height: 26)
//        titleLabel.text = feed.feedTitle
//        self.addSubview(titleLabel)
//        titleLabel.clearsContextBeforeDrawing = true
//
//        descriptionLabel = UILabel()
//        descriptionLabel.frame = CGRect.init(x: 96, y: 36, width: 257 , height: 44)
//        descriptionLabel.text = feed.description
//        self.descriptionLabel.sizeToFit()
//        self.addSubview(descriptionLabel)
//        descriptionLabel.clearsContextBeforeDrawing = true

        //  self.descriptionView.text = feed.description;
        // self.descriptionView.sizeToFit()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

