//
//  RestaurantTabView.swift
//  ting
//
//  Created by Christian Scott on 12/18/19.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class RestaurantTabViewController: ButtonBarPagerTabStripViewController {
    
    let storyboardApp = UIStoryboard(name: "Home", bundle: nil)
    lazy var promosController: RestaurantPromosViewController = {
        return self.storyboardApp.instantiateViewController(withIdentifier: "RestaurantPromos") as! RestaurantPromosViewController
    }()
    lazy var foodsController: RestaurantFoodsViewController = {
        return self.storyboardApp.instantiateViewController(withIdentifier: "RestaurantFoods") as! RestaurantFoodsViewController
    }()
    lazy var drinksController: RestaurantDrinksViewController = {
        return self.storyboardApp.instantiateViewController(withIdentifier: "RestaurantDrinks") as! RestaurantDrinksViewController
    }()
    lazy var dishesController: RestaurantDishesViewController = {
        return self.storyboardApp.instantiateViewController(withIdentifier: "RestaurantDishes") as! RestaurantDishesViewController
    }()
    
    var branch: Branch? {
        didSet {}
    }
    
    var currentHeight: CGFloat = 300 {
        didSet {  }
    }
    
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
        
        super.viewDidLoad()
        
        self.buttonBarView.layer.shadowColor = Colors.colorLightGray.cgColor
        self.buttonBarView.layer.shadowOpacity = 0.3
        self.buttonBarView.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.buttonBarView.layer.shadowRadius = 3
        self.buttonBarView.layer.masksToBounds = false
    }
    
    override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return [promosController, foodsController, drinksController, dishesController]
    }
    
    override func moveToViewController(at index: Int, animated: Bool = true) {
        super.moveToViewController(at: index)
    }
}
