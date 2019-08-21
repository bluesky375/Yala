//
//  CircularUIView.swift
//  Coverati
//
//  Created by Ankita Porwal on 10/03/18.
//  Copyright © 2018 Coverati. All rights reserved.
//

import Foundation
import UIKit

class CircularUIView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
//        self.layer.masksToBounds = true
//        self.layer.borderWidth = 1
//        self.layer.borderColor = UIColor.lightGray.cgColor
    }
}
