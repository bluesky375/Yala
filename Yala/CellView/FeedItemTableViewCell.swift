//
//  FeedItemTableViewCell.swift
//  Yala
//
//  Created by Admin on 3/29/19.
//  Copyright © 2019 Yala. All rights reserved.
//

import UIKit

class FeedItemTableViewCell: UITableViewCell {
    

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var pplContent: UIView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblLikes: UILabel!
    
    @IBOutlet weak var btnLikeToEvent: UIButton!
    @IBOutlet weak var btnAddComment: UIButton!
    
    var feedItem : FeedItem? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0.0, y: pplContent.frame.size.height-1, width: pplContent.frame.width, height: 1.0)
        bottomBorder.backgroundColor = #colorLiteral(red: 0.9843624234, green: 0.4295871854, blue: 0.5244819522, alpha: 1)
        pplContent.layer.addSublayer(bottomBorder)
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ feedItem: FeedItem) {
        self.feedItem = feedItem
        lblName.text = feedItem.displayName()
        lblLocation.text = feedItem.location
        lblLikes.text = feedItem.likes
        
        if feedItem.profileimage != nil && feedItem.profileimage != "" {
            imgUser.kf.setImage(with: URL(string: feedItem.profileimage!), placeholder: UIImage(named: "ic_profile"), options: [.cacheOriginalImage])
//            imgUser.kf.setImage(with: URL(string: feedItem.profileimage!), placeholder: UIImage(named: "ic_profile"), options: [.cacheOriginalImage], progressBlock: nil, completionHandler: nil)
            
        } else {
            imgUser.image = UIImage.init(named: "ic_profile")
        }
    }

}
