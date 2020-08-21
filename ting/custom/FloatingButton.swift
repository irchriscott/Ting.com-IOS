//
//  FloatingButton.swift
//  ting
//
//  Created by Christian Scott on 17/09/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit

class FloatingButton: UIView {
    
    open var background: UIColor = Colors.colorPrimary {
        didSet { self.setup() }
    }
    
    open var icon: UIImage? = UIImage(named: "icons-plus_filled_25_gray") {
        didSet { self.setup() }
    }
    
    open var size: CGRect = CGRect(x: 0, y: 0, width: 50, height: 50) {
        didSet { self.setup() }
    }
    
    open var imageFrame: CGRect = CGRect(x: 0, y: 0, width: 22, height: 22) {
        didSet { self.setup() }
    }
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    private func setup(){
        self.backgroundColor = self.background
        self.frame = self.size
        self.imageView.frame = self.imageFrame
        self.imageView.center = self.center
        self.imageView.image = self.icon
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.masksToBounds = true
        self.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
