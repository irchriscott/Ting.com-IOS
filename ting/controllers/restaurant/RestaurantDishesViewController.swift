//
//  RestaurantDishesViewController.swift
//  ting
//
//  Created by Christian Scott on 12/18/19.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class RestaurantDishesViewController: UITableViewController, IndicatorInfoProvider {
    
    let cellId = "cellId"
    let defaultCellId = "defaultCellId"
    var headerHeight: CGFloat = 200
    
    var branch: Branch? {
        didSet { if let _ = self.branch {} }
    }
    
    var menus: [RestaurantMenu]? {
        didSet {
            self.headerHeight = 0
            self.tableView.reloadData()
        }
    }
    
    var controller: UIViewController? {
        didSet {}
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        
        tableView.register(RestaurantMenuViewCell.self, forCellReuseIdentifier: self.cellId)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.defaultCellId)
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
        if headerHeight > 0 {
            return self.menus?.count ?? 0
        } else {
            return self.menus?.count ?? 0 > 0 ? self.menus?.count ?? 0 : 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.menus?.count ?? 0 > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! RestaurantMenuViewCell
            cell.restaurantMenu = self.menus![indexPath.item]
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.defaultCellId, for: indexPath)
            
            let cellView: UIView = {
                let view = UIView()
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            
            let emptyImageView: UIImageView = {
                let view = UIImageView()
                view.translatesAutoresizingMaskIntoConstraints = false
                view.image = UIImage(named: "ic_restaurants")!
                view.contentMode = .scaleAspectFill
                view.clipsToBounds = true
                view.alpha = 0.2
                return view
            }()
            
            let emptyTextView: UILabel = {
                let view = UILabel()
                view.translatesAutoresizingMaskIntoConstraints = false
                view.text = "No Menu Dish To Show"
                view.font = UIFont(name: "Poppins-SemiBold", size: 23)
                view.textColor = Colors.colorVeryLightGray
                view.textAlignment = .center
                return view
            }()
            
            let emptyTextRect = NSString(string: "No Menu Dish To Show").boundingRect(with: CGSize(width: cell.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: 23)!], context: nil)
            
            cellView.addSubview(emptyImageView)
            cellView.addSubview(emptyTextView)
            
            cellView.addConstraintsWithFormat(format: "H:[v0(90)]", views: emptyImageView)
            cellView.addConstraintsWithFormat(format: "H:|[v0]|", views: emptyTextView)
            cellView.addConstraintsWithFormat(format: "V:|[v0(90)]-6-[v1(\(emptyTextRect.height))]|", views: emptyImageView, emptyTextView)
            
            cellView.addConstraint(NSLayoutConstraint(item: cellView, attribute: .centerX, relatedBy: .equal, toItem: emptyImageView, attribute: .centerX, multiplier: 1, constant: 0))
            cellView.addConstraint(NSLayoutConstraint(item: cellView, attribute: .centerX, relatedBy: .equal, toItem: emptyTextView, attribute: .centerX, multiplier: 1, constant: 0))
            
            cell.selectionStyle = .none
            
            cell.addSubview(cellView)
            cell.addConstraintsWithFormat(format: "H:[v0]", views: cellView)
            cell.addConstraintsWithFormat(format: "V:|-30-[v0(\(90 + 12 + emptyTextRect.height))]-30-|", views: cellView)
            
            cell.addConstraint(NSLayoutConstraint(item: cell, attribute: .centerX, relatedBy: .equal, toItem: cellView, attribute: .centerX, multiplier: 1, constant: 0))
            cell.addConstraint(NSLayoutConstraint(item: cell, attribute: .centerY, relatedBy: .equal, toItem: cellView, attribute: .centerY, multiplier: 1, constant: 0))
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.menus?.count ?? 0 > 0 {
            return self.restaurantmenuCellHeight(index: indexPath.item)
        } else {
            let emptyTextRect = NSString(string: "No Menu Dish To Show").boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: 23)!], context: nil)
            return 30 + 90 + 12 + emptyTextRect.height + 30
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menu = self.menus![indexPath.item]
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let menuController = storyboard.instantiateViewController(withIdentifier: "RestaurantMenuView") as! RestaurantMenuViewController
        menuController.restaurantMenu = menu
        menuController.controller = self.controller
        self.controller?.navigationController?.pushViewController(menuController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "DISHES")
    }
    
    private func restaurantmenuCellHeight(index: Int) -> CGFloat {
        
        let device = UIDevice.type
        
        var menuNameTextSize: CGFloat = 15
        var menuDescriptionTextSize: CGFloat = 13
        var menuImageConstant: CGFloat = 80
        
        let menu = self.menus![index]
        
        let heightConstant: CGFloat = 12 + 25 + 1 + 4 + 4 + 4 + 1 + 8 + 8 + 8 + 8 + 26 + 26 + 12
        
        if UIDevice.smallDevices.contains(device) {
            menuImageConstant = 55
            menuNameTextSize = 14
            menuDescriptionTextSize = 12
        } else if UIDevice.mediumDevices.contains(device) {
            menuImageConstant = 70
            menuNameTextSize = 15
            menuDescriptionTextSize = 12
        }
        
        let frameWidth = view.frame.width - (60 + menuImageConstant)
        
        let menuNameRect = NSString(string: (menu.menu?.name!)!).boundingRect(with: CGSize(width: frameWidth, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: menuNameTextSize)!], context: nil)
        
        let menuDescriptionRect = NSString(string: (menu.menu?.description!)!).boundingRect(with: CGSize(width: frameWidth - 18, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: menuDescriptionTextSize)!], context: nil)
        
        var menuPriceHeight: CGFloat = 16
        
        let priceRect = NSString(string: "UGX 10,000").boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: 27)!], context: nil)
        
        let quantityRect = NSString(string: "2 packs / counts").boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 12)!], context: nil)
        
        let lastPriceRect = NSString(string: "UGX 6,000").boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 12)!], context: nil)
        
        if (menu.menu?.isCountable)! && Double((menu.menu?.price)!) != Double((menu.menu?.lastPrice)!) {
            menuPriceHeight += priceRect.height + quantityRect.height + lastPriceRect.height
        } else if !(menu.menu?.isCountable)! && Double((menu.menu?.price)!) != Double((menu.menu?.lastPrice)!) {
            menuPriceHeight += priceRect.height + lastPriceRect.height + 4
        } else if (menu.menu?.isCountable)! && !(Double((menu.menu?.price)!) != Double((menu.menu?.lastPrice)!)) {
            menuPriceHeight += priceRect.height + quantityRect.height + 4
        } else { menuPriceHeight += priceRect.height + 4 }
        
        return heightConstant + menuNameRect.height + menuDescriptionRect.height + CGFloat(menuPriceHeight)
    }
}
