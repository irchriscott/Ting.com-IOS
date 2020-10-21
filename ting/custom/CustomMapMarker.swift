//
//  CustomMapMarker.swift
//  ting
//
//  Created by Christian Scott on 27/08/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit

class CustomMapMarker: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Colors.colorClear
    }
    
    func setup(path: String){
        guard let url = URL(string: path) else { return }
        
        let imageView = UIView()
        imageView.frame = self.frame
        imageView.backgroundColor = Colors.colorDarkTransparent
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let image = UIImageView()
        image.image = UIImage(named: "default_user")
        image.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        image.layer.cornerRadius = image.frame.height / 2
        image.layer.borderColor = Colors.colorPrimaryDark.cgColor
        image.layer.borderWidth = 4
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        
        image.kf.setImage(
            with: url,
            placeholder: UIImage(named: "default_restaurant"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ]
        )
        imageView.addSubview(image)
        imageView.addConstraintsWithFormat(format: "H:[v0(40)]", views: image)
        imageView.addConstraintsWithFormat(format: "V:[v0(40)]", views: image)
        imageView.addConstraint(NSLayoutConstraint(item: image, attribute: .centerX, relatedBy: .equal, toItem: imageView, attribute: .centerX, multiplier: 1, constant: 0))
        imageView.addConstraint(NSLayoutConstraint(item: image, attribute: .centerY, relatedBy: .equal, toItem: imageView, attribute: .centerY, multiplier: 1, constant: 0))
        
        let triangle = TriangleView()
        triangle.frame = CGRect(x: 0, y: 0, width: 30, height: 17)
        triangle.backgroundColor = Colors.colorClear
        triangle.transform = CGAffineTransform(rotationAngle: 3.1)
        triangle.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(imageView)
        
        addConstraintsWithFormat(format: "V:|[v0(64)]|", views: imageView)
        addConstraintsWithFormat(format: "H:|[v0(64)]|", views: imageView)
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
