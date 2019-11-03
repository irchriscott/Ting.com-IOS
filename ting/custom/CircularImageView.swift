//
//  CircularImageView.swift
//  ting
//
//  Created by Ir Christian Scott on 19/08/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit

class CircularImageView: UIImageView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.masksToBounds = true
        self.layer.borderColor = Colors.colorVeryLightGray.cgColor
        self.layer.borderWidth = 2.0
    }

}
