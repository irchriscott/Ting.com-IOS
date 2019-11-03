//
//  IconTextView.swift
//  ting
//
//  Created by Christian Scott on 14/09/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit

class IconTextView: UIView {
    
    open var icon: UIImage = UIImage(named: "icon_address_black")! {
        didSet { self.setup() }
    }
    
    open var iconAlpha: CGFloat = 1.0 {
        didSet { self.setup() }
    }
    
    open var text: String = "Hello World" {
        didSet { self.setup() }
    }
    
    open var textColor: UIColor = Colors.colorGray {
        didSet { self.setup() }
    }
    
    open var background: UIColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 0.7) {
        didSet { self.setup() }
    }
    
    let iconView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let textView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-Medium", size: 12)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    private func setup(){
        self.backgroundColor = self.background
        self.layer.cornerRadius = 3
        self.layer.masksToBounds = true
        
        self.iconView.image = self.icon
        self.iconView.alpha = self.iconAlpha
        
        self.textView.text = self.text
        self.textView.textColor = self.textColor
        
        self.addSubview(iconView)
        self.addSubview(textView)
        
        self.addConstraintsWithFormat(format: "V:|-5-[v0(16)]-5-|", views: iconView)
        self.addConstraintsWithFormat(format: "V:|-5-[v0]-5-|", views: textView)
        self.addConstraintsWithFormat(format: "H:|-8-[v0(16)]-5-[v1]-8-|", views: iconView, textView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
