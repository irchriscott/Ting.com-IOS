//
//  DetailsShimmerView.swift
//  ting
//
//  Created by Christian Scott on 16/08/2020.
//  Copyright © 2020 Ir Christian Scott. All rights reserved.
//

import UIKit

class DetailsShimmerView: UIView {
    
    private let posterView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.colorVeryLightGray
        return view
    }()
    
    private let nameView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.colorVeryLightGray
        return view
    }()
    
    private let ratingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.colorVeryLightGray
        return view
    }()
    
    private let descriptionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.colorVeryLightGray
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    private func setup() {
        addSubview(posterView)
        addSubview(nameView)
        addSubview(ratingView)
        addSubview(descriptionView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: posterView)
        addConstraintsWithFormat(format: "H:|-12-[v0(200)]", views: nameView)
        addConstraintsWithFormat(format: "H:|-12-[v0(110)]", views: ratingView)
        addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: descriptionView)
        
        addConstraintsWithFormat(format: "V:|[v0(320)]-12-[v1(30)]-8-[v2(24)]-8-[v3(45)]", views: posterView, nameView, ratingView, descriptionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
