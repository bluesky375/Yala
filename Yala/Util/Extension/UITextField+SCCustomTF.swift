//
//  UITextField+SCCustomTF.swift
//  SaviSchools
//
//  Created by Vishnu-Sharma on 15/09/17.
//  Copyright © 2017 TechEversion. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    enum Direction {
        case Left
        case Right
    }
    
    func AddImage(direction:Direction, imageName:String, Frame:CGRect, backgroundColor:UIColor)
    {
        let View = UIView(frame: Frame)
        View.backgroundColor = backgroundColor
        
        let imageView = UIImageView(frame: Frame)
        imageView.image = UIImage(named: imageName)
        
        View.addSubview(imageView)
        
        if Direction.Left == direction
        {
            self.leftViewMode = .always
            self.leftView = View
        }
        else
        {
            self.rightViewMode = .always
            self.rightView = View
        }
    }
    
}
