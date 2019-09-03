//
//  SlideMenuCell.swift
//  IGNFrontEnd
//
//  Created by Aramis Knox on 3/24/19.
//  Copyright © 2019 Aramis Knox. All rights reserved.
//

import UIKit

class SlideMenuCell: UICollectionViewCell {
    
    var contentTypeLabel : UILabel = {
        var label = UILabel()
        label.text = "ARTICLES"
        label.font = UIFont(name: "ArialRoundedMTBold", size: 20)
        label.textColor = UIColor.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    override var isHighlighted: Bool {
        didSet {
            contentTypeLabel.textColor = isHighlighted ? UIColor.red : UIColor.gray
        }
    }
    
    override var isSelected: Bool {
        didSet {
            contentTypeLabel.textColor = isSelected ? UIColor.red : UIColor.gray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        addSubview(contentTypeLabel)
        addConstraintsWithFormat(format: "H:[v0]", views: contentTypeLabel)
        addConstraintsWithFormat(format: "V:[v0]", views: contentTypeLabel)
        addConstraint(NSLayoutConstraint(item: contentTypeLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: contentTypeLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
