//
//  Spinner.swift
//  ting
//
//  Created by Christian Scott on 25/08/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit

class Spinner: NSObject {
    
    var vSpinner: UIView?

    override init() {
        super.init()
    }
    
    func show(){
        if let window =  UIApplication.shared.keyWindow {
            let spinnerView = UIView(frame: window.bounds)
            spinnerView.backgroundColor = Colors.colorTransparent
            let ai = UIActivityIndicatorView(style: .white)
            ai.startAnimating()
            ai.center = spinnerView.center
            
            DispatchQueue.main.async {
                spinnerView.addSubview(ai)
                window.addSubview(spinnerView)
            }
            
            vSpinner = spinnerView
        }
    }
    
    func hide(){
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        }
    }
}
