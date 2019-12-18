//
//  RestaurantPromosViewController.swift
//  ting
//
//  Created by Christian Scott on 12/18/19.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class RestaurantPromosViewController: UITableViewController, IndicatorInfoProvider {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "PROMOS")
    }
}
