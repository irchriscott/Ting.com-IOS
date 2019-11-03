//
//  PaddedTextField.swift
//  ting
//
//  Created by Ir Christian Scott on 31/07/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit
import Foundation


class PaddedTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0.0, left: 18.0, bottom: 0.0, right: 18.0)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.borderWidth = 1.0
        self.layer.borderColor = Colors.colorPrimaryDark.cgColor
        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
