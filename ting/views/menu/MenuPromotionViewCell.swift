//
//  MenuPromotionViewCell.swift
//  ting
//
//  Created by Christian Scott on 11/12/19.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit

class MenuPromotionViewCell: UITableViewCell {
    
    let numberFormatter = NumberFormatter()
    
    var promotionOccasionHeight: CGFloat = 20
    var promotionPeriodHeight: CGFloat = 15
    var promotionReductionHeight: CGFloat = 0
    var promotionSupplementHeight: CGFloat = 0
    let device = UIDevice.type
    
    var promotionOccationTextSize: CGFloat = 15
    let promotionTextSize: CGFloat = 13
    var promotionPosterConstant: CGFloat = 80
    
    let viewCell: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.layer.borderColor = Colors.colorVeryLightGray.cgColor
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    let promotionPosterView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        view.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        view.image = UIImage(named: "default_restaurant")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let promotionAboutView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let promotionOccasionView: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Poppins-SemiBold", size: 15)
        view.textColor = Colors.colorGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Occasion"
        view.numberOfLines = 2
        return view
    }()
    
    let promotionTypeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let promotionOnView: IconTextView = {
        let view = IconTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.icon = UIImage(named: "icon_star_filled_25_gray")!
        view.text = "Promotion On"
        return view
    }()
    
    let promotionCategoryView: ImageTextView = {
        let view = ImageTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Promotion On"
        return view
    }()
    
    let promotionPeriodView: InlineIconTextView = {
        let view = InlineIconTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.icon = UIImage(named: "icon_promo_calendar_gray")!
        view.size = .small
        view.text = "From date to date"
        return view
    }()
    
    let promotionReductionView: InlineIconTextView = {
        let view = InlineIconTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.icon = UIImage(named: "icon_promo_minus_gray")!
        view.size = .small
        view.text = "Reduction"
        return view
    }()
    
    let promotionSupplementView: InlineIconTextView = {
        let view = InlineIconTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.icon = UIImage(named: "icon_promo_plus_gray")!
        view.size = .small
        view.text = "Supplement"
        return view
    }()
    
    let promotionDataView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let promotionInterestsView: IconTextView = {
        let view = IconTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "5"
        view.icon = UIImage(named: "icon_star_filled_25_gray")!
        return view
    }()
    
    let promotionAvailabilityView: IconTextView = {
        let view = IconTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.icon = UIImage(named: "icon_check_white_25")!
        view.text = "Is On Today"
        view.textColor = Colors.colorWhite
        view.background = Colors.colorStatusTimeGreen
        return view
    }()
    
    var promotion: MenuPromotion? {
        didSet {
            numberFormatter.numberStyle = .decimal
            if let promotion = self.promotion {
                promotionPosterView.kf.setImage(
                    with: URL(string: "\(URLs.hostEndPoint)\(promotion.posterImage)")!,
                    placeholder: UIImage(named: "default_meal"),
                    options: [
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(1)),
                        .cacheOriginalImage
                    ]
                )
                promotionOccasionView.text = promotion.occasionEvent
                promotionOnView.text = promotion.promotionItem.type.name
                promotionPeriodView.text = promotion.period
                
                if UIDevice.smallDevices.contains(device) {
                    promotionPosterConstant = 55
                    promotionOccationTextSize = 14
                } else if UIDevice.mediumDevices.contains(device) {
                    promotionPosterConstant = 70
                    promotionOccationTextSize = 15
                }
                
                let frameWidth = frame.width - (60 + promotionPosterConstant)
                
                let promotionOccationRect = NSString(string: promotion.occasionEvent).boundingRect(with: CGSize(width: frameWidth, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: promotionOccationTextSize)!], context: nil)
                
                let promotionPeriodRect = NSString(string: promotion.period).boundingRect(with: CGSize(width: frameWidth - 18, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: promotionTextSize)!], context: nil)
                
                promotionOccasionHeight = promotionOccationRect.height
                promotionPeriodHeight = promotionPeriodRect.height
                
                if promotion.reduction.hasReduction {
                    let reductionText = "Order this menu and get \(promotion.reduction.amount) \((promotion.reduction.reductionType)!) reduction"
                    promotionReductionView.text = reductionText
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
                    promotionSupplementView.text = supplementText
                    let promotionSupplementRect = NSString(string: supplementText).boundingRect(with: CGSize(width: frameWidth - 18, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: promotionTextSize)!], context: nil)
                    promotionSupplementHeight = promotionSupplementRect.height
                }
                
                promotionInterestsView.text = numberFormatter.string(from: NSNumber(value: promotion.interests.count))!
                
                if promotion.isOn && promotion.isOnToday {
                    promotionAvailabilityView.background = Colors.colorStatusTimeGreen
                    promotionAvailabilityView.text = "Is On Today"
                    promotionAvailabilityView.icon = UIImage(named: "icon_check_white_25")!
                } else {
                    promotionAvailabilityView.background = Colors.colorStatusTimeRed
                    promotionAvailabilityView.text = "Is Off Today"
                    promotionAvailabilityView.icon = UIImage(named: "icon_close_25_white")!
                }
            }
            self.setup()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    private func setup(){
        addSubview(viewCell)
        
        addConstraintsWithFormat(format: "V:|[v0]-12-|", views: viewCell)
        addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: viewCell)
        
        promotionDataView.addSubview(promotionInterestsView)
        promotionDataView.addSubview(promotionAvailabilityView)
        
        promotionDataView.addConstraintsWithFormat(format: "H:|[v0]-8-[v1]", views: promotionInterestsView, promotionAvailabilityView)
        promotionDataView.addConstraintsWithFormat(format: "V:|[v0(26)]|", views: promotionInterestsView)
        promotionDataView.addConstraintsWithFormat(format: "V:|[v0(26)]|", views: promotionAvailabilityView)
        
        promotionAboutView.addSubview(promotionOccasionView)
        promotionAboutView.addSubview(promotionPeriodView)
        
        if (promotion?.reduction.hasReduction)! {
            promotionAboutView.addSubview(promotionReductionView)
            promotionAboutView.addConstraintsWithFormat(format: "H:|[v0]|", views: promotionReductionView)
        }
        
        if (promotion?.supplement.hasSupplement)! {
            promotionAboutView.addSubview(promotionSupplementView)
            promotionAboutView.addConstraintsWithFormat(format: "H:|[v0]|", views: promotionSupplementView)
        }
        
        promotionAboutView.addSubview(promotionDataView)
        
        promotionOccasionView.font = UIFont(name: "Poppins-SemiBold", size: promotionOccationTextSize)
        
        promotionAboutView.addConstraintsWithFormat(format: "H:|[v0]|", views: promotionOccasionView)
        promotionAboutView.addConstraintsWithFormat(format: "H:|[v0]|", views: promotionPeriodView)
        promotionAboutView.addConstraintsWithFormat(format: "H:|[v0]|", views: promotionDataView)
        
        if (promotion?.reduction.hasReduction)! && (promotion?.supplement.hasSupplement)! {
            promotionAboutView.addConstraintsWithFormat(format: "V:|[v0(\(promotionOccasionHeight))]-4-[v1(\(promotionPeriodHeight))]-4-[v2(\(promotionReductionHeight))]-4-[v3(\(promotionSupplementHeight))]-8-[v4(26)]", views: promotionOccasionView, promotionPeriodView, promotionReductionView, promotionSupplementView, promotionDataView)
        } else if (promotion?.reduction.hasReduction)! && !(promotion?.supplement.hasSupplement)! {
            promotionAboutView.addConstraintsWithFormat(format: "V:|[v0(\(promotionOccasionHeight))]-4-[v1(\(promotionPeriodHeight))]-4-[v2(\(promotionReductionHeight))]-8-[v3(26)]", views: promotionOccasionView, promotionPeriodView, promotionReductionView, promotionDataView)
        } else if !(promotion?.reduction.hasReduction)! && (promotion?.supplement.hasSupplement)! {
             promotionAboutView.addConstraintsWithFormat(format: "V:|[v0(\(promotionOccasionHeight))]-4-[v1(\(promotionPeriodHeight))]-4-[v2(\(promotionSupplementHeight))]-8-[v3(26)]", views: promotionOccasionView, promotionPeriodView, promotionSupplementView, promotionDataView)
        } else {
             promotionAboutView.addConstraintsWithFormat(format: "V:|[v0(\(promotionOccasionHeight))]-4-[v1(\(promotionPeriodHeight))]-8-[v2(26)]", views: promotionOccasionView, promotionPeriodView, promotionDataView)
        }
        
        viewCell.addSubview(promotionPosterView)
        viewCell.addSubview(promotionAboutView)
        
        viewCell.addConstraintsWithFormat(format: "H:|-12-[v0(\(promotionPosterConstant))]-12-[v1]-12-|", views: promotionPosterView, promotionAboutView)
        viewCell.addConstraintsWithFormat(format: "V:|-12-[v0(55)]", views: promotionPosterView)
        viewCell.addConstraintsWithFormat(format: "V:|-12-[v0(\(40 + 26 + promotionOccasionHeight + promotionPeriodHeight + promotionReductionHeight + promotionSupplementHeight))]-12-|", views: promotionAboutView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
