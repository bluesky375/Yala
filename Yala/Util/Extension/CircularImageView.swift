//
//  CircularImageView.swift
//  RxAppoint
//
//  Created by Ankita Porwal on 24/12/16.
//  Copyright © 2016 TechEversion. All rights reserved.
//

import UIKit

class CircularImageView: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
