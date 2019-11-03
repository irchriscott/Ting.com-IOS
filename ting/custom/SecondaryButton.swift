//
//  SecondaryButton.swift
//  ting
//
//  Created by Christian Scott on 26/08/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit

class SecondaryButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Colors.colorPrimary
        tintColor = Colors.colorWhite
        layer.cornerRadius = 5
        layer.masksToBounds = true
        setTitleColor(Colors.colorWhite, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
