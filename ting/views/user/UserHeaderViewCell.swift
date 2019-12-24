//
//  UserHeaderViewCell.swift
//  ting
//
//  Created by Christian Scott on 12/17/19.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit

class UserHeaderViewCell : UICollectionViewCell {
    
    let coverView: UIView = {
        let view = UIView()
        if let window = UIApplication.shared.keyWindow {
            view.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: 120)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        view.setLinearGradientBackgroundColor(colorOne: Colors.colorPrimaryDark, colorTwo: Colors.colorPrimary)
        return view
    }()
    
    let profileImageView: UIImageView = {
        let view = UIImageView()
        view.frame = CGRect(x: 0, y: 0, width: 180, height: 180)
        view.layer.cornerRadius = view.frame.size.height / 2
        view.layer.masksToBounds = true
        view.layer.borderColor = Colors.colorWhite.cgColor
        view.layer.borderWidth = 4.0
        view.image = UIImage(named: "default_user")
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    let namesLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .center
        view.font = UIFont(name: "Poppins-SemiBold", size: 20)
        view.textColor = Colors.colorGray
        return view
    }()
    
    let addressLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .center
        view.font = UIFont(name: "Poppins-Regular", size: 13)
        view.textColor = Colors.colorGray
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    func setup(){
        addSubview(coverView)
        addSubview(profileImageView)
        addSubview(namesLabel)
        addSubview(addressLabel)
        
        addConstraintsWithFormat(format: "H:|-0-[v0]-0-|", views: coverView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: coverView)
        
        addConstraintsWithFormat(format: "H:[v0(180)]", views: profileImageView)
        addConstraintsWithFormat(format: "V:|-20-[v0(180)]", views: profileImageView)
        addConstraint(NSLayoutConstraint.init(item: profileImageView, attribute: .centerX, relatedBy: .equal, toItem: coverView, attribute: .centerX, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: namesLabel, attribute: .top, relatedBy: .equal, toItem: profileImageView, attribute: .bottom, multiplier: 1, constant: 10))
        addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: namesLabel)
        addConstraintsWithFormat(format: "V:[v0(25)]", views: namesLabel)
        
        addConstraint(NSLayoutConstraint(item: addressLabel, attribute: .top, relatedBy: .equal, toItem: namesLabel, attribute: .bottom, multiplier: 1, constant: 3))
        addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: addressLabel)
        addConstraintsWithFormat(format: "V:[v0(20)]", views: addressLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
