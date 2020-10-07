//
//  CuisineMenusViewController.swift
//  ting
//
//  Created by Christian Scott on 16/08/2020.
//  Copyright © 2020 Ir Christian Scott. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import ShimmerSwift

class CuisineMenusViewController: UITableViewController, IndicatorInfoProvider {
    
    let cellId = "cellId"
    let shimmerCellId = "shimmerCellId"
    let emptyCellId = "emptyCellId"
    
    var spinnerViewHeight: CGFloat = 0
    var menus: [RestaurantMenu] = []
    
    var refresherLoadingView = UIRefreshControl()
    
    let session = UserAuthentication().get()!
    
    var cuisine: RestaurantCategory? {
        didSet {}
    }
    
    var pageIndex = 1
    var shouldLoad = true
    var hasLoaded = false
    
    private func getMenus(index: Int){
        APIDataProvider.instance.getCuisineMenus(cuisine: self.cuisine!.id, page: index) { (ms) in
            DispatchQueue.main.async {
                self.hasLoaded = true
                if !ms.isEmpty {

                    self.menus.append(contentsOf: ms)
                    self.spinnerViewHeight = 0
                    self.tableView.reloadData()
                    self.refresherLoadingView.endRefreshing()
                   
                } else {
                    self.spinnerViewHeight = 0
                    self.shouldLoad = false
                }
                
                if self.menus.isEmpty {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    var loadedMenus:[Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresherLoadingView.addTarget(self, action: #selector(refreshMenus), for: UIControl.Event.valueChanged)
        tableView.addSubview(refresherLoadingView)
        
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.shimmerCellId)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.emptyCellId)
        tableView.register(RestaurantMenuViewCell.self, forCellReuseIdentifier: self.cellId)
        
        getMenus(index: pageIndex)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.hasLoaded {
            return !self.menus.isEmpty ? self.menus.count : 1
        } else { return 3 }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let emptyTextRect = NSString(string: "No Menu To Show").boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: 23)!], context: nil)
        if self.hasLoaded {
            return !self.menus.isEmpty ? self.restaurantMenuCellHeight(index: indexPath.row) : 30 + 90 + 12 + emptyTextRect.height + 30
        } else { return 94 + 12 }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.hasLoaded {
            if !self.menus.isEmpty {
                let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! RestaurantMenuViewCell
                cell.selectionStyle = .none
                if !self.loadedMenus.contains(indexPath.row) {
                    cell.restaurantMenu = self.menus[indexPath.row]
                    self.loadedMenus.append(indexPath.row)
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: self.emptyCellId, for: indexPath)
                cell.selectionStyle = .none
                
                let cellView: UIView = {
                    let view = UIView()
                    view.translatesAutoresizingMaskIntoConstraints = false
                    return view
                }()
                
                let emptyImageView: UIImageView = {
                    let view = UIImageView()
                    view.translatesAutoresizingMaskIntoConstraints = false
                    view.image = UIImage(named: "icon_spoon_100_gray")!
                    view.contentMode = .scaleAspectFill
                    view.clipsToBounds = true
                    view.alpha = 0.2
                    return view
                }()
                
                let emptyTextView: UILabel = {
                    let view = UILabel()
                    view.translatesAutoresizingMaskIntoConstraints = false
                    view.text = "No Menu To Show"
                    view.font = UIFont(name: "Poppins-SemiBold", size: 23)
                    view.textColor = Colors.colorVeryLightGray
                    view.textAlignment = .center
                    return view
                }()
                
                let emptyTextRect = NSString(string: "No Menu To Show").boundingRect(with: CGSize(width: cell.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: 23)!], context: nil)
                
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
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.shimmerCellId, for: indexPath)
            cell.selectionStyle = .none
            
            let view: RowShimmerView = {
                let view = RowShimmerView()
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            
            cell.addSubview(view)
            cell.addConstraintsWithFormat(format: "V:|[v0]-12-|", views: view)
            cell.addConstraintsWithFormat(format: "H:|[v0]|", views: view)
            
            let shimmerView = ShimmeringView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 94))
            cell.addSubview(shimmerView)
            
            shimmerView.contentView = view
            shimmerView.shimmerAnimationOpacity = 0.4
            shimmerView.shimmerSpeed = 250
            shimmerView.isShimmering = true
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.menus.count - 1 {
            if self.shouldLoad {
                pageIndex += 1
                self.spinnerViewHeight = 40
                getMenus(index: pageIndex)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !self.menus.isEmpty {
            let menu = self.menus[indexPath.row]
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let menuController = storyboard.instantiateViewController(withIdentifier: "RestaurantMenuView") as! RestaurantMenuViewController
            menuController.restaurantMenu = menu
            menuController.controller = self
            self.navigationController?.pushViewController(menuController, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer: UIView = {
            let view = UIView()
            view.backgroundColor = Colors.colorWhite
            view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: self.spinnerViewHeight)
            return view
        }()
        
        let indicatorView: UIActivityIndicatorView = {
            let view = UIActivityIndicatorView(style: .gray)
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        indicatorView.startAnimating()
        footer.addSubview(indicatorView)
        footer.addConstraintsWithFormat(format: "V:|[v0]|", views: indicatorView)
        footer.addConstraintsWithFormat(format: "H:|[v0]|", views: indicatorView)
        footer.addConstraint(NSLayoutConstraint(item: indicatorView, attribute: .centerY, relatedBy: .equal, toItem: footer, attribute: .centerY, multiplier: 1, constant: 0))
        
        return footer
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.spinnerViewHeight
    }
    
    private func restaurantMenuCellHeight(index: Int) -> CGFloat {
        
        let device = UIDevice.type
        
        var menuNameTextSize: CGFloat = 15
        var menuDescriptionTextSize: CGFloat = 13
        var menuImageConstant: CGFloat = 80
        
        let menu = self.menus[index]
        
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
    
    @objc private func refreshMenus() {
        pageIndex = 1
        self.menus = []
        self.spinnerViewHeight = 0
        self.getMenus(index: pageIndex)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "MENUS")
    }
}
