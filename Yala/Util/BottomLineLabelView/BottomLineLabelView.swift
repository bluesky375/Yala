//
//  BottomLineLabelView.swift
//  TWGiOS
//
//  Created by Ankita Porwal on 18/07/17.
//  Copyright © 2018 the warranty group. All rights reserved.
//

import UIKit

class BottomLineLabelView: UIView {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var labelIndicatorView: UIView!
    @IBOutlet weak var verticalSpaceFromBottomLineToTextView: NSLayoutConstraint!
    
    var contentView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupXib()
        setupAppearance()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupXib()
        setupAppearance()
    }
    
    func setupXib() {
        contentView = loadNibFromXib()
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)
    }
    
    func loadNibFromXib() -> UIView! {
        let view = Bundle.main.loadNibNamed("BottomLineLabelView", owner: self, options: nil)?[0] as! UIView
        return view
    }
    
    func updateVerticalSpaceBetweenBottomLineAndTextView(_ value: CGFloat) {
        verticalSpaceFromBottomLineToTextView.constant = value
    }
}

// MARK: Appearance methods

extension BottomLineLabelView {
    
    func setupAppearance() {
        setupFontColor()
        setupFontFamily()
    }
    
    func setupFontColor() {
        label.textColor = AppManager.theme.charcoalGrayColor()
    }
    
    func setupFontFamily() {
        label.font = AppManager.theme.sourceSansProRegularFont(ofSize: 14)
    }
}
