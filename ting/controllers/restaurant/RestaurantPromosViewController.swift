//
//  RestaurantPromosViewController.swift
//  ting
//
//  Created by Christian Scott on 12/18/19.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class RestaurantPromosViewController: UITableViewController, IndicatorInfoProvider {
    
    let cellId = "cellId"
    let defaultCellId = "defaultCellId"
    var headerHeight: CGFloat = 200
    
    var branch: Branch? {
        didSet { if let _ = self.branch {} }
    }
    
    var controller: UIViewController? {
        didSet {}
    }
    
    var promotions: [MenuPromotion]? {
        didSet {
            self.headerHeight = 0
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        
        tableView.register(RestaurantPromotionViewCell.self, forCellReuseIdentifier: self.cellId)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.defaultCellId)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView: UIView = {
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: headerHeight)
            view.backgroundColor = .white
            return view
        }()
        
        let indicatorView: UIActivityIndicatorView = {
            let view = UIActivityIndicatorView(style: .gray)
            return view
        }()
        
        indicatorView.startAnimating()
        indicatorView.center = headerView.center
        headerView.addSubview(indicatorView)
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(headerHeight)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if headerHeight > 0 {
            return self.promotions?.count ?? 0
        } else {
            return self.promotions?.count ?? 0 > 0 ? self.promotions?.count ?? 0 : 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.promotions?.count ?? 0 > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! RestaurantPromotionViewCell
            cell.promotion = self.promotions![indexPath.item]
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.defaultCellId, for: indexPath)
            
            let cellView: UIView = {
                let view = UIView()
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            
            let emptyImageView: UIImageView = {
                let view = UIImageView()
                view.translatesAutoresizingMaskIntoConstraints = false
                view.image = UIImage(named: "icon_star_filled_100_gray")!
                view.contentMode = .scaleAspectFill
                view.clipsToBounds = true
                view.alpha = 0.2
                return view
            }()
            
            let emptyTextView: UILabel = {
                let view = UILabel()
                view.translatesAutoresizingMaskIntoConstraints = false
                view.text = "No Promotion To Show"
                view.font = UIFont(name: "Poppins-SemiBold", size: 23)
                view.textColor = Colors.colorVeryLightGray
                view.textAlignment = .center
                return view
            }()
            
            let emptyTextRect = NSString(string: "No Promotion To Show").boundingRect(with: CGSize(width: cell.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: 23)!], context: nil)
            
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
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.promotions?.count ?? 0 > 0 {
            return self.menuPromotionViewCellHeight(index: indexPath.item)
        } else {
            let emptyTextRect = NSString(string: "No Promotion To Show").boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: 23)!], context: nil)
            return 30 + 90 + 12 + emptyTextRect.height + 30
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let promotion = self.promotions![indexPath.item]
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let promotionController = storyboard.instantiateViewController(withIdentifier: "PromotionMenuView") as! PromotionMenuViewController
        promotionController.promotion = promotion
        promotionController.controller = self.controller
        self.controller?.navigationController?.pushViewController(promotionController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "PROMOS")
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
        
        var promotionTypeViewHeight = 0
        
        if (promotion.promotionItem.category != nil || promotion.promotionItem.menu != nil) && (promotion.promotionItem.type.id == "04" || promotion.promotionItem.type.id == "05") {
            promotionTypeViewHeight = 90
        } else {
            promotionTypeViewHeight = 58
        }
        
        let staticValue = CGFloat(40 + 12 + 36) + promotionSupplementHeight + CGFloat(promotionTypeViewHeight)
        
        return staticValue + promotionOccasionHeight + promotionPeriodHeight + promotionReductionHeight
    }
}
