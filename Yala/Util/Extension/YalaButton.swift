//
//  YalaButton.swift
//  Yala
//
//  Created by Ankita on 15/09/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation
import UIKit

class YalaButton: UIButton {
    
    override func awakeFromNib() {
        setup()
    }
    
    func setup() {
        layer.cornerRadius = frame.size.height/2
        clipsToBounds = true
    }
}
