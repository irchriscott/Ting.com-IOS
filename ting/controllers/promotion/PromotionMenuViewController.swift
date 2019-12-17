//
//  PromotionMenuViewController.swift
//  ting
//
//  Created by Christian Scott on 12/16/19.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit
import ImageViewer

class PromotionMenuViewController: UITableViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, GalleryDisplacedViewsDataSource, GalleryItemsDataSource, GalleryItemsDelegate {
    
    private let headerIdImage = "headerIdImage"
    private let cellIdPromotionDetails = "cellIdPromotionDetails"
    
    struct DataImageItem {
        let imageView: UIImageView
        let galleryItem: GalleryItem
    }
    
    var imageItems: [DataImageItem] = []
    
    var promotion: MenuPromotion? {
        didSet {}
    }
    
    var promotionURL: String? {
        didSet {}
    }
    
    var controller: HomeRestaurantsViewController? {
        didSet {}
    }
    
    lazy var promotionDetailsView: UICollectionView = {
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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        
        if let promotion = self.promotion {
            let imageView = UIImageView()
            imageView.load(url: URL(string: "\(URLs.hostEndPoint)\(promotion.posterImage)")!)
            
            let galleryItem = GalleryItem.image { $0(imageView.image ?? UIImage(named: "default_meal")!) }
            imageItems.append(DataImageItem(imageView: imageView, galleryItem: galleryItem))
        }
        
        self.promotionDetailsView.register(PromotionMenuHeaderImageViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: self.headerIdImage)
        self.promotionDetailsView.register(PromotionMenuDetailsViewCell.self, forCellWithReuseIdentifier: self.cellIdPromotionDetails)
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
        self.navigationItem.title = "Promotion Menu"
        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdPromotionDetails, for: indexPath) as! PromotionMenuDetailsViewCell
        cell.promotion = self.promotion
        cell.parentController = self
        cell.controller = self.controller
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headerIdImage, for: indexPath) as! RestaurantMenuHeaderImageViewCell
        if let promotion = self.promotion {
            let image = promotion.posterImage
            cell.imageURL = "\(URLs.hostEndPoint)\(image)"
        }
            
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PromotionMenuViewController.openPromotionPosterImage(_:))))
            
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 320)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 380)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
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
    
    @objc func openPromotionPosterImage(_ sender: UITapGestureRecognizer){
        
        let galleryViewController = GalleryViewController(startIndex: 0, itemsDataSource: self, itemsDelegate: self, displacedViewsDataSource: self, configuration: galleryConfiguration())

        galleryViewController.launchedCompletion = {  }
        galleryViewController.closedCompletion = {  }
        galleryViewController.swipedToDismissCompletion = {  }
        galleryViewController.landedPageAtIndexCompletion = { index in }
        
        self.presentImageGallery(galleryViewController)
    }

}

class PromotionMenuHeaderImageViewCell: UICollectionViewCell {
    
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
