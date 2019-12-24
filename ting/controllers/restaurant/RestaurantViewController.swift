//
//  RestaurantViewControllerCollectionViewController.swift
//  ting
//
//  Created by Christian Scott on 20/09/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class RestaurantViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellRestaurantId"
    let headerId = "headerRestaurantId"
    
    var restaurant: Branch? {
        didSet {}
    }
    
    lazy var restaurantTabViewController: RestaurantTabViewController = {
        let controller = RestaurantTabViewController()
        controller.branch = self.restaurant
        controller.promosController.branch = self.restaurant
        controller.promosController.controller = self
        controller.foodsController.branch = self.restaurant
        controller.foodsController.controller = self
        controller.drinksController.branch = self.restaurant
        controller.drinksController.controller = self
        controller.dishesController.branch = self.restaurant
        controller.dishesController.controller = self
        return controller
    }()
    
    lazy var restaurantTabView: UIView = {
        return self.restaurantTabViewController.view
    }()
    
    var promotionViewHeight: CGFloat = 0
    var foodsViewHeight: CGFloat = 0
    var drinksViewHeight: CGFloat = 0
    var dishesViewHeight: CGFloat = 0
    
    var currentHeight: CGFloat = 400 {
        didSet { self.collectionView.reloadData() }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    var canGoToZero: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_menu_25_white"), style: .plain, target: self, action: #selector(openMenu(_:)))
        
        if let branch = self.restaurant {
            APIDataProvider.instance.getRestaurantPromotions(url: "\(URLs.hostEndPoint)\(branch.urls.apiPromotions)") { (promotions) in
                DispatchQueue.main.async {
                    self.restaurantTabViewController.promosController.promotions = promotions.sorted(by: { (promo, _) -> Bool in
                        return promo.isOn && promo.isOnToday
                    })
                    if promotions.count > 0 {
                        for promo in promotions {
                            self.promotionViewHeight += self.menuPromotionViewCellHeight(promotion: promo)
                        }
                        self.promotionViewHeight += CGFloat(12 * promotions.count)
                        self.currentHeight = self.promotionViewHeight
                    } else { self.currentHeight = 400 }
                }
            }
        }
        
        self.restaurantTabViewController.changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            
            if let branch = self.restaurant {

                switch self.restaurantTabViewController.currentIndex {
                case 0:
                    self.collectionView.contentOffset.y = 0
                    if self.canGoToZero {
                        if self.promotionViewHeight > 0 { self.currentHeight = self.promotionViewHeight }
                        else {
                            APIDataProvider.instance.getRestaurantPromotions(url: "\(URLs.hostEndPoint)\(branch.urls.apiPromotions)") { (promotions) in
                                DispatchQueue.main.async {
                                    self.restaurantTabViewController.promosController.promotions = promotions.sorted(by: { (promo, _) -> Bool in
                                        return promo.isOn && promo.isOnToday
                                    })
                                    if promotions.count > 0 {
                                        for promo in promotions {
                                            self.promotionViewHeight += self.menuPromotionViewCellHeight(promotion: promo)
                                        }
                                        self.promotionViewHeight += 60
                                        self.currentHeight = self.promotionViewHeight
                                    } else { self.currentHeight = 400 }
                                }
                            }
                        }
                    }
                case 1:
                    self.canGoToZero = true
                    self.collectionView.contentOffset.y = 0
                    if self.foodsViewHeight > 0 { self.currentHeight = self.foodsViewHeight }
                    else {
                        APIDataProvider.instance.getRestaurantMenus(url: "\(URLs.hostEndPoint)\(branch.urls.apiFoods)") { (menus) in
                            DispatchQueue.main.async {
                                self.restaurantTabViewController.foodsController.menus = menus
                                if menus.count > 0 {
                                    for menu in menus {
                                        self.foodsViewHeight += self.restaurantmenuCellHeight(menu: menu)
                                    }
                                    self.foodsViewHeight += 60
                                    self.currentHeight = self.foodsViewHeight
                                } else { self.currentHeight = 400 }
                            }
                        }
                    }
                case 2:
                    self.canGoToZero = true
                    self.collectionView.contentOffset.y = 0
                    if self.drinksViewHeight > 0 { self.currentHeight = self.drinksViewHeight }
                    else {
                        APIDataProvider.instance.getRestaurantMenus(url: "\(URLs.hostEndPoint)\(branch.urls.apiDrinks)") { (menus) in
                            DispatchQueue.main.async {
                                self.restaurantTabViewController.drinksController.menus = menus
                                if menus.count > 0 {
                                    for menu in menus {
                                        self.drinksViewHeight += self.restaurantmenuCellHeight(menu: menu)
                                    }
                                    self.drinksViewHeight += 60
                                    self.currentHeight = self.drinksViewHeight
                                } else { self.currentHeight = 400 }
                            }
                        }
                    }
                case 3:
                    self.canGoToZero = true
                    self.collectionView.contentOffset.y = 0
                    if self.dishesViewHeight > 0 { self.currentHeight = self.dishesViewHeight }
                    else {
                        APIDataProvider.instance.getRestaurantMenus(url: "\(URLs.hostEndPoint)\(branch.urls.apiDishes)") { (menus) in
                            DispatchQueue.main.async {
                                self.restaurantTabViewController.dishesController.menus = menus
                                if menus.count > 0 {
                                    for menu in menus {
                                        self.dishesViewHeight += self.restaurantmenuCellHeight(menu: menu)
                                    }
                                    self.dishesViewHeight += 60
                                    self.currentHeight = self.dishesViewHeight
                                } else { self.currentHeight = 400 }
                            }
                        }
                    }
                default:
                    break
                }
            }
        }
        
        collectionView.register(RestaurantHeaderViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.barTintColor = Colors.colorPrimaryDark
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = Colors.colorPrimaryDark
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barStyle = .black
        
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "icon_unwind_25_white")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "icon_unwind_25_white")
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.title = ""
        
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
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        let restaurantView = restaurantTabView
        restaurantView.translatesAutoresizingMaskIntoConstraints = false
        
        cell.addSubview(restaurantView)
        cell.addConstraintsWithFormat(format: "H:|[v0]|", views: restaurantView)
        cell.addConstraintsWithFormat(format: "V:|[v0]|", views: restaurantView)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: currentHeight)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! RestaurantHeaderViewCell
        header.branch = self.restaurant
        header.controller = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 335)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) { }
    
    private func menuPromotionViewCellHeight(promotion: MenuPromotion) -> CGFloat {
        
        var promotionOccasionHeight: CGFloat = 20
        var promotionPeriodHeight: CGFloat = 15
        var promotionReductionHeight: CGFloat = 0
        var promotionSupplementHeight: CGFloat = 0
        let device = UIDevice.type
        
        var promotionOccationTextSize: CGFloat = 15
        let promotionTextSize: CGFloat = 13
        var promotionPosterConstant: CGFloat = 80
        
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
            let reductionText = "Order a menu and get \(promotion.reduction.amount) \((promotion.reduction.reductionType)!) reduction"
            let promotionReductionRect = NSString(string: reductionText).boundingRect(with: CGSize(width: frameWidth - 18, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: promotionTextSize)!], context: nil)
            promotionReductionHeight = promotionReductionRect.height
        }
        
        if promotion.supplement.hasSupplement {
            var supplementText: String!
            if !promotion.supplement.isSame {
                supplementText = "Order \(promotion.supplement.minQuantity) of a menu and get \(promotion.supplement.quantity) free \((promotion.supplement.supplement?.menu?.name)!)"
            } else {
                supplementText = "Order \(promotion.supplement.minQuantity) of a menu and get \(promotion.supplement.quantity) more for free"
            }
            let promotionSupplementRect = NSString(string: supplementText).boundingRect(with: CGSize(width: frameWidth - 18, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: promotionTextSize)!], context: nil)
            promotionSupplementHeight = promotionSupplementRect.height
        }
        
        var promotionTypeViewHeight = 0
        
        if (promotion.promotionItem.category != nil || promotion.promotionItem.menu != nil) && (promotion.promotionItem.type.id == "04" || promotion.promotionItem.type.id == "05") {
            promotionTypeViewHeight = 90
        } else {
            promotionTypeViewHeight = 58
        }
        
        let staticValue = CGFloat(40 + 12 + 36) + promotionSupplementHeight + CGFloat(promotionTypeViewHeight)
        
        return staticValue + promotionOccasionHeight + promotionPeriodHeight + promotionReductionHeight
    }
    
    private func restaurantmenuCellHeight(menu: RestaurantMenu) -> CGFloat {
        
        let device = UIDevice.type
        
        var menuNameTextSize: CGFloat = 15
        var menuDescriptionTextSize: CGFloat = 13
        var menuImageConstant: CGFloat = 80
        
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
    
    @objc private func openMenu(_ sender: Any?) {
        
    }
}
