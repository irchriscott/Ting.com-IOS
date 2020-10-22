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
                var value: CGFloat = 6
                if UIDevice.largeNavbarDevices.contains(UIDevice.type) {
                    value = 6
                }
                item.imageInsets = UIEdgeInsets(top: value, left: 0, bottom: -value, right: 0)
            }
        }
    }
}
