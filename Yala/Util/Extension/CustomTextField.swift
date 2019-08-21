//
//  CustomTextField.swift
//  TWGiOS
//
//  Created by Arpit Pittie on 30/08/17.
//  Copyright © 2018 the warranty group. All rights reserved.
//

import UIKit

@IBDesignable class CustomTextField: UITextField {
    @IBInspectable var maximumCharacters: Int = 80 {
        didSet {
            limitCharacters()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        limitCharacters()
        addTarget(self, action: #selector(CustomTextField.limitCharacters), for: .editingChanged)
    }
    
    @objc func limitCharacters() {
        guard text != nil else {
            return
        }
        if (text?.characters.count)! > maximumCharacters {
            if let range = text?.index(before: (text?.endIndex)!) {
                text = text?.substring(to: range)
            }
        }
    }
}
