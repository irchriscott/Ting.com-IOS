//
//  CuisineViewCell.swift
//  ting
//
//  Created by Christian Scott on 10/08/2020.
//  Copyright © 2020 Ir Christian Scott. All rights reserved.
//

import UIKit
import Windless

class CuisineViewCell: UICollectionViewCell {
    
    var cuisine: RestaurantCategory? {
        didSet {
            if let cuisine = self.cuisine {
                imageView.load(url: URL(string: "\(URLs.hostEndPoint)\(cuisine.image)")!)
                titleView.text = cuisine.name
                cuisineView.windless.end()
            }
            self.setup()
        }
    }
    
    let cuisineView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.colorVeryLightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4.0
        return view
    }()
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 4.0
        view.image = UIImage(named: "default_restaurant")
        return view
    }()
    
    let titleView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Colors.colorWhite
        view.font = UIFont(name: "Poppins-SemiBold", size: 13.0)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    private func setup() {
        
        backgroundColor = .clear
        
        cuisineView.addSubview(imageView)
        cuisineView.addSubview(titleView)
        
        cuisineView.addConstraintsWithFormat(format: "V:|[v0(\(frame.height))]|", views: imageView)
        cuisineView.addConstraintsWithFormat(format: "H:|[v0(\(frame.width))]|", views: imageView)
        
        cuisineView.addConstraintsWithFormat(format: "H:|-8-[v0]", views: titleView)
        cuisineView.addConstraintsWithFormat(format: "V:[v0]-8-|", views: titleView)
        
        addSubview(cuisineView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: cuisineView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: cuisineView)
        
        imageView.addBlackGradientLayer(frame: CGRect(x: 0, y: bounds.height - 40, width: bounds.width, height: 40))
        
        if cuisine == nil {
            cuisineView.windless.setupWindlessableViews([imageView]).apply({ (config) in
                config.animationLayerOpacity = 0.6
                config.direction = .right
                config.duration = 2.0
                config.pauseDuration = 0.5
                config.animationLayerColor = Colors.colorLightGray
            }).start()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
