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
    }
    
    func cellConfigration(feed:Feed){
        
        let titleLabel = UILabel()
        titleLabel.frame = CGRect.init(x: 93, y: 9, width: 260 , height: 26)
        titleLabel.text = feed.feedTitle
        self.addSubview(titleLabel)
        
        let descriptionLabel = UILabel()
        descriptionLabel.frame = CGRect.init(x: 96, y: 36, width: 257 , height: 44)
        descriptionLabel.text = feed.description
        descriptionLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        descriptionLabel.numberOfLines = 0
        descriptionLabel.sizeToFit()
        self.addSubview(descriptionLabel)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

