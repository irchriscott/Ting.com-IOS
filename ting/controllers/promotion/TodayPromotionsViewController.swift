//
//  TodayPromotionsViewController.swift
//  ting
//
//  Created by Christian Scott on 19/08/2020.
//  Copyright © 2020 Ir Christian Scott. All rights reserved.
//

import UIKit
import ShimmerSwift

class TodayPromotionsViewController: UITableViewController {
    
    let cellId = "cellId"
    let shimmerCellId = "shimmerCellId"
    
    private var promotions: [MenuPromotion] = []
    private var footerHeight: CGFloat = 0
    
    private var country: String!
    private var town: String!
    
    var refresherLoadingView = UIRefreshControl()
    private var session = UserAuthentication().get()!
       
    private var loadedCells: [Int] = []
    
    private var pageIndex = 1
    private var shouldLoad: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        
        tableView.register(RestaurantPromotionViewCell.self, forCellReuseIdentifier: self.cellId)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.shimmerCellId)
        tableView.separatorStyle = .none
        
        tableView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 14, right: 0)
        
        country = session.country
        town = session.town
        
        refresherLoadingView.addTarget(self, action: #selector(refreshPromotions), for: UIControl.Event.valueChanged)
        tableView.addSubview(refresherLoadingView)
        
        self.getPromotions(index: pageIndex)
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
        self.navigationItem.title = "Today's Promotions"
        
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
    
    private func getPromotions(index: Int) {
        APIDataProvider.instance.getTodayPromotionsAll(country: country, town: town, page: index) { (promos) in
            DispatchQueue.main.async {
                if !promos.isEmpty {
                    
                    self.promotions.append(contentsOf: promos)
                    self.footerHeight = 0
                    self.tableView.reloadData()
                    self.refresherLoadingView.endRefreshing()
                    
                } else { self.shouldLoad = false }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupNavigationBar()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.promotions.isEmpty ? 3 : self.promotions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !self.promotions.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! RestaurantPromotionViewCell
            cell.selectionStyle = .none
            if !self.loadedCells.contains(indexPath.row) {
                cell.promotion = self.promotions[indexPath.row]
                self.loadedCells.append(indexPath.row)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.shimmerCellId, for: indexPath)
            cell.selectionStyle = .none
            let view: RowShimmerView = {
                let view = RowShimmerView()
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            
            cell.addSubview(view)
            cell.addConstraintsWithFormat(format: "V:|[v0]|", views: view)
            cell.addConstraintsWithFormat(format: "H:|[v0]|", views: view)
            
            let shimmerView = ShimmeringView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 94))
            cell.addSubview(shimmerView)
            
            shimmerView.contentView = view
            shimmerView.shimmerAnimationOpacity = 0.4
            shimmerView.shimmerSpeed = 250
            shimmerView.isShimmering = true
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.promotions.isEmpty ? 106 : menuPromotionViewCellHeight(index: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let promotion = self.promotions[indexPath.row]
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let promotionController = storyboard.instantiateViewController(withIdentifier: "PromotionMenuView") as! PromotionMenuViewController
        promotionController.promotion = promotion
        promotionController.controller = self
        self.navigationController?.pushViewController(promotionController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.promotions.count - 1 {
            if self.shouldLoad {
                pageIndex += 1
                self.footerHeight = 36
                self.getPromotions(index: pageIndex)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footer: UIView = {
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.footerHeight)
            return view
        }()
        
        let indicatorView: UIActivityIndicatorView = {
            let view = UIActivityIndicatorView(style: .gray)
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        indicatorView.startAnimating()
        footer.addSubview(indicatorView)
        footer.addConstraintsWithFormat(format: "V:|[v0]|", views: indicatorView)
        footer.addConstraintsWithFormat(format: "H:|[v0]|", views: indicatorView)
        footer.addConstraint(NSLayoutConstraint(item: indicatorView, attribute: .centerY, relatedBy: .equal, toItem: footer, attribute: .centerY, multiplier: 1, constant: 0))
        
        return footer
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return self.footerHeight
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
        
        let promotion = self.promotions[index]
        
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
        
        var promotionTypeViewHeight = 0
        
        if (promotion.promotionItem.category != nil || promotion.promotionItem.menu != nil) && (promotion.promotionItem.type.id == "04" || promotion.promotionItem.type.id == "05") {
            promotionTypeViewHeight = 90
        } else {
            promotionTypeViewHeight = 58
        }
        
        var valueToAdd: CGFloat = 0
        
        if promotion.reduction.hasReduction && promotion.supplement.hasSupplement {
            valueToAdd = 4
        }
        
        let staticValue = CGFloat(40 + 12 + 36) + promotionSupplementHeight + CGFloat(promotionTypeViewHeight)
        
        return staticValue + promotionOccasionHeight + promotionPeriodHeight + promotionReductionHeight + valueToAdd
    }
    
    @objc private func refreshPromotions() {
        pageIndex = 1
        self.loadedCells = []
        self.promotions = []
        self.footerHeight = 0
        self.getPromotions(index: pageIndex)
    }
}
