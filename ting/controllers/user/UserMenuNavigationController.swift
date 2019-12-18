//
//  UserMenuNavigationController.swift
//  ting
//
//  Created by Ir Christian Scott on 20/08/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit

class UserMenuNavigationController: UINavigationController {

    override func viewDidLoad() {
        self.viewDidLoad()
        self.navigationBar.setLinearGradientBackgroundColor(colorOne: Colors.colorPrimaryDark, colorTwo: Colors.colorPrimary)
        self.navigationBar.barTintColor = Colors.colorPrimary
    }
}
