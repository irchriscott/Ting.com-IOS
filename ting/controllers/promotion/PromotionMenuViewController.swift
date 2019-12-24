//
//  PromotionMenuViewController.swift
//  ting
//
//  Created by Christian Scott on 12/16/19.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit
import ImageViewer
import FittedSheets

class PromotionMenuViewController: UITableViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, GalleryDisplacedViewsDataSource, GalleryItemsDataSource, GalleryItemsDelegate {
    
    private let headerIdImage = "headerIdImage"
    private let cellIdPromotionDetails = "cellIdPromotionDetails"
    private let tableViewCellId = "tableViewCellId"
    private let restaurantMenuItemCellId = "restaurantMenuCellId"
    
    struct DataImageItem {
        let imageView: UIImageView
        let galleryItem: GalleryItem
    }
    
    var promotedMenus: [RestaurantMenu]? {
        didSet {}
    }
    
    var imageItems: [DataImageItem] = []
    
    var promotion: MenuPromotion? {
        didSet {
            if let promotion = self.promotion {
                switch promotion.promotionItem.type.id {
                case "00":
                    if let branch = promotion.branch {
                        self.promotedMenus = branch.menus.menus
                    }
                    break
                case "01":
                    if let branch = promotion.branch {
                        self.promotedMenus = branch.menus.menus?.filter({ (menu) -> Bool in
                            menu.type?.id == 1
                            })
                    }
                    break
                case "02":
                    if let branch = promotion.branch {
                        self.promotedMenus = branch.menus.menus?.filter({ (menu) -> Bool in
                            menu.type?.id == 2
                            })
                    }
                    break
                case "03":
                    if let branch = promotion.branch {
                        self.promotedMenus = branch.menus.menus?.filter({ (menu) -> Bool in
                            menu.type?.id == 3
                            })
                    }
                    break
                case "04":
                    if let menu = promotion.promotionItem.menu {
                        promotedMenus?.append(menu)
                    }
                    break
                case "05":
                    if let branch = promotion.branch, let category = promotion.promotionItem.category {
                        self.promotedMenus = branch.menus.menus?.filter({ (menu) -> Bool in
                            menu.menu?.category?.id == category.id
                            })
                    }
                    break
                default: break
                    
                }
                self.tableView.reloadData()
            }
        }
    }
    
    var promotionURL: String? {
        didSet {
            if let url = self.promotionURL {
                self.getMenuPromotion(url: url)
            }
        }
    }
    
