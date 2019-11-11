//
//  RestaurantMenuViewController.swift
//  ting
//
//  Created by Christian Scott on 05/11/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit
import ImageViewer

class RestaurantMenuViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, GalleryDisplacedViewsDataSource, GalleryItemsDataSource, GalleryItemsDelegate {
    
    struct DataImageItem {
        let imageView: UIImageView
        let galleryItem: GalleryItem
    }
    
    var imageItems:[DataImageItem] = []
    
    private var imageIndex: Int = 0
    private let headerIdImage = "headerIdImage"
    private let cellIdMenuDetails = "cellIdMenuDetails"
    
    private let cellIdDefault = "cellId"
    private let headerIdDefault = "headerId"
    private let cellIdTableDishFood = "tableIdDishFood"
    private let cellIdTableHeaderDishFood = "tableIdDishFoodHeader"
    private let cellTableViewIdDefault = "tableViewIdDefault"
    
    var restaurantMenu: RestaurantMenu? {
        didSet {
            if let menu = self.restaurantMenu {
                let images = menu.menu?.images?.images
                self.imageIndex = Int.random(in: 0...images!.count - 1)
            }
        }
    }
    
    var controller: HomeRestaurantsViewController? {
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
        return view
    }()
    
    lazy var restaurantMenuDishFoodsView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.estimatedRowHeight = view.rowHeight
        view.rowHeight = UITableView.automaticDimension
        return view
    }()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setupNavigationBar()
        self.loadRestaurantMenu()
        
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
        
        self.restaurantDetailsView.register(RestaurantMenuHeaderImageViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: self.headerIdImage)
        self.restaurantDetailsView.register(MenuDetailsViewCell.self, forCellWithReuseIdentifier: self.cellIdMenuDetails)
        self.restaurantDetailsView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.cellIdDefault)
        
        self.restaurantMenuDishFoodsView.register(MenuDishFoodViewCell.self, forCellReuseIdentifier: cellIdTableDishFood)
        
        self.view.addSubview(restaurantDetailsView)
        if self.restaurantMenu?.type?.id == 3 {
            self.view.addSubview(restaurantMenuDishFoodsView)
            self.view.addConstraintsWithFormat(format: "H:|[v0]|", views: restaurantMenuDishFoodsView)
        }
        
        self.view.addConstraintsWithFormat(format: "H:|[v0]|", views: restaurantDetailsView)
        if self.restaurantMenu?.type?.id == 3 {
            self.view.addConstraintsWithFormat(format: "V:|[v0]-8-[v1]|", views: restaurantDetailsView, restaurantMenuDishFoodsView)
        } else {
            self.view.addConstraintsWithFormat(format: "V:|[v0]|", views: restaurantDetailsView)
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
        self.navigationItem.title = "Restaurant Menu"
        
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
            APIDataProvider.instance.getRestaurantmenu(url: "\(URLs.hostEndPoint)\((menu.urls?.apiGet)!)") { (restoMenu) in
                DispatchQueue.main.async {
                    self.restaurantMenu = restoMenu
                    self.restaurantDetailsView.reloadData()
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
            return CGSize(width: self.view.frame.width, height: 380)
        default:
            return CGSize(width: self.view.frame.width, height: 0)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case restaurantMenuDishFoodsView:
            return self.restaurantMenu?.type?.id == 3 ? self.restaurantMenu?.menu?.foods?.count ?? 0 : 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case restaurantMenuDishFoodsView:
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdTableDishFood, for: indexPath) as! MenuDishFoodViewCell
            return cell
        default:
            return tableView.dequeueReusableCell(withIdentifier: self.cellTableViewIdDefault, for: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
        default:
            titleLabel.text = "Some Title".uppercased()
            break
        }
        
        headerView.addSubview(titleLabel)
        headerView.addConstraintsWithFormat(format: "H:|-8-[v0]", views: titleLabel)
        headerView.addConstraintsWithFormat(format: "V:[v0]", views: titleLabel)
        headerView.addConstraint(NSLayoutConstraint(item: headerView, attribute: .centerY, relatedBy: .equal, toItem: titleLabel, attribute: .centerY, multiplier: 1, constant: 0))
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
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
}

class RestaurantMenuHeaderImageViewCell: UICollectionViewCell {
    
    let menuImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "default_meal")
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    open var imageURL: String? {
        didSet { self.setup() }
    }
    
    private func setup(){
        menuImageView.load(url: URL(string: self.imageURL!)!)
        addSubview(menuImageView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: menuImageView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: menuImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
