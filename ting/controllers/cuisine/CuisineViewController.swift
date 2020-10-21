//
//  CuisineTabViewController.swift
//  ting
//
//  Created by Christian Scott on 16/08/2020.
//  Copyright © 2020 Ir Christian Scott. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class CuisineViewController: ButtonBarPagerTabStripViewController {
    
    var cuisine: RestaurantCategory? {
        didSet {}
    }

    let storyboardApp = UIStoryboard(name: "Home", bundle: nil)
    lazy var cuisineRestaurantsController: CuisineRestaurantsViewController = {
        return self.storyboardApp.instantiateViewController(withIdentifier: "CuisineRestaurants") as! CuisineRestaurantsViewController
    }()
    lazy var cuisineMenusController: CuisineMenusViewController = {
        return self.storyboardApp.instantiateViewController(withIdentifier: "CuisineMenus") as! CuisineMenusViewController
    }()
    
    override func viewDidLoad() {
        
        self.settings.style.selectedBarHeight = 2
        self.settings.style.selectedBarBackgroundColor = Colors.colorPrimary
        self.settings.style.buttonBarBackgroundColor = Colors.colorWhite
        self.settings.style.buttonBarItemBackgroundColor = Colors.colorWhite
        self.settings.style.buttonBarItemFont = UIFont(name: "Poppins-Medium", size: 15)!
        self.settings.style.buttonBarItemTitleColor = Colors.colorPrimary
        self.settings.style.buttonBarMinimumInteritemSpacing = 0
        self.settings.style.buttonBarMinimumLineSpacing = 0
        
        changeCurrentIndex = {(oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, animated: Bool) -> Void in }
        cuisineRestaurantsController.cuisine = self.cuisine
        cuisineMenusController.cuisine = self.cuisine
        
        super.viewDidLoad()
        
        self.setupNavigationBar()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(openSearch(_:)))
        
        self.buttonBarView.layer.shadowColor = Colors.colorLightGray.cgColor
        self.buttonBarView.layer.shadowOpacity = 0.3
        self.buttonBarView.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.buttonBarView.layer.shadowRadius = 3
        self.buttonBarView.layer.masksToBounds = false
        
        if UIDevice.largeNavbarDevices.contains(UIDevice.type) {
            self.containerView.frame = self.containerView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0))
        } else {
            self.containerView.frame = self.containerView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0))
        }
    }
    
    override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return [cuisineRestaurantsController, cuisineMenusController]
    }
    
    override func moveToViewController(at index: Int, animated: Bool = true) {
        super.moveToViewController(at: index)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupNavigationBar()
    }
    
    private func setupNavigationBar(){
        self.navigationController?.navigationBar.barTintColor = Colors.colorPrimaryDark
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = Colors.colorPrimaryDark
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barStyle = .black
        
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "icon_unwind_25_white")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "icon_unwind_25_white")
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.title = cuisine?.name
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
    
    @objc private func openSearch(_ sender: Any?) {
        
    }
}
