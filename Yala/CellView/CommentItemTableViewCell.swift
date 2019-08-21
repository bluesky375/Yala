//
//  CommentItemTableViewCell.swift
//  Yala
//
//  Created by Admin on 3/30/19.
//  Copyright © 2019 Yala. All rights reserved.
//

import UIKit

class CommentItemTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    
    var commentItem : CommentItem = CommentItem.init()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        
    }
    
    func configView(){
        lblName.text = commentItem.displayName()
        lblComment.text = commentItem.comment
        if commentItem.profileimage != nil && commentItem.profileimage != "" {
            imgUser.kf.setImage(with: URL(string: commentItem.profileimage!), placeholder: UIImage(named: "ic_profile"), options: [.cacheOriginalImage])
        } else {
            imgUser.image = UIImage.init(named: "ic_profile")
        }
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
