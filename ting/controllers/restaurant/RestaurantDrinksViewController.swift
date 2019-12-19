//
//  RestaurantDrinksViewController.swift
//  ting
//
//  Created by Christian Scott on 12/18/19.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class RestaurantDrinksViewController: UITableViewController, IndicatorInfoProvider {
    
    var branch: Branch? {
        didSet {
            if let branch = self.branch {
                print(branch.name)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isScrollEnabled = false
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "DRINKS")
    }
}
