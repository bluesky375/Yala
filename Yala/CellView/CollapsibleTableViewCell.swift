//
//  CollspdiblrTableViewCell.swift
//  Yala
//
//  Created by Admin on 4/13/19.
//  Copyright © 2019 Yala. All rights reserved.
//

import UIKit

class CollapsibleTableViewCell: UITableViewCell {
    let nameLabel = UILabel()
    let detailLabel = UILabel()
    let imageIcon = UIImageView()
        
    // MARK: Initalizers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let marginGuide = contentView.layoutMarginsGuide
        
        // configure check icon
        contentView.addSubview(imageIcon)
        imageIcon.translatesAutoresizingMaskIntoConstraints = false
        imageIcon.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        imageIcon.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        imageIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageIcon.image = UIImage(named: "ic_chec")
        
        
       // nameLabel.numberOfLines = 0
        //nameLabel.font = UIFont.systemFont(ofSize: 16)
        
        // configure nameLabel
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: imageIcon.trailingAnchor, constant: 4).isActive = true
        nameLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        
        // configure detailLabel
//        contentView.addSubview(detailLabel)
//        detailLabel.lineBreakMode = .byWordWrapping
//        detailLabel.translatesAutoresizingMaskIntoConstraints = false
//        detailLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
//        detailLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
//        detailLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
//        detailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
//        detailLabel.numberOfLines = 0
//        detailLabel.font = UIFont.systemFont(ofSize: 12)
//        detailLabel.textColor = UIColor.lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
