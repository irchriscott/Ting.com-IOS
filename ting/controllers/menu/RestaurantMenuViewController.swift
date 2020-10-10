//
//  RestaurantMenuViewController.swift
//  ting
//
//  Created by Christian Scott on 05/11/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit
import ImageViewer
import FittedSheets
import ShimmerSwift

class RestaurantMenuViewController: UITableViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, GalleryDisplacedViewsDataSource, GalleryItemsDataSource, GalleryItemsDelegate {
    
    struct DataImageItem {
        let imageView: UIImageView
        let galleryItem: GalleryItem
    }
    
    var imageItems: [DataImageItem] = []
    
    private var imageIndex: Int = 0
    private let headerIdImage = "headerIdImage"
    private let cellIdMenuDetails = "cellIdMenuDetails"
    private let cellTableViewIdDetails = "cellTableViewIdDetails"
    private let cellIdDefault = "cellId"
    private let headerIdDefault = "headerId"
    private let cellIdTableDishFoodView = "tableIdDishFoodView"
    private let cellIdTableDishFood = "tableIdDishFood"
    private let cellIdTableHeaderDishFood = "tableIdDishFoodHeader"
    private let cellTableViewIdDefault = "tableViewIdDefault"
    private let cellTableViewIdPromotion = "cellTableViewIdPromotion"
    private let cellTableViewIdPromotions = "cellTableViewIdPromotions"
    private let cellTableViewIdReview = "cellTableViewIdReview"
    private let cellTableViewIdReviews = "cellTableViewIdReviews"
    
    var menuURL: String? {
        didSet {
            if let url = self.menuURL {
                APIDataProvider.instance.getRestaurantMenu(url: url) { (restoMenu) in
                    DispatchQueue.main.async {
                        self.shouldLoad = true
                        self.restaurantMenu = restoMenu
                        self.tableView.reloadData()
                        self.restaurantDetailsView.reloadData()
                        self.restaurantMenuReviewsView.reloadData()
                        self.restaurantMenuPromotionsView.reloadData()
                        self.restaurantMenuDishFoodsView.reloadData()
                    }
                }
            }
        }
    }
    
    var restaurantMenu: RestaurantMenu? {
        didSet {
            if let menu = self.restaurantMenu {
                let images = menu.menu?.images?.images
                self.imageIndex = Int.random(in: 0...images!.count - 1)
                self.promotions = menu.menu?.promotions?.promotions?.filter({ (promo) -> Bool in
                    promo.isOn && promo.isOnToday
                })
            }
        }
    }
    
    var shouldLoad = false
    
    var controller: UIViewController? {
        didSet {}
    }
    
    lazy var restaurantDetailsView: UICollectionView = {
        let layout =  UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = Colors.colorWhite
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        view.tag = 1
        view.isScrollEnabled = false
        return view
    }()
    
