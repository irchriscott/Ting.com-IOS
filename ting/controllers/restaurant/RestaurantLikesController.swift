//
//  RestaurantLikesController.swift
//  ting
//
//  Created by Christian Scott on 12/25/19.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit

class RestaurantLikesController: UITableViewController {
    
    let cellId = "cellId"
    let emptyCellId = "emptyCellId"
    var headerHeight: CGFloat = 200
    
    var branch: Branch? {
        didSet {}
    }
    
    var likes: [UserRestaurant]? {
        didSet {
            self.headerHeight = 0
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.tableView.separatorStyle = .none
        
        self.tableView.register(RestaurantLikeViewCell.self, forCellReuseIdentifier: self.cellId)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.emptyCellId)
        
        if let branch = self.branch {
            APIDataProvider.instance.getRestaurantLikes(url: "\(URLs.hostEndPoint)\(branch.urls.apiLikes)") { (likes) in
                DispatchQueue.main.async {
                    self.likes = likes
                }
            }
        }
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
        self.navigationItem.title = "Restaurant Likes"
        
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
            return self.likes?.count ?? 0
        } else {
            return self.likes?.count ?? 0 > 0 ? self.likes?.count ?? 0 : 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.likes?.count ?? 0 > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! RestaurantLikeViewCell
            cell.like = self.likes![indexPath.item]
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.emptyCellId, for: indexPath)
            
            let cellView: UIView = {
                let view = UIView()
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            
            let emptyImageView: UIImageView = {
                let view = UIImageView()
                view.translatesAutoresizingMaskIntoConstraints = false
                view.image = UIImage(named: "icon_like_filled_100_gray")!
                view.contentMode = .scaleAspectFill
                view.clipsToBounds = true
                view.alpha = 0.2
                return view
            }()
            
            let emptyTextView: UILabel = {
                let view = UILabel()
                view.translatesAutoresizingMaskIntoConstraints = false
                view.text = "No Like For This Restaurant"
                view.font = UIFont(name: "Poppins-SemiBold", size: 20)
                view.textColor = Colors.colorVeryLightGray
                view.textAlignment = .center
                return view
            }()
            
            let emptyTextRect = NSString(string: "No Like For This Restaurant").boundingRect(with: CGSize(width: cell.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: 20)!], context: nil)
            
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
        if self.likes?.count ?? 0 > 0 {
            return self.restaurantLikeCellHeight(index: indexPath.item)
        } else {
            let emptyTextRect = NSString(string: "No Like For This Restaurant").boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: 20)!], context: nil)
            return 30 + 90 + 12 + emptyTextRect.height + 30
        }
    }
    
    private func restaurantLikeCellHeight(index: Int) -> CGFloat {
        if let likes = self.likes {
            
            let like = likes[index]
            
            var userNameHeight: CGFloat = 20
            var restaurantAddressHeight: CGFloat = 16
                
            let userNameTextSize: CGFloat = 14
            let restaurantAddressTextSize: CGFloat = 13
            let userImageConstant: CGFloat = 70
            
            let frameWidth = view.frame.width - (60 + userImageConstant)
            
            let userNameRect = NSString(string: like.user!.name).boundingRect(with: CGSize(width: frameWidth, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: userNameTextSize)!], context: nil)
                
            let addressRect = NSString(string: "\(like.user!.town), \(like.user!.country)").boundingRect(with: CGSize(width: frameWidth, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: restaurantAddressTextSize)!], context: nil)
                
            restaurantAddressHeight = addressRect.height
            userNameHeight = userNameRect.height
            
            return 4 + 26 + 12 + restaurantAddressHeight + userNameHeight + 12 + 12
        }
        return 0
    }
}
