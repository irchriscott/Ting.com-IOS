//
//  UIApplicationExtension.swift
//  ting
//
//  Created by Christian Scott on 17/09/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
}
