//
//  RestaurantTabView.swift
//  ting
//
//  Created by Christian Scott on 12/18/19.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class RestaurantTabViewController: ButtonBarPagerTabStripViewController  {
    
    override func viewDidLoad() {
        self.settings.style.selectedBarHeight = 2
        self.settings.style.selectedBarBackgroundColor = Colors.colorPrimary
        self.settings.style.buttonBarBackgroundColor = Colors.colorWhite
        self.settings.style.buttonBarItemBackgroundColor = Colors.colorWhite
        self.settings.style.buttonBarItemFont = UIFont(name: "Poppins-Medium", size: 15)!
        self.settings.style.buttonBarItemTitleColor = Colors.colorPrimary
        self.settings.style.buttonBarMinimumInteritemSpacing = 0
        self.settings.style.buttonBarMinimumLineSpacing = 0
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }

            oldCell?.label.textColor = Colors.colorPrimary
            newCell?.label.textColor = Colors.colorPrimary

            if animated {
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    newCell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    oldCell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                })
            }
            else {
                newCell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                oldCell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        }
        
        super.viewDidLoad()
    }
    
    override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let promosController = storyboard.instantiateViewController(withIdentifier: "RestaurantPromos") as! RestaurantPromosViewController
        let foodsController = storyboard.instantiateViewController(withIdentifier: "RestaurantFoods") as! RestaurantFoodsViewController
        let drinksController = storyboard.instantiateViewController(withIdentifier: "RestaurantDrinks") as! RestaurantDrinksViewController
        let dishesController = storyboard.instantiateViewController(withIdentifier: "RestaurantDishes") as! RestaurantDishesViewController
        
        return [promosController, foodsController, drinksController, dishesController]
    }
    
}
