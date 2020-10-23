//
//  CuisineTabViewController.swift
//  ting
//
//  Created by Christian Scott on 16/08/2020.
//  Copyright © 2020 Ir Christian Scott. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import ViewPager_Swift

class CuisineViewController: ButtonBarPagerTabStripViewController, ViewPagerDelegate, ViewPagerDataSource {
    
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
    
    private var cuisineViewPager: ViewPager!
    
    private var viewPagerPages: [UIViewController]!
    
    override func viewDidLoad() {
        
        self.settings.style.selectedBarHeight = 2
        self.settings.style.selectedBarBackgroundColor = Colors.colorPrimary
        self.settings.style.buttonBarBackgroundColor = Colors.colorWhite
        self.settings.style.buttonBarItemBackgroundColor = Colors.colorWhite
        self.settings.style.buttonBarItemFont = UIFont(name: "Poppins-Medium", size: 15)!
        self.settings.style.buttonBarItemTitleColor = Colors.colorPrimary
        self.settings.style.buttonBarMinimumInteritemSpacing = 0
        self.settings.style.buttonBarMinimumLineSpacing = 0
        //self.settings.style.buttonBarHeight = 60
        
        changeCurrentIndex = {(oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, animated: Bool) -> Void in }
        cuisineRestaurantsController.cuisine = self.cuisine
        cuisineMenusController.cuisine = self.cuisine
        
        viewPagerPages = [cuisineRestaurantsController, cuisineMenusController]
        
        super.viewDidLoad()
        
        self.setupNavigationBar()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(openSearch(_:)))
        
        self.buttonBarView.layer.shadowColor = Colors.colorLightGray.cgColor
        self.buttonBarView.layer.shadowOpacity = 0.3
        self.buttonBarView.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.buttonBarView.layer.shadowRadius = 3
        self.buttonBarView.layer.masksToBounds = false
        
        let options = ViewPagerOptions()
        options.isTabBarShadowAvailable = true
        options.shadowColor = Colors.colorVeryLightGray
        options.tabIndicatorViewBackgroundColor = Colors.colorPrimary
        options.tabType = .basic
        options.distribution = .segmented
        options.tabIndicatorViewHeight = 2.0
        options.tabViewBackgroundDefaultColor = Colors.colorWhite
        options.tabViewTextDefaultColor = Colors.colorPrimary
        options.tabViewTextFont = UIFont(name: "Poppins-Medium", size: 15)!
        options.tabViewTextHighlightColor = Colors.colorPrimary
        options.tabViewHeight = 60
        options.tabViewBackgroundHighlightColor = Colors.colorWhite
        
        //cuisineViewPager = ViewPager(viewController: self)
        //cuisineViewPager.setDelegate(delegate: self)
        //cuisineViewPager.setDataSource(dataSource: self)
        //cuisineViewPager.setOptions(options: options)
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
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.backgroundColor = Colors.colorPrimaryDark
        self.navigationController?.navigationBar.isTranslucent = false
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
    
    func numberOfPages() -> Int {
        return 2
    }
    
    func viewControllerAtPosition(position: Int) -> UIViewController {
        return viewPagerPages[position]
    }
    
    func tabsForPages() -> [ViewPagerTab] {
        return [
                ViewPagerTab(title: "RESTAURANTS", image: nil),
                ViewPagerTab(title: "MENUS", image: nil)
        ]
    }
    
    func startViewPagerAtIndex() -> Int {
        return 0
    }
    
    func willMoveToControllerAtIndex(index: Int) {
        
    }
    
    func didMoveToControllerAtIndex(index: Int) {
        
    }
    
    @objc private func openSearch(_ sender: Any?) {
        
    }
}
