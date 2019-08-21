//
//  CircularUIView.swift
//  Coverati
//
//  Created by Ankita Porwal on 10/03/18.
//  Copyright © 2018 Coverati. All rights reserved.
//

import UIKit

class BottomLineTextFieldView: UIView {
    
    @IBOutlet weak var textField: CustomTextField!
    @IBOutlet weak var textFieldIndicatorView: UIView!
    var contentView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupXib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupXib()
    }
    
    func setupXib() {
        contentView = loadNibFromXib()
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)
        setupAppearance()
    }
    
    func loadNibFromXib() -> UIView! {
        let view = Bundle.main.loadNibNamed("BottomLineTextFieldView", owner: self, options: nil)?[0] as! UIView
        return view
    }
    
    func setupAppearance() {
        textField.textColor = YalaThemeService.darkGrayColor()
        textField.font = YalaThemeService.openSansSemiBoldFont(ofSize: 15)
        textFieldIndicatorView.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.5607843137, blue: 0.8470588235, alpha: 1)
    }
}