    var controller: UIViewController? {
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
    
    lazy var promotedMenusView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.isScrollEnabled = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        
        self.tableView.separatorStyle = .none
        
        if let promo = self.promotion {
            self.getMenuPromotion(url: promo.urls.apiGet)
        }
        
        if let promotion = self.promotion {
            let imageView = UIImageView()
            imageView.load(url: URL(string: "\(URLs.hostEndPoint)\(promotion.posterImage)")!)
            
            let galleryItem = GalleryItem.image { $0(imageView.image ?? UIImage(named: "default_meal")!) }
            imageItems.append(DataImageItem(imageView: imageView, galleryItem: galleryItem))
        }
        
        self.promotionDetailsView.register(PromotionMenuHeaderImageViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: self.headerIdImage)
        self.promotionDetailsView.register(PromotionMenuDetailsViewCell.self, forCellWithReuseIdentifier: self.cellIdPromotionDetails)
        self.promotedMenusView.register(PromotedMenuViewCell.self, forCellReuseIdentifier: self.restaurantMenuItemCellId)
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.tableViewCellId)
    }
    
    private func getMenuPromotion(url: String) {
        APIDataProvider.instance.getPromotionMenu(url: "\(URLs.hostEndPoint)\(url)") { (promo) in
            DispatchQueue.main.async {
                self.promotion = promo
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
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headerIdImage, for: indexPath) as! PromotionMenuHeaderImageViewCell
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
        return CGSize(width: self.view.frame.width, height: self.promotionDetailsCellHeight)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.tableView:
            return 2
        case self.promotedMenusView:
            return self.promotedMenus?.count ?? 0
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case self.tableView:
            switch indexPath.item {
            case 0:
                let promotionDetailsCell = tableView.dequeueReusableCell(withIdentifier: self.tableViewCellId, for: indexPath)
                promotionDetailsCell.addSubview(promotionDetailsView)
                promotionDetailsCell.addConstraintsWithFormat(format: "H:|[v0]|", views: promotionDetailsView)
                promotionDetailsCell.addConstraintsWithFormat(format: "V:|[v0]|", views: promotionDetailsView)
                promotionDetailsCell.selectionStyle = .none
                return promotionDetailsCell
            case 1:
                let promotedMenusCell = tableView.dequeueReusableCell(withIdentifier: self.tableViewCellId, for: indexPath)
                promotedMenusCell.addSubview(promotedMenusView)
                promotedMenusCell.addConstraintsWithFormat(format: "H:|[v0]|", views: promotedMenusView)
                promotedMenusCell.addConstraintsWithFormat(format: "V:|[v0]|", views: promotedMenusView)
                promotedMenusCell.selectionStyle = .none
                return promotedMenusCell
            default:
                return tableView.dequeueReusableCell(withIdentifier: self.tableViewCellId, for: indexPath)
            }
        case self.promotedMenusView:
            let promotedMenuCell = tableView.dequeueReusableCell(withIdentifier: self.restaurantMenuItemCellId, for: indexPath) as! PromotedMenuViewCell
            promotedMenuCell.selectionStyle = .none
            promotedMenuCell.restaurantMenu = self.promotedMenus![indexPath.item]
            return promotedMenuCell
        default:
            return tableView.dequeueReusableCell(withIdentifier: self.tableViewCellId, for: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case self.tableView:
            break
        case self.promotedMenusView:
            let menu = self.promotedMenus?[indexPath.item]
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let menuController = storyboard.instantiateViewController(withIdentifier: "RestaurantMenuBottomView") as! BottomSheetMenuControllerView
            menuController.menu = menu
            menuController.controller = self.controller
            let sheetController = SheetViewController(controller: menuController, sizes: [.fixed(415), .fixed(640)])
            sheetController.blurBottomSafeArea = false
            sheetController.adjustForBottomSafeArea = true
            sheetController.topCornersRadius = 8
            sheetController.dismissOnBackgroundTap = true
            sheetController.extendBackgroundBehindHandle = false
            sheetController.willDismiss = {_ in }
            sheetController.didDismiss = {_ in }
            self.controller?.present(sheetController, animated: false, completion: nil)
            break
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case self.tableView:
            switch indexPath.item {
            case 0:
                return self.promotionDetailsCellHeight + 320
            case 1:
                var height: CGFloat = 0
                if self.promotedMenus?.count ?? 0 > 0 {
                    height += 50
                    if let menus = self.promotedMenus {
                        for (index, _) in menus.enumerated() {
                            height += self.promotedMenuCellHeight(index: index)
                        }
                        height += 2
                    }
                }
                return height
            default:
                return 0
            }
        case self.promotedMenusView:
            return self.promotedMenuCellHeight(index: indexPath.item)
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch tableView {
        case self.tableView:
            return nil
        case self.promotedMenusView:
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
                view.text = "Promoted Menus".uppercased()
                view.font = UIFont(name: "Poppins-Regular", size: 16)
                return view
            }()
            
            headerView.addSubview(titleLabel)
            headerView.addConstraintsWithFormat(format: "H:|-12-[v0]", views: titleLabel)
            headerView.addConstraintsWithFormat(format: "V:[v0]", views: titleLabel)
            headerView.addConstraint(NSLayoutConstraint(item: headerView, attribute: .centerY, relatedBy: .equal, toItem: titleLabel, attribute: .centerY, multiplier: 1, constant: 0))
            
            return headerView
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch tableView {
        case self.tableView:
            return 0
        case self.promotedMenusView:
            return 50
        default:
            return 0
        }
    }
    
    private func promotedMenuCellHeight(index: Int) -> CGFloat {
        
        let device = UIDevice.type
        
        var menuNameTextSize: CGFloat = 15
        var menuDescriptionTextSize: CGFloat = 13
        var menuImageConstant: CGFloat = 80
        
        let menu = self.promotedMenus![index]
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
        
        let menuNameRect = NSString(string: (menu.menu?.name!)!).boundingRect(with: CGSize(width: frameWidth, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: menuNameTextSize)!], context: nil)
        
        let menuDescriptionRect = NSString(string: (menu.menu?.description!)!).boundingRect(with: CGSize(width: frameWidth - 18, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: menuDescriptionTextSize)!], context: nil)
        
        return heightConstant + menuNameRect.height + menuDescriptionRect.height
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
    
    var promotionDetailsCellHeight: CGFloat {
        
        if let promotion = self.promotion {
            
            var promotionOccasionHeight: CGFloat = 28
            var promotionPeriodHeight: CGFloat = 15
            var promotionReductionHeight: CGFloat = 0
            var promotionSupplementHeight: CGFloat = 0
            let device = UIDevice.type
            
            var promotionOccationTextSize: CGFloat = 20
            let promotionTextSize: CGFloat = 13
            
            let frameWidth = view.frame.width - 20
            
            if UIDevice.smallDevices.contains(device) {
                promotionOccationTextSize = 15
            } else if UIDevice.mediumDevices.contains(device) {
                promotionOccationTextSize = 17
            }
            
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
            
            var promotionMenuHeight = promotionOccasionHeight + 6 + 26 + 6 + 26 + 4
            
            if promotion.promotionItem.type.id == "04" || promotion.promotionItem.type.id == "05" {
                promotionMenuHeight += 32
            }
            
            let extraHeight = (0.5 * 5) + (8 * 13) + 60 + 32
            return promotionMenuHeight + promotionSupplementHeight + promotionReductionHeight + promotionPeriodHeight + CGFloat(extraHeight)
        }
        return 380
    }

}

class PromotionMenuHeaderImageViewCell: UICollectionViewCell {
    
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
        menuImageView.load(url: URL(string: self.imageURL!)!)
        addSubview(menuImageView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: menuImageView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: menuImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
