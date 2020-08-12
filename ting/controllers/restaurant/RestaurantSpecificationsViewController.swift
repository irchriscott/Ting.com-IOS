//
//  RestaurantSpecificationsViewController.swift
//  ting
//
//  Created by Christian Scott on 09/08/2020.
//  Copyright © 2020 Ir Christian Scott. All rights reserved.
//

import UIKit

class RestaurantSpecificationsViewController: UITableViewController {
    
    private let cellId = "cellId"
    private let cellIdSpecials = "cellIdSpecials"
    private let cellIdServices = "cellIdServices"
    private let cellIdCuisines = "cellIdCuisines"
    private let cellIdCategories = "cellIdCategories"
    
    var branch: Branch? {
        didSet {
            if let branch = self.branch {
                self.specials = branch.specials
                self.dataLoadedSpecials = [Bool](repeating: false, count: self.specials?.count ?? 0)
                
                self.services = branch.services
                self.dataLoadedServices = [Bool](repeating: false, count: self.services?.count ?? 0)
                
                self.cuisines = branch.categories.categories
                self.dataLoadedCuisines = [Bool](repeating: false, count: self.cuisines?.count ?? 0)
                
                if let categories = branch.restaurant?.foodCategories?.categories {
                    self.categories = categories
                    self.dataLoadedCategories = [Bool](repeating: false, count: self.categories?.count ?? 0)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellId)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellIdSpecials)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellIdServices)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellIdCuisines)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellIdCategories)
    }
    
    private var specials: [BranchSpecials]?
    private var services: [BranchSpecials]?
    private var cuisines: [RestaurantCategory]?
    private var categories: [FoodCategory]?
    
    private var dataLoadedSpecials: [Bool]?
    private var dataLoadedServices: [Bool]?
    private var dataLoadedCuisines: [Bool]?
    private var dataLoadedCategories: [Bool]?
    
    private let headerTitles: [String] = ["Specials", "Services", "Cuisines", "Categories"]

    private func setupNavigationBar(){
        self.navigationController?.navigationBar.barTintColor = Colors.colorPrimaryDark
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = Colors.colorPrimaryDark
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barStyle = .black
        
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "icon_unwind_25_white")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "icon_unwind_25_white")
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.title = "Restaurant Specification"
        
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
            return self.specials?.count ?? 0
        case 1:
            return self.services?.count ?? 0
        case 2:
            return self.cuisines?.count ?? 0
        case 3:
            return self.categories?.count ?? 0
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell!
        
        let titleView: UILabel = {
            let view = UILabel()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.font = UIFont(name: "Poppins-Regular", size: 14)
            view.textColor = Colors.colorDarkGray
            return view
        }()
        
        let imageView: UIImageView = {
            let view = UIImageView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.clipsToBounds = true
            view.contentMode = .scaleAspectFill
            return view
        }()
        
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdSpecials, for: indexPath)
            let data = self.specials![indexPath.row]
            if !self.dataLoadedSpecials![indexPath.row] {
                imageView.image = UIImage(named: "icon_star_filled_25_gray")
                titleView.text = data.name
            }
            self.dataLoadedSpecials![indexPath.row] = true
            break
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdServices, for: indexPath)
            let data = self.services![indexPath.row]
            if !self.dataLoadedServices![indexPath.row] {
                imageView.image = UIImage(named: "icon_star_filled_25_gray")
                titleView.text = data.name
            }
            self.dataLoadedServices![indexPath.row] = true
            break
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdCuisines, for: indexPath)
            let data = self.cuisines![indexPath.row]
            if !self.dataLoadedCuisines![indexPath.row] {
                titleView.text = data.name
                imageView.load(url: URL(string: "\(URLs.hostEndPoint)\(data.image)")!)
            }
            self.dataLoadedCuisines![indexPath.row] = true
            break
        case 3:
            cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdCategories, for: indexPath)
            let data = self.categories![indexPath.row]
            if !self.dataLoadedCategories![indexPath.row] {
                titleView.text = data.name
                imageView.load(url: URL(string: "\(URLs.hostEndPoint)\((data.image)!)")!)
            }
            self.dataLoadedCategories![indexPath.row] = true
            break
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath)
            break
        }
        
        cell.selectionStyle = .none
        
        cell.addSubview(titleView)
        cell.addSubview(imageView)
        
        cell.addConstraintsWithFormat(format: "V:|-17-[v0]-17-|", views: titleView)
        cell.addConstraintsWithFormat(format: "V:|-10-[v0(30)]-10-|", views: imageView)
        
        cell.addConstraintsWithFormat(format: "H:|-20-[v0(30)]-12-[v1]", views: imageView, titleView)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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
