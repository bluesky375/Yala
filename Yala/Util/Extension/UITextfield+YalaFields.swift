//
//  UITextfield+YalaFields.swift
//  Yala
//
//  Created by Ankita on 07/09/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation
import UIKit
import AAPickerView

class YalaFields: UITextField {
    
    override func awakeFromNib() {
        setup()
    }
    
    func setup() {
        layer.cornerRadius = frame.size.height/2
        clipsToBounds = true
        layer.borderColor = UIColor.init(rgb: 0x218fd8).cgColor
        layer.borderWidth = 1
    }
}

class YalaRectangularFields: UITextField {
    
    override func awakeFromNib() {
        setup()
    }
    
    func setup() {
        setBottomBorder()
    }
    
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}


class YalaTextView: UITextView {
    
    override func awakeFromNib() {
        setup()
    }
    
    func setup() {
        layer.cornerRadius = 20
        clipsToBounds = true
        layer.borderColor = UIColor.init(rgb: 0x218fd8).cgColor
        layer.borderWidth = 1
    }
}

class YalaPicker: AAPickerView {
    
    override func awakeFromNib() {
        setup()
    }
    
    func setup() {
        layer.cornerRadius = frame.size.height/2
        clipsToBounds = true
        layer.borderColor = UIColor.init(rgb: 0x218fd8).cgColor
        layer.borderWidth = 1
    }
}

class YalaUnderlinePicker: AAPickerView {
    
    override func awakeFromNib() {
        setup()
    }
    
    func setup() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
