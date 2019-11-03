//
//  UITabBarExtension.swift
//  ting
//
//  Created by Ir Christian Scott on 08/08/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import Foundation
import UIKit

extension UITabBarController {
    
    func removeLabels(){
        if let items = self.tabBar.items {
            for item in items {
                item.title = ""
                item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            }
        }
    }
}
