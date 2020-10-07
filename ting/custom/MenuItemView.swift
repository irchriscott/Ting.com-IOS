//
//  MenuItemView.swift
//  ting
//
//  Created by Christian Scott on 12/23/19.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit

class MenuItemView: UIView {

    open var title: String = "MenuItem" {
        didSet { self.setup() }
    }
    
    open var icon: UIImage = UIImage(named: "icon_star_filled_25_gray")! {
        didSet { self.setup() }
    }
    
    open var iconAlpha: CGFloat = 0.7 {
        didSet { self.setup() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    let iconView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-Medium", size: 15)
        view.textColor = Colors.colorGray
        return view
    }()
    
    private func setup() {
        iconView.image = self.icon
        iconView.alpha = self.iconAlpha
        titleView.text = self.title.uppercased()
        
        addSubview(iconView)
        addSubview(titleView)
        
        addConstraintsWithFormat(format: "V:|[v0(22)]|", views: iconView)
        addConstraintsWithFormat(format: "V:|[v0(22)]|", views: titleView)
        
        addConstraintsWithFormat(format: "H:|[v0(22)]-12-[v1]", views: iconView, titleView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
