//
//  UIViewExtension.swift
//  ting
//
//  Created by Ir Christian Scott on 31/07/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func setLinearGradientBackgroundColor(colorOne: UIColor, colorTwo: UIColor){
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setLinearGradientBackgroundColorElse(colorOne: UIColor, colorTwo: UIColor, frame: CGRect){
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setGradientBackgroundColor(colorOne: UIColor, colorTwo: UIColor){
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func addConstraintsWithFormat(format: String, views: UIView...){
        var viewsDictionary = [String : UIView]()
        for (index, view) in views.enumerated(){
            let key = "v\(index)"
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func addBlackGradientLayer(frame: CGRect){
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.4).cgColor]
        gradient.locations = [0.0, 0.6]
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func addBlackGradientLayerTop(frame: CGRect){
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = [UIColor.black.withAlphaComponent(0.8).cgColor, UIColor.clear.cgColor]
        gradient.locations = [0.0, 0.8]
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func removeSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
}