    lazy var restaurantMenuDishFoodsView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.isScrollEnabled = false
        return view
    }()
    
    lazy var restaurantMenuPromotionsView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.isScrollEnabled = false
        return view
    }()
    
    lazy var restaurantMenuReviewsView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.isScrollEnabled = false
        return view
    }()
    
    var promotions: [MenuPromotion]? {
        didSet {}
    }
    
    let session = UserAuthentication().get()!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setupNavigationBar()
        self.loadRestaurantMenu()
        
        self.tableView.separatorStyle = .none
        
        if let menu = self.restaurantMenu {
            let images = menu.menu?.images?.images
            self.imageIndex = Int.random(in: 0...images!.count - 1)
            
            for image in images! {
                let imageView = UIImageView()
                imageView.load(url: URL(string: "\(URLs.hostEndPoint)\(image.image)")!)
                
                let galleryItem = GalleryItem.image { $0(imageView.image ?? UIImage(named: "default_meal")!) }
                imageItems.append(DataImageItem(imageView: imageView, galleryItem: galleryItem))
            }
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_star_outline_25_white"), style: .plain, target: self, action: #selector(editMenuReview(_:)))
        
        self.restaurantDetailsView.register(RestaurantMenuHeaderImageViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: self.headerIdImage)
        self.restaurantDetailsView.register(MenuDetailsViewCell.self, forCellWithReuseIdentifier: self.cellIdMenuDetails)
        self.restaurantDetailsView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.cellIdDefault)
        
        self.restaurantMenuDishFoodsView.register(MenuDishFoodViewCell.self, forCellReuseIdentifier: cellIdTableDishFood)
        self.restaurantMenuDishFoodsView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellTableViewIdDefault)
        
        self.restaurantMenuPromotionsView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellTableViewIdDefault)
        self.restaurantMenuPromotionsView.register(MenuPromotionViewCell.self, forCellReuseIdentifier: self.cellTableViewIdPromotion)
        
        self.restaurantMenuReviewsView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellTableViewIdDefault)
        self.restaurantMenuReviewsView.register(MenuReviewViewCell.self, forCellReuseIdentifier: self.cellTableViewIdReview)
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellTableViewIdDetails)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellTableViewIdDefault)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellIdTableDishFoodView)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellTableViewIdPromotions)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellTableViewIdReviews)
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
        self.navigationItem.title = "Restaurant Menu"
        self.navigationItem.largeTitleDisplayMode = .never
        
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
    
    private func loadRestaurantMenu(){
        if let menu = self.restaurantMenu {
            APIDataProvider.instance.getRestaurantMenu(url: "\(URLs.hostEndPoint)\((menu.urls?.apiGet)!)") { (restoMenu) in
                DispatchQueue.main.async {
                    self.shouldLoad = true
                    self.restaurantMenu = restoMenu
                    self.tableView.reloadData()
                    self.restaurantDetailsView.reloadData()
                    self.restaurantMenuReviewsView.reloadData()
                    self.restaurantMenuPromotionsView.reloadData()
                    self.restaurantMenuDishFoodsView.reloadData()
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupNavigationBar()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case self.restaurantDetailsView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdMenuDetails, for: indexPath) as! MenuDetailsViewCell
            cell.menu = self.restaurantMenu
            cell.parentController = self
            cell.controller = self.controller
            return cell
        default:
            return collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdDefault, for: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch collectionView {
        case self.restaurantDetailsView:
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headerIdImage, for: indexPath) as! RestaurantMenuHeaderImageViewCell
            if let menu = self.restaurantMenu {
                let images = menu.menu?.images?.images
                let image = images![self.imageIndex]
                cell.imageURL = "\(URLs.hostEndPoint)\(image.image)"
            }
            
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RestaurantMenuViewController.openMenuImages(_:))))
            
            return cell
        default:
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headerIdDefault, for: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch collectionView {
        case self.restaurantDetailsView:
            return CGSize(width: self.view.frame.width, height: 320)
        default:
            return CGSize(width: self.view.frame.width, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case self.restaurantDetailsView:
            return CGSize(width: self.view.frame.width, height: self.restaurantDetailsViewHeight - 300)
        default:
            return CGSize(width: self.view.frame.width, height: 0)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.restaurantMenu != nil && shouldLoad {
            switch tableView {
            case self.tableView:
                if promotions?.count ?? 0 > 0 {
                    return self.restaurantMenu?.type!.id == 3 ? 4 : 3
                } else { return self.restaurantMenu?.type!.id == 3 ? 3 : 2 }
            case restaurantMenuDishFoodsView:
                return self.restaurantMenu?.type!.id == 3 ? (self.restaurantMenu?.menu?.foods!.count)! : 0
            case restaurantMenuPromotionsView:
                return self.promotions?.count ?? 0
            case restaurantMenuReviewsView:
                if self.restaurantMenu?.menu?.reviews?.count ?? 0 > 0 {
                    return self.restaurantMenu?.menu?.reviews?.count ?? 0 > 5 ? 5 : self.restaurantMenu?.menu?.reviews?.count ?? 0
                } else { return 1 }
            default:
                return 0
            }
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.restaurantMenu != nil && shouldLoad {
            switch tableView {
            case self.tableView:
                if promotions?.count ?? 0 > 0 {
                    if self.restaurantMenu?.type!.id == 3 {
                        switch indexPath.item {
                        case 0:
                            let menuDetailsCell = tableView.dequeueReusableCell(withIdentifier: self.cellTableViewIdDetails, for: indexPath)
                            menuDetailsCell.addSubview(restaurantDetailsView)
                            menuDetailsCell.addConstraintsWithFormat(format: "H:|[v0]|", views: restaurantDetailsView)
                            menuDetailsCell.addConstraintsWithFormat(format: "V:|[v0]|", views: restaurantDetailsView)
                            menuDetailsCell.selectionStyle = .none
                            return menuDetailsCell
                        case 1:
                            let menuFoodsCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdTableDishFoodView, for: indexPath)
                            menuFoodsCell.addSubview(restaurantMenuDishFoodsView)
                            menuFoodsCell.addConstraintsWithFormat(format: "H:|[v0]|", views: restaurantMenuDishFoodsView)
                            menuFoodsCell.addConstraintsWithFormat(format: "V:|[v0]|", views: restaurantMenuDishFoodsView)
                            menuFoodsCell.selectionStyle = .none
                            return menuFoodsCell
                        case 2:
                            let promotionsCell = tableView.dequeueReusableCell(withIdentifier: self.cellTableViewIdPromotions, for: indexPath)
                            promotionsCell.addSubview(restaurantMenuPromotionsView)
                            promotionsCell.addConstraintsWithFormat(format: "H:|[v0]|", views: restaurantMenuPromotionsView)
                            promotionsCell.addConstraintsWithFormat(format: "V:|[v0]|", views: restaurantMenuPromotionsView)
                            return promotionsCell
                        case 3:
                            let reviewsCell = tableView.dequeueReusableCell(withIdentifier: self.cellTableViewIdReviews, for: indexPath)
                            reviewsCell.addSubview(restaurantMenuReviewsView)
                            reviewsCell.addConstraintsWithFormat(format: "H:|[v0]|", views: restaurantMenuReviewsView)
                            reviewsCell.addConstraintsWithFormat(format: "V:|[v0]|", views: restaurantMenuReviewsView)
                            return reviewsCell
                        default:
                            return tableView.dequeueReusableCell(withIdentifier: self.cellTableViewIdDefault, for: indexPath)
                        }
                    } else {
                        switch indexPath.item {
                        case 0:
                            let menuDetailsCell = tableView.dequeueReusableCell(withIdentifier: self.cellTableViewIdDetails, for: indexPath)
                            menuDetailsCell.addSubview(restaurantDetailsView)
                            menuDetailsCell.addConstraintsWithFormat(format: "H:|[v0]|", views: restaurantDetailsView)
                            menuDetailsCell.addConstraintsWithFormat(format: "V:|[v0]|", views: restaurantDetailsView)
                            menuDetailsCell.selectionStyle = .none
                            return menuDetailsCell
                        case 1:
                            let promotionsCell = tableView.dequeueReusableCell(withIdentifier: self.cellTableViewIdPromotions, for: indexPath)
                            promotionsCell.addSubview(restaurantMenuPromotionsView)
                            promotionsCell.addConstraintsWithFormat(format: "H:|[v0]|", views: restaurantMenuPromotionsView)
                            promotionsCell.addConstraintsWithFormat(format: "V:|[v0]|", views: restaurantMenuPromotionsView)
                            return promotionsCell
                        case 2:
                            let reviewsCell = tableView.dequeueReusableCell(withIdentifier: self.cellTableViewIdReviews, for: indexPath)
                            reviewsCell.addSubview(restaurantMenuReviewsView)
                            reviewsCell.addConstraintsWithFormat(format: "H:|[v0]|", views: restaurantMenuReviewsView)
                            reviewsCell.addConstraintsWithFormat(format: "V:|[v0]|", views: restaurantMenuReviewsView)
                            return reviewsCell
                        default:
                            return tableView.dequeueReusableCell(withIdentifier: self.cellTableViewIdDefault, for: indexPath)
                        }
                    }
                } else {
                    if self.restaurantMenu?.type!.id == 3 {
                        switch indexPath.item {
                        case 0:
                            let menuDetailsCell = tableView.dequeueReusableCell(withIdentifier: self.cellTableViewIdDetails, for: indexPath)
                            menuDetailsCell.addSubview(restaurantDetailsView)
                            menuDetailsCell.addConstraintsWithFormat(format: "H:|[v0]|", views: restaurantDetailsView)
                            menuDetailsCell.addConstraintsWithFormat(format: "V:|[v0]|", views: restaurantDetailsView)
                            menuDetailsCell.selectionStyle = .none
                            return menuDetailsCell
                        case 1:
                            let menuFoodsCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdTableDishFoodView, for: indexPath)
                            menuFoodsCell.addSubview(restaurantMenuDishFoodsView)
                            menuFoodsCell.addConstraintsWithFormat(format: "H:|[v0]|", views: restaurantMenuDishFoodsView)
                            menuFoodsCell.addConstraintsWithFormat(format: "V:|[v0]|", views: restaurantMenuDishFoodsView)
                            menuFoodsCell.selectionStyle = .none
                            return menuFoodsCell
                        case 2:
                            let reviewsCell = tableView.dequeueReusableCell(withIdentifier: self.cellTableViewIdReviews, for: indexPath)
                            reviewsCell.addSubview(restaurantMenuReviewsView)
                            reviewsCell.addConstraintsWithFormat(format: "H:|[v0]|", views: restaurantMenuReviewsView)
                            reviewsCell.addConstraintsWithFormat(format: "V:|[v0]|", views: restaurantMenuReviewsView)
                            return reviewsCell
                        default:
                            return tableView.dequeueReusableCell(withIdentifier: self.cellTableViewIdDefault, for: indexPath)
                        }
                    } else {
                        switch indexPath.item {
                        case 0:
                            let menuDetailsCell = tableView.dequeueReusableCell(withIdentifier: self.cellTableViewIdDetails, for: indexPath)
                            menuDetailsCell.addSubview(restaurantDetailsView)
                            menuDetailsCell.addConstraintsWithFormat(format: "H:|[v0]|", views: restaurantDetailsView)
                            menuDetailsCell.addConstraintsWithFormat(format: "V:|[v0]|", views: restaurantDetailsView)
                            menuDetailsCell.selectionStyle = .none
                            return menuDetailsCell
                        case 1:
                            let reviewsCell = tableView.dequeueReusableCell(withIdentifier: self.cellTableViewIdReviews, for: indexPath)
                            reviewsCell.addSubview(restaurantMenuReviewsView)
                            reviewsCell.addConstraintsWithFormat(format: "H:|[v0]|", views: restaurantMenuReviewsView)
                            reviewsCell.addConstraintsWithFormat(format: "V:|[v0]|", views: restaurantMenuReviewsView)
                            return reviewsCell
                        default:
                            return tableView.dequeueReusableCell(withIdentifier: self.cellTableViewIdDefault, for: indexPath)
                        }
                    }
                }
            case restaurantMenuDishFoodsView:
                let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdTableDishFood, for: indexPath) as! MenuDishFoodViewCell
                cell.menuFood = self.restaurantMenu?.menu?.foods?.foods![indexPath.item]
                cell.selectionStyle = .none
                return cell
            case restaurantMenuPromotionsView:
                let cell = tableView.dequeueReusableCell(withIdentifier: self.cellTableViewIdPromotion, for: indexPath) as! MenuPromotionViewCell
                cell.promotion = self.promotions![indexPath.item]
                cell.selectionStyle = .none
                return cell
            case restaurantMenuReviewsView:
                if self.restaurantMenu?.menu?.reviews?.reviews?.count ?? 0 > 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: self.cellTableViewIdReview, for: indexPath) as! MenuReviewViewCell
                    cell.selectionStyle = .none
                    cell.review = self.restaurantMenu?.menu?.reviews?.reviews![indexPath.item]
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: self.cellTableViewIdDefault, for: indexPath)
                    
                    let cellView: UIView = {
                        let view = UIView()
                        view.translatesAutoresizingMaskIntoConstraints = false
                        return view
                    }()
                    
                    let emptyImageView: UIImageView = {
                        let view = UIImageView()
                        view.translatesAutoresizingMaskIntoConstraints = false
                        view.image = UIImage(named: "icon_bubble_chat_96_gray")!
                        view.contentMode = .scaleAspectFill
                        view.alpha = 0.2
                        return view
                    }()
                    
                    let emptyTextView: UILabel = {
                        let view = UILabel()
                        view.translatesAutoresizingMaskIntoConstraints = false
                        view.text = "No Reviews For This Menu"
                        view.font = UIFont(name: "Poppins-SemiBold", size: 23)
                        view.textColor = Colors.colorVeryLightGray
                        view.textAlignment = .center
                        return view
                    }()
                    
                    let emptyTextRect = NSString(string: "No Reviews For This Menu").boundingRect(with: CGSize(width: cell.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: 23)!], context: nil)
                    
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
            default:
                return tableView.dequeueReusableCell(withIdentifier: self.cellTableViewIdDefault, for: indexPath)
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellTableViewIdDefault, for: indexPath)
            
            let view: DetailsShimmerView = {
                let view = DetailsShimmerView()
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            
            cell.addSubview(view)
            cell.addConstraintsWithFormat(format: "V:|[v0]|", views: view)
            cell.addConstraintsWithFormat(format: "H:|[v0]|", views: view)
                       
            let shimmerView = ShimmeringView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 447))
            cell.addSubview(shimmerView)
                       
            shimmerView.contentView = view
            shimmerView.shimmerAnimationOpacity = 0.4
            shimmerView.shimmerSpeed = 250
            shimmerView.isShimmering = true
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch tableView {
        case self.tableView:
            return nil
        case restaurantMenuReviewsView:
            return self.reviewHeaderView(width: view.frame.width)
        default:
            let headerView: UIView = {
                let view = UIView()
                view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
                view.backgroundColor = .white
                return view
            }()
            
            let titleLabel: UILabel = {
                let view = UILabel()
                view.translatesAutoresizingMaskIntoConstraints = false
                view.textColor = Colors.colorGray
                view.text = "Header Title"
                view.font = UIFont(name: "Poppins-Regular", size: 16)
                return view
            }()
            
            switch tableView {
            case restaurantMenuDishFoodsView:
                titleLabel.text = "Dish Foods".uppercased()
                break
            case restaurantMenuPromotionsView:
                titleLabel.text = "Today's Promotions".uppercased()
            default:
                titleLabel.text = "Some Title".uppercased()
                break
            }
            
            headerView.addSubview(titleLabel)
            headerView.addConstraintsWithFormat(format: "H:|-12-[v0]", views: titleLabel)
            headerView.addConstraintsWithFormat(format: "V:[v0]", views: titleLabel)
            headerView.addConstraint(NSLayoutConstraint(item: headerView, attribute: .centerY, relatedBy: .equal, toItem: titleLabel, attribute: .centerY, multiplier: 1, constant: 0))
            
            return headerView
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.restaurantMenu != nil && shouldLoad {
            switch tableView {
            case self.tableView:
                if promotions?.count ?? 0 > 0 {
                    if self.restaurantMenu?.type!.id == 3 {
                        switch indexPath.item {
                        case 0:
                            return self.restaurantDetailsViewHeight
                        case 1:
                            var height: CGFloat = 0
                            if self.restaurantMenu?.menu?.foods?.count ?? 0 > 0 {
                                height += 50
                                if let foods = self.restaurantMenu?.menu?.foods?.foods {
                                    for (index, _) in foods.enumerated() {
                                        height += self.dishFoodViewCellHeight(index: index)
                                    }
                                    height -= 10
                                }
                            }
                            return height
                        case 2:
                            var height: CGFloat = 0
                            if promotions?.count ?? 0 > 0 {
                                height += 50
                                if let promotions = self.promotions {
                                    for (index, _) in promotions.enumerated() {
                                        height += self.menuPromotionViewCellHeight(index: index)
                                    }
                                    height -= 10
                                }
                            }
                            return height
                        case 3:
                            var height: CGFloat = 128
                            if self.restaurantMenu?.menu?.reviews?.count ?? 0 > 0 {
                                if self.restaurantMenu?.menu?.reviews?.count ?? 0 > 5 {
                                    let reviews = self.restaurantMenu?.menu?.reviews?.reviews?.prefix(5)
                                    if let reviews = reviews {
                                        for (index, _) in reviews.enumerated() {
                                            height += self.menuReviewViewCellHeight(index: index)
                                        }
                                    }
                                    height += 50
                                } else {
                                    if let reviews = self.restaurantMenu?.menu?.reviews?.reviews {
                                        for (index, _) in reviews.enumerated() {
                                            height += self.menuReviewViewCellHeight(index: index)
                                        }
                                    }
                                }
                                height += 12
                            } else {
                                let emptyTextRect = NSString(string: "No Reviews For This Menu").boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: 23)!], context: nil)
                                height += 30 + 90 + 12 + emptyTextRect.height + 30
                            }
                            return height
                        default:
                            return 0
                        }
                    } else {
                        switch indexPath.item {
                        case 0:
                            return self.restaurantDetailsViewHeight
                        case 1:
                            var height: CGFloat = 0
                            if promotions?.count ?? 0 > 0 {
                                height += 50
                                if let promotions = self.promotions {
                                    for (index, _) in promotions.enumerated() {
                                        height += self.menuPromotionViewCellHeight(index: index)
                                    }
                                    height -= 10
                                }
                            }
                            return height
                        case 2:
                            var height: CGFloat = 128
                            if self.restaurantMenu?.menu?.reviews?.count ?? 0 > 0 {
                                if self.restaurantMenu?.menu?.reviews?.count ?? 0 > 5 {
                                    let reviews = self.restaurantMenu?.menu?.reviews?.reviews?.prefix(5)
                                    if let reviews = reviews {
                                        for (index, _) in reviews.enumerated() {
                                            height += self.menuReviewViewCellHeight(index: index)
                                        }
                                    }
                                    height += 50
                                } else {
                                    if let reviews = self.restaurantMenu?.menu?.reviews?.reviews {
                                        for (index, _) in reviews.enumerated() {
                                            height += self.menuReviewViewCellHeight(index: index)
                                        }
                                    }
                                }
                                height += 12
                            } else {
                                let emptyTextRect = NSString(string: "No Reviews For This Menu").boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: 23)!], context: nil)
                                height += 30 + 90 + 12 + emptyTextRect.height + 30
                            }
                            return height
                        default:
                            return 0
                        }
                    }
                } else {
                    if self.restaurantMenu?.type!.id == 3 {
                        switch indexPath.item {
                        case 0:
                            return self.restaurantDetailsViewHeight
                        case 1:
                            var height: CGFloat = 0
                            if self.restaurantMenu?.menu?.foods?.count ?? 0 > 0 {
                                height += 50
                                if let foods = self.restaurantMenu?.menu?.foods?.foods {
                                    for (index, _) in foods.enumerated() {
                                        height += self.dishFoodViewCellHeight(index: index)
                                    }
                                    height -= 10
                                }
                            }
                            return height
                        case 2:
                            var height: CGFloat = 128
                            if self.restaurantMenu?.menu?.reviews?.count ?? 0 > 0 {
                                if self.restaurantMenu?.menu?.reviews?.count ?? 0 > 5 {
                                    let reviews = self.restaurantMenu?.menu?.reviews?.reviews?.prefix(5)
                                    if let reviews = reviews {
                                        for (index, _) in reviews.enumerated() {
                                            height += self.menuReviewViewCellHeight(index: index)
                                        }
                                    }
                                    height += 50
                                } else {
                                    if let reviews = self.restaurantMenu?.menu?.reviews?.reviews {
                                        for (index, _) in reviews.enumerated() {
                                            height += self.menuReviewViewCellHeight(index: index)
                                        }
                                    }
                                }
                                height += 12
                            } else {
                                let emptyTextRect = NSString(string: "No Reviews For This Menu").boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: 23)!], context: nil)
                                height += 30 + 90 + 12 + emptyTextRect.height + 30
                            }
                            return height
                        default:
                            return 0
                        }
                    } else {
                        switch indexPath.item {
                        case 0:
                            return self.restaurantDetailsViewHeight
                        case 1:
                            var height: CGFloat = 128
                            if self.restaurantMenu?.menu?.reviews?.count ?? 0 > 0 {
                                if self.restaurantMenu?.menu?.reviews?.count ?? 0 > 5 {
                                    let reviews = self.restaurantMenu?.menu?.reviews?.reviews?.prefix(5)
                                    if let reviews = reviews {
                                        for (index, _) in reviews.enumerated() {
                                            height += self.menuReviewViewCellHeight(index: index)
                                        }
                                    }
                                    height += 50
                                } else {
                                    if let reviews = self.restaurantMenu?.menu?.reviews?.reviews {
                                        for (index, _) in reviews.enumerated() {
                                            height += self.menuReviewViewCellHeight(index: index)
                                        }
                                    }
                                }
                                height += 12
                            } else {
                                let emptyTextRect = NSString(string: "No Reviews For This Menu").boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: 23)!], context: nil)
                                height += 30 + 90 + 12 + emptyTextRect.height + 30
                            }
                            return height
                        default:
                            return 0
                        }
                    }
                }
            case self.restaurantMenuDishFoodsView:
                return self.dishFoodViewCellHeight(index: indexPath.item)
            case self.restaurantMenuPromotionsView:
                return self.menuPromotionViewCellHeight(index: indexPath.item)
            case self.restaurantMenuReviewsView:
                if self.restaurantMenu?.menu?.reviews?.count ?? 0 > 0 {
                    return self.menuReviewViewCellHeight(index: indexPath.item)
                } else {
                    let emptyTextRect = NSString(string: "No Reviews For This Menu").boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: 23)!], context: nil)
                    return  128 + 30 + 90 + 12 + emptyTextRect.height + 30
                }
            default:
                return 0
            }
        } else { return 447 }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch tableView {
        case self.tableView:
            return 0
        case self.restaurantMenuReviewsView:
            return 128
        default:
            return 50
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch tableView {
        case self.restaurantMenuReviewsView:
            if self.restaurantMenu?.menu?.reviews?.count ?? 0 > 0 {
                let footerView: UIView = {
                    let view = UIView()
                    view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
                    view.backgroundColor = .white
                    return view
                }()
                
                let separatorView: UIView = {
                    let view = UIView()
                    view.translatesAutoresizingMaskIntoConstraints = false
                    view.backgroundColor = Colors.colorVeryLightGray
                    return view
                }()
                
                let labelView: UIView = {
                    let view = UILabel()
                    view.translatesAutoresizingMaskIntoConstraints = false
                    view.text = "Show More".uppercased()
                    view.font = UIFont(name: "Poppins-Medium", size: 14)
                    view.textColor = Colors.colorPrimary
                    return view
                }()
                
                footerView.addSubview(labelView)
                footerView.addSubview(separatorView)
                footerView.addConstraintsWithFormat(format: "H:[v0]", views: labelView)
                footerView.addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: separatorView)
                footerView.addConstraintsWithFormat(format: "V:|-12-[v0(0.5)]-12-[v1]", views: separatorView, labelView)
                footerView.addConstraint(NSLayoutConstraint(item: footerView, attribute: .centerX, relatedBy: .equal, toItem: labelView, attribute: .centerX, multiplier: 1, constant: 0))
                
                footerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showMoreReviews(_:))))
                
                return footerView
            } else { return nil }
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch tableView {
        case self.restaurantMenuReviewsView:
            return self.restaurantMenu?.menu?.reviews?.count ?? 0 > 5 ? 50 : 0
        default:
            return 0
        }
    }
    
    @objc public func showMoreReviews(_ sender: Any?) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let reviewsController = storyboard.instantiateViewController(withIdentifier: "RestaurantMenuReviews") as! RestaurantMenuReviewsViewController
        reviewsController.menuReviews = self.restaurantMenu?.menu?.reviews
        reviewsController.reviews = self.restaurantMenu?.menu?.reviews?.reviews
        reviewsController.reviewsURL = self.restaurantMenu?.urls?.apiReviews
        let sheetController = SheetViewController(controller: reviewsController, sizes: [.halfScreen, .fullScreen])
        sheetController.blurBottomSafeArea = false
        sheetController.adjustForBottomSafeArea = true
        sheetController.topCornersRadius = 8
        sheetController.dismissOnBackgroundTap = true
        sheetController.extendBackgroundBehindHandle = false
        sheetController.willDismiss = {_ in }
        sheetController.didDismiss = {_ in }
        self.present(sheetController, animated: false, completion: nil)
    }
    
    func provideDisplacementItem(atIndex index: Int) -> DisplaceableView? {
        return index < imageItems.count ? imageItems[index].imageView as? DisplaceableView : nil
    }
    
    func itemCount() -> Int {
        return imageItems.count
    }
    
    func provideGalleryItem(_ index: Int) -> GalleryItem {
        return imageItems[index].galleryItem
    }
    
    func removeGalleryItem(at index: Int) {}
    
    func galleryConfiguration() -> GalleryConfiguration {

        return [

            GalleryConfigurationItem.closeButtonMode(.builtIn),

            GalleryConfigurationItem.pagingMode(.standard),
            GalleryConfigurationItem.presentationStyle(.displacement),
            GalleryConfigurationItem.hideDecorationViewsOnLaunch(false),

            GalleryConfigurationItem.swipeToDismissMode(.vertical),
            GalleryConfigurationItem.toggleDecorationViewsBySingleTap(false),
            GalleryConfigurationItem.activityViewByLongPress(false),

            GalleryConfigurationItem.overlayColor(UIColor(white: 0.035, alpha: 1)),
            GalleryConfigurationItem.overlayColorOpacity(1),
            GalleryConfigurationItem.overlayBlurOpacity(1),
            GalleryConfigurationItem.overlayBlurStyle(UIBlurEffect.Style.light),
            
            GalleryConfigurationItem.videoControlsColor(.white),

            GalleryConfigurationItem.maximumZoomScale(8),
            GalleryConfigurationItem.swipeToDismissThresholdVelocity(500),

            GalleryConfigurationItem.doubleTapToZoomDuration(0.15),

            GalleryConfigurationItem.blurPresentDuration(0.5),
            GalleryConfigurationItem.blurPresentDelay(0),
            GalleryConfigurationItem.colorPresentDuration(0.25),
            GalleryConfigurationItem.colorPresentDelay(0),

            GalleryConfigurationItem.blurDismissDuration(0.1),
            GalleryConfigurationItem.blurDismissDelay(0.4),
            GalleryConfigurationItem.colorDismissDuration(0.45),
            GalleryConfigurationItem.colorDismissDelay(0),

            GalleryConfigurationItem.itemFadeDuration(0.3),
            GalleryConfigurationItem.decorationViewsFadeDuration(0.15),
            GalleryConfigurationItem.rotationDuration(0.15),

            GalleryConfigurationItem.displacementDuration(0.55),
            GalleryConfigurationItem.reverseDisplacementDuration(0.25),
            GalleryConfigurationItem.displacementTransitionStyle(.springBounce(0.7)),
            GalleryConfigurationItem.displacementTimingCurve(.linear),

            GalleryConfigurationItem.statusBarHidden(true),
            GalleryConfigurationItem.displacementKeepOriginalInPlace(false),
            GalleryConfigurationItem.displacementInsetMargin(50),
            
            GalleryConfigurationItem.thumbnailsButtonMode(.none),
            GalleryConfigurationItem.deleteButtonMode(.none)
        ]
    }
    
    @objc func openMenuImages(_ sender: UITapGestureRecognizer){
        
        let galleryViewController = GalleryViewController(startIndex: self.imageIndex, itemsDataSource: self, itemsDelegate: self, displacedViewsDataSource: self, configuration: galleryConfiguration())

        galleryViewController.launchedCompletion = {  }
        galleryViewController.closedCompletion = {  }
        galleryViewController.swipedToDismissCompletion = {  }
        galleryViewController.landedPageAtIndexCompletion = { index in }
        
        self.presentImageGallery(galleryViewController)
    }
    
    @objc func editMenuReview(_ sender: Any?){
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let editReviewController = storyboard.instantiateViewController(withIdentifier: "EditMenuReview") as! EditMenuReviewViewController
        editReviewController.menu = self.restaurantMenu
        editReviewController.onDismiss = { edited in
            
            if editReviewController.reviewComment.textColor == Colors.colorGray {
                
                let comment = editReviewController.reviewComment.text!
                let rating = editReviewController.reviewRating.rating
                
                editReviewController.submitButton.isEnabled = false
                editReviewController.reviewComment.resignFirstResponder()
                
                let params: Parameters = ["review": "\(rating)", "comment": comment]
                
                guard let url = URL(string: "\(URLs.hostEndPoint)\((self.restaurantMenu?.urls?.apiAddReview)!)") else { return }
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                
                request.addValue(self.session.token!, forHTTPHeaderField: "AUTHORIZATION")
                request.setValue(self.session.token!, forHTTPHeaderField: "AUTHORIZATION")
                
                let boundary = Requests().generateBoundary()
                request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                
                let httpBody = Requests().createDataBody(withParameters: params, media: nil, boundary: boundary)
                request.httpBody = httpBody
                
                let session = URLSession.shared
                
                session.dataTask(with: request){ (data, response, error) in
                    if response != nil {}
                    if let data = data {
                        do {
                            let serverResponse = try JSONDecoder().decode(ServerResponse.self, from: data)
                            DispatchQueue.main.async {
                                editReviewController.submitButton.isEnabled = true
                                if serverResponse.type == "success" {
                                    editReviewController.dismiss(animated: true, completion: nil)
                                    Toast.makeToast(message: serverResponse.message, duration: Toast.MID_LENGTH_DURATION, style: .success)
                                    self.loadRestaurantMenu()
                                } else {
                                    Toast.makeToast(message: serverResponse.message, duration: Toast.MID_LENGTH_DURATION, style: .error)
                                }
                            }
                        } catch {}
                    }
                }.resume()
                
            } else {
                Toast.makeToast(message: "Review Cannot Be Empty", duration: Toast.MID_LENGTH_DURATION, style: .error)
            }
        }
        self.present(editReviewController, animated: true, completion: nil)
    }
    
    private func dishFoodViewCellHeight(index: Int) -> CGFloat {
        
        let device = UIDevice.type
        
        var menuNameTextSize: CGFloat = 15
        var menuDescriptionTextSize: CGFloat = 13
        var menuImageConstant: CGFloat = 80
        
        let menu = self.restaurantMenu?.menu?.foods?.foods![index]
        let heightConstant: CGFloat = 95
        
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
        
        let menuNameRect = NSString(string: menu!.food.name!).boundingRect(with: CGSize(width: frameWidth, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: menuNameTextSize)!], context: nil)
        
        let menuDescriptionRect = NSString(string: menu!.food.description!).boundingRect(with: CGSize(width: frameWidth - 18, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: menuDescriptionTextSize)!], context: nil)
        
        return heightConstant + menuNameRect.height + menuDescriptionRect.height
    }
    
    private func menuPromotionViewCellHeight(index: Int) -> CGFloat {
        
        var promotionOccasionHeight: CGFloat = 20
        var promotionPeriodHeight: CGFloat = 15
        var promotionReductionHeight: CGFloat = 0
        var promotionSupplementHeight: CGFloat = 0
        let device = UIDevice.type
        
        var promotionOccationTextSize: CGFloat = 15
        let promotionTextSize: CGFloat = 13
        var promotionPosterConstant: CGFloat = 80
        
        let promotion = self.promotions![index]
        
        if UIDevice.smallDevices.contains(device) {
            promotionPosterConstant = 55
            promotionOccationTextSize = 14
        } else if UIDevice.mediumDevices.contains(device) {
            promotionPosterConstant = 70
            promotionOccationTextSize = 15
        }
        
        let frameWidth = view.frame.width - (60 + promotionPosterConstant)
        
        let promotionOccationRect = NSString(string: promotion.occasionEvent).boundingRect(with: CGSize(width: frameWidth, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: promotionOccationTextSize)!], context: nil)
        
        let promotionPeriodRect = NSString(string: promotion.period).boundingRect(with: CGSize(width: frameWidth - 18, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: promotionTextSize)!], context: nil)
        
        promotionOccasionHeight = promotionOccationRect.height
        promotionPeriodHeight = promotionPeriodRect.height
        
        if promotion.reduction.hasReduction {
            let reductionText = "Order this menu and get \(promotion.reduction.amount) \((promotion.reduction.reductionType)!) reduction"
            let promotionReductionRect = NSString(string: reductionText).boundingRect(with: CGSize(width: frameWidth - 18, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: promotionTextSize)!], context: nil)
            promotionReductionHeight = promotionReductionRect.height
        }
        
        if promotion.supplement.hasSupplement {
            var supplementText: String!
            if !promotion.supplement.isSame {
                supplementText = "Order \(promotion.supplement.minQuantity) of this menu and get \(promotion.supplement.quantity) free \((promotion.supplement.supplement?.menu?.name)!)"
            } else {
                supplementText = "Order \(promotion.supplement.minQuantity) of this menu and get \(promotion.supplement.quantity) more for free"
            }
            let promotionSupplementRect = NSString(string: supplementText).boundingRect(with: CGSize(width: frameWidth - 18, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: promotionTextSize)!], context: nil)
            promotionSupplementHeight = promotionSupplementRect.height
        }
        
        var valueToAdd: CGFloat = 0
        
        if promotion.reduction.hasReduction && promotion.supplement.hasSupplement {
            valueToAdd = 4
        }
        
        return 40 + promotionOccasionHeight + promotionPeriodHeight + promotionReductionHeight + promotionSupplementHeight + 12 + 32 + valueToAdd
    }
    
    private func menuReviewViewCellHeight(index: Int) -> CGFloat {
        if let reviews = self.restaurantMenu?.menu?.reviews?.reviews {
            
            let review = reviews[index]
            
            var userNameHeight: CGFloat = 20
            var reviewTextHeight: CGFloat = 15
            
            let userNameTextSize: CGFloat = 14
            let reviewTextSize: CGFloat = 11
            let userImageConstant: CGFloat = 50
            
            let frameWidth = view.frame.width - (60 + userImageConstant)
            
            let userNameRect = NSString(string: review.user.name).boundingRect(with: CGSize(width: frameWidth, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: userNameTextSize)!], context: nil)
            
            let reviewTextRect = NSString(string: review.comment).boundingRect(with: CGSize(width: frameWidth, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: reviewTextSize)!], context: nil)
            
            reviewTextHeight = reviewTextRect.height
            userNameHeight = userNameRect.height
            
            return 4 + 10 + 4 + 26 + 12 + reviewTextHeight + userNameHeight + 12 + 12
        }
        return 0
    }
    
    var restaurantDetailsViewHeight: CGFloat {
        
        if let menu = self.restaurantMenu {
            
            var restaurantMenuNameHeight: CGFloat = 28
            var restaurantMenuDescriptionHeight: CGFloat = 16
            var restaurantMenuIngredientsHeight: CGFloat = 16
            let device = UIDevice.type
            
            var restaurantMenuNameTextSize: CGFloat = 20
            var restaurantDescriptionTextSize: CGFloat = 13
            
            var menuPriceHeight: CGFloat = 8
            
            if UIDevice.smallDevices.contains(device) {
                restaurantMenuNameTextSize = 15
                restaurantDescriptionTextSize = 12
            } else if UIDevice.mediumDevices.contains(device) {
                restaurantMenuNameTextSize = 17
            }
            
            let frameWidth = self.view.frame.width - 16
            
            let menuNameRect = NSString(string: (menu.menu?.name!)!).boundingRect(with: CGSize(width: frameWidth, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: restaurantMenuNameTextSize)!], context: nil)
            
            let menuDescriptionRect = NSString(string: (menu.menu?.description!)!).boundingRect(with: CGSize(width: frameWidth - 20, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: restaurantDescriptionTextSize)!], context: nil)
            
            restaurantMenuNameHeight = menuNameRect.height - 5
            restaurantMenuDescriptionHeight = menuDescriptionRect.height
            
            if menu.menu?.showIngredients ?? true {
                let menuIngredientsRect = NSString(string: (menu.menu?.ingredients!)!.withoutHtml).boundingRect(with: CGSize(width: frameWidth, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 13)!], context: nil)
                
                restaurantMenuIngredientsHeight = menuIngredientsRect.height
            }
            
            let priceRect = NSString(string: "UGX 10,000").boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: 27)!], context: nil)
                           
            let quantityRect = NSString(string: "2 packs / counts").boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 12)!], context: nil)
                           
            let lastPriceRect = NSString(string: "UGX 6,000").boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 12)!], context: nil)
            
            if (menu.menu?.isCountable)! && Double((menu.menu?.price)!) != Double((menu.menu?.lastPrice)!) {
                menuPriceHeight += priceRect.height + quantityRect.height + lastPriceRect.height
            } else if !(menu.menu?.isCountable)! && Double((menu.menu?.price)!) != Double((menu.menu?.lastPrice)!) {
                menuPriceHeight += priceRect.height + lastPriceRect.height
            } else if (menu.menu?.isCountable)! && !(Double((menu.menu?.price)!) != Double((menu.menu?.lastPrice)!)){
                menuPriceHeight += priceRect.height + quantityRect.height
            } else { menuPriceHeight += priceRect.height }
            
            let margins: CGFloat = 8 * 14
            let separators: CGFloat = 0.5 * 5
            let tiles: CGFloat = 26 * 2
            
            let constantHeight: CGFloat = 320 + margins + separators + tiles + 60 + 18 + 17
            
            return constantHeight + restaurantMenuNameHeight + restaurantMenuDescriptionHeight + restaurantMenuIngredientsHeight + menuPriceHeight
        }
        return 700
    }
    
    private func reviewHeaderView(width: CGFloat) -> UIView {
        
        let view = UIView()
        view.backgroundColor = .white
        
        let reviewsCountView: UILabel = {
            let label = UILabel()
            label.textColor = Colors.colorGray
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: "Poppins-SemiBold", size: 32)!
            label.text = "0.0"
            return label
        }()
        
        let reviewsMaxView: UILabel = {
            let label = UILabel()
            label.textColor = Colors.colorGray
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: "Poppins-Regular", size: 14)!
            label.text = "Out of 5"
            return label
        }()
        
        let reviewsAverageView: UIView = {
            let reviewView = UIView()
            reviewView.translatesAutoresizingMaskIntoConstraints = false
            return reviewView
        }()
        
        reviewsAverageView.addSubview(reviewsCountView)
        reviewsAverageView.addSubview(reviewsMaxView)
        
        reviewsAverageView.addConstraintsWithFormat(format: "H:[v0]", views: reviewsCountView)
        reviewsAverageView.addConstraintsWithFormat(format: "H:[v0]", views: reviewsMaxView)
        reviewsAverageView.addConstraintsWithFormat(format: "V:[v0(35)]-4-[v1(16)]", views: reviewsCountView, reviewsMaxView)
        
        reviewsAverageView.addConstraint(NSLayoutConstraint(item: reviewsAverageView, attribute: .centerX, relatedBy: .equal, toItem: reviewsCountView, attribute: .centerX, multiplier: 1, constant: 0))
        reviewsAverageView.addConstraint(NSLayoutConstraint(item: reviewsAverageView, attribute: .centerX, relatedBy: .equal, toItem: reviewsMaxView, attribute: .centerX, multiplier: 1, constant: 0))
        
        let reviewsBarView: ReviewsPercentsView = {
            let barView = ReviewsPercentsView()
            barView.translatesAutoresizingMaskIntoConstraints = false
            return barView
        }()
        
        reviewsBarView.width = width - 36 - 70
        
        if let reviews = self.restaurantMenu?.menu?.reviews {
            reviewsBarView.dataEntries = [
                BarChartEntry(score: reviews.percents[4], title: "5 ★"),
                BarChartEntry(score: reviews.percents[3], title: "4 ★"),
                BarChartEntry(score: reviews.percents[2], title: "3 ★"),
                BarChartEntry(score: reviews.percents[1], title: "2 ★"),
                BarChartEntry(score: reviews.percents[0], title: "1 ★")
            ]
            reviewsCountView.text = "\(reviews.average)"
        }
        
        let reviewsTitleView: UILabel = {
            let label = UILabel()
            label.textColor = Colors.colorGray
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: "Poppins-Medium", size: 14)!
            label.text = "Ratings & Reviews".uppercased()
            return label
        }()
        
        let separatorView: UIView = {
            let separator = UIView()
            separator.translatesAutoresizingMaskIntoConstraints = false
            separator.backgroundColor = Colors.colorVeryLightGray
            return separator
        }()
        
        view.addSubview(reviewsTitleView)
        view.addSubview(reviewsAverageView)
        view.addSubview(reviewsBarView)
        view.addSubview(separatorView)
        view.addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: separatorView)
        view.addConstraintsWithFormat(format: "H:|-12-[v0]", views: reviewsTitleView)
        view.addConstraintsWithFormat(format: "V:|-8-[v0(22)]-4-[v1(80)]-0-[v2(0.5)]|", views: reviewsTitleView, reviewsAverageView, separatorView)
        view.addConstraintsWithFormat(format: "V:[v0(80)]|", views: reviewsBarView)
        view.addConstraintsWithFormat(format: "H:|-12-[v0(70)]-12-[v1(\(width - 36 - 70))]-12-|", views: reviewsAverageView, reviewsBarView)
        
        return view
    }
}

class RestaurantMenuHeaderImageViewCell: UICollectionViewCell {
    
    let menuImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "default_meal")
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    open var imageURL: String? {
        didSet { self.setup() }
    }
    
    private func setup(){
        menuImageView.kf.setImage(
            with: URL(string: self.imageURL!)!,
            placeholder: UIImage(named: "default_meal"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ]
        )
        addSubview(menuImageView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: menuImageView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: menuImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
