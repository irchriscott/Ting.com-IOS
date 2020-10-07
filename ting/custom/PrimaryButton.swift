//
//  PrimaryButton.swift
//  ting
//
//  Created by Ir Christian Scott on 03/08/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit

class PrimaryButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.masksToBounds = true
        self.setLinearGradientBackgroundColor(colorOne: Colors.colorPrimary, colorTwo: Colors.colorPrimaryDark)
    }
}

class PrimaryButtonElse: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.masksToBounds = true
        self.setLinearGradientBackgroundColorElse(colorOne: Colors.colorPrimary, colorTwo: Colors.colorPrimaryDark, frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
