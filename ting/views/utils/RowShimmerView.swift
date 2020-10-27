//
//  ListShimmerView.swift
//  ting
//
//  Created by Christian Scott on 11/08/2020.
//  Copyright © 2020 Ir Christian Scott. All rights reserved.
//

import UIKit

class RowShimmerView: UIView {
    
    let device = UIDevice.type
    var imageConstant: CGFloat = 80
    
    let imageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4.0
        view.clipsToBounds = true
        view.backgroundColor = Colors.colorVeryLightGray
        return view
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.colorVeryLightGray
        view.layer.cornerRadius = 2.0
        return view
    }()
    
    let contentDescriptionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.colorVeryLightGray
        view.layer.cornerRadius = 2.0
        return view
    }()
    
    let contentDetailView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.colorVeryLightGray
        view.layer.cornerRadius = 2.0
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    private func setup() {
        if UIDevice.smallDevices.contains(device) {
            imageConstant = 55
        } else if UIDevice.mediumDevices.contains(device) {
            imageConstant = 70
        }
        
        contentView.addSubview(titleView)
        contentView.addSubview(contentDescriptionView)
        contentView.addSubview(contentDetailView)
        
        contentView.addConstraintsWithFormat(format: "H:|[v0]|", views: titleView)
        contentView.addConstraintsWithFormat(format: "H:|[v0]|", views: contentDescriptionView)
        contentView.addConstraintsWithFormat(format: "H:|[v0]|", views: contentDetailView)
        
        contentView.addConstraintsWithFormat(format: "V:|[v0(22)]-8-[v1(22)]-8-[v2(22)]", views: titleView, contentDescriptionView, contentDetailView)
        
        addSubview(imageView)
        addSubview(contentView)
        
        addConstraintsWithFormat(format: "V:|-12-[v0(45)]", views: imageView)
        addConstraintsWithFormat(format: "V:|-12-[v0]", views: contentView)
        addConstraintsWithFormat(format: "H:|-12-[v0(\(imageConstant))]-12-[v1]-12-|", views: imageView, contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
