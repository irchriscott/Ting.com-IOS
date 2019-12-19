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
    
    let cellId = "cellId"
    var headerHeight: CGFloat = 100
    
    var branch: Branch? {
        didSet {}
    }
    
    var promotions: [MenuPromotion]? {
        didSet {}
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        
        tableView.register(RestaurantPromotionViewCell.self, forCellReuseIdentifier: self.cellId)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView: UIView = {
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: headerHeight)
            view.backgroundColor = .white
            return view
        }()
        
        let indicatorView: UIActivityIndicatorView = {
            let view = UIActivityIndicatorView(style: .gray)
            return view
        }()
        
        indicatorView.startAnimating()
        indicatorView.center = headerView.center
        headerView.addSubview(indicatorView)
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(headerHeight)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.promotions?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! RestaurantPromotionViewCell
        cell.promotion = self.promotions![indexPath.item]
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "PROMOS")
    }
}
