//
//  CGRectExtension.swift
//  ting
//
//  Created by Christian Scott on 11/09/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit

extension CGRect {
    var originBottom: CGFloat {
        return self.origin.y + self.height
    }
}
