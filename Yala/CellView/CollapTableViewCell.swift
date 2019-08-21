//
//  CollapTableViewCell.swift
//  Yala
//
//  Created by Admin on 4/13/19.
//  Copyright © 2019 Yala. All rights reserved.
//

import UIKit

class CollapTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
