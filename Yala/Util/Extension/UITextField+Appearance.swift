//
//  UITextField+Appearance.swift
//  SaviSchools
//
//  Created by Ankita Porwal on 15/09/17.
//  Copyright © 2017 TechEversion. All rights reserved.
//

import Foundation
import UIKit

extension UITextField{
    func setBottomBorder(borderColor: UIColor) {
        self.borderStyle = UITextBorderStyle.none
        let borderLine = UIView()
        borderLine.frame = CGRect(x: 0, y: Double(self.frame.height) - 1, width: Double(self.frame.size.width), height: 1)
        
        borderLine.backgroundColor = borderColor
        self.addSubview(borderLine)
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setLeftPaddingWithImage(_ imgname:String) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.height, height: self.frame.size.height))
        let imgView = UIImageView(frame:CGRect(x: (self.frame.size.height - 15)/2, y: (self.frame.size.height - 15)/2, width: 13, height: 15))
        imgView.image = UIImage.init(named: imgname)
        imgView.contentMode = .scaleAspectFit
        paddingView.addSubview(imgView)
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
