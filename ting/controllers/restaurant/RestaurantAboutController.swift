//
//  RestaurantAboutController.swift
//  ting
//
//  Created by Christian Scott on 12/25/19.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit

class RestaurantAboutController: UITableViewController {
    
    typealias ConfigParam = [String]
    
    let headerTitles: [String] = ["About", "Contacts", "Data Stats", "Config"]
    
    let cellId = "cellId"
    
    var branch: Branch? {
        didSet {
            if let branch = self.branch, let restaurant = self.branch?.restaurant {
                self.aboutDatas = [
                    ["Name", restaurant.name],
                    ["Branch", branch.name],
                    ["Address", "\(branch.town), \(branch.country)"],
                    ["Open, Close", "\(restaurant.opening) - \(restaurant.closing)"],
                    ["Motto", restaurant.motto]
                ]
                self.contactDatas = [
                    ["Email", branch.email],
                    ["Phone", branch.phone],
                    ["Full Address", branch.address]
                ]
                self.statsDatas = [
                    ["Foods", "\(branch.menus.type.foods.count)"],
                    ["Drinks", "\(branch.menus.type.drinks)"],
                    ["Dishes", "\(branch.menus.type.dishes)"],
                    ["Likes", "\((branch.likes?.count)!)"],
                    ["Reviews", "\((branch.reviews?.count)!)"],
                    ["Stars", "\((branch.reviews?.average)!)"]
                ]
                self.configDatas = [
                    ["Currency", "\(restaurant.config.currency ?? "USD")"],
                    ["VAT", "\(restaurant.config.tax ?? "18.0") %"],
                    ["Late Reservation Time", "\(restaurant.config.cancelLateBooking) minutes"],
                    ["Make Reservation With Advance", restaurant.config.bookWithAdvance ? "YES" : "NO"],
                    ["Reservation Advance", restaurant.config.bookWithAdvance ? "\(restaurant.config.currency ?? "USD") \(restaurant.config.bookingAdvance ?? "0.0")" : "-"],
                    ["Refund After Cancelation", restaurant.config.bookingCancelationRefund ? "YES" : "NO"],
                    ["Booking Payement Mode", restaurant.config.bookingPaymentMode],
                    ["Days Before Booking", "\(restaurant.config.daysBeforeReservation) days"],
                    ["Can Take Away", restaurant.config.canTakeAway ? "YES" : "NO"],
                    ["Pay Before Receiving Order", restaurant.config.userShouldPayBefore ? "YES" : "NO"]
                ]
            }
        }
    }
    
    var aboutDatas: [ConfigParam]? {
        didSet { self.tableView.reloadData() }
    }
    
    var contactDatas: [ConfigParam]? {
        didSet { self.tableView.reloadData() }
    }
    
    var statsDatas: [ConfigParam]? {
        didSet { self.tableView.reloadData() }
    }
    
    var configDatas: [ConfigParam]? {
        didSet { self.tableView.reloadData() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellId)
    }
    
    private func setupNavigationBar(){
        self.navigationController?.navigationBar.barTintColor = Colors.colorPrimaryDark
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = Colors.colorPrimaryDark
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barStyle = .black
        
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "icon_unwind_25_white")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "icon_unwind_25_white")
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.title = "Restaurant About"
        
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
        
        let barButtonAppearance = UIBarButtonItem.appearance()
        barButtonAppearance.setTitleTextAttributes([.foregroundColor : UIColor.white], for: .normal)
        
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
            statusBar.backgroundColor = Colors.colorPrimaryDark
            UIApplication.shared.keyWindow?.addSubview(statusBar)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setupNavigationBar()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.aboutDatas?.count ?? 0
        case 1:
            return self.contactDatas?.count ?? 0
        case 2:
            return self.statsDatas?.count ?? 0
        case 3:
            return self.configDatas?.count ?? 0
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath)
        cell.selectionStyle = .none
        
        let titleView: UILabel = {
            let view = UILabel()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.font = UIFont(name: "Poppins-Regular", size: 14)
            view.textColor = Colors.colorDarkGray
            return view
        }()
        
        let valueView: UILabel = {
            let view = UILabel()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.font = UIFont(name: "Poppins-Regular", size: 14)
            view.textColor = Colors.colorLightGray
            view.textAlignment = .right
            return view
        }()
        
        switch indexPath.section {
        case 0:
            let data = self.aboutDatas![indexPath.row]
            titleView.text = data[0]
            valueView.text = data[1]
            break
        case 1:
            let data = self.contactDatas![indexPath.row]
            titleView.text = data[0]
            valueView.text = data[1]
            break
        case 2:
            let data = self.statsDatas![indexPath.row]
            titleView.text = data[0]
            valueView.text = data[1]
            break
        case 3:
            let data = self.configDatas![indexPath.row]
            titleView.text = data[0]
            valueView.text = data[1]
            break
        default:
            break
        }
        
        cell.addSubview(titleView)
        cell.addSubview(valueView)
        
        cell.addConstraintsWithFormat(format: "V:|-12-[v0(16)]-12-|", views: titleView)
        cell.addConstraintsWithFormat(format: "V:|-12-[v0(16)]-12-|", views: valueView)
        
        cell.addConstraintsWithFormat(format: "H:|-20-[v0]-0-[v1]-12-|", views: titleView, valueView)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 12 + 16 + 12
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view: UIView = {
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
            view.backgroundColor = Colors.colorVeryLightGray
            return view
        }()
        
        let headerTitle: UILabel = {
            let view = UILabel()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.font = UIFont(name: "Poppins-SemiBold", size: 18)
            view.textColor = Colors.colorDarkGray
            return view
        }()
        
        headerTitle.text = self.headerTitles[section].uppercased()
        
        view.addSubview(headerTitle)
        view.addConstraintsWithFormat(format: "H:|-24-[v0]", views: headerTitle)
        view.addConstraintsWithFormat(format: "V:[v0]", views: headerTitle)
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: headerTitle, attribute: .centerY, multiplier: 1, constant: 0))
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
