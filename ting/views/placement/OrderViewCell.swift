//
//  OrderViewCell.swift
//  ting
//
//  Created by Christian Scott on 06/10/2020.
//  Copyright © 2020 Ir Christian Scott. All rights reserved.
//

import UIKit

class OrderViewCell: UICollectionViewCell {
    
    let numberFormatter = NumberFormatter()
    
    var menuNameHeight: CGFloat = 20
    let device = UIDevice.type
    
    var menuNameTextSize: CGFloat = 15
    var menuImageConstant: CGFloat = 80
    
    var promotionReductionHeight: CGFloat = 0
    var promotionSupplementHeight: CGFloat = 0
    
    var frameWidth: CGFloat = (UIApplication.shared.keyWindow?.frame.width)! - 140
    
    let viewCell: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.layer.borderColor = Colors.colorVeryLightGray.cgColor
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    let menuImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        view.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        view.image = UIImage(named: "default_restaurant")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let menuAboutView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let menuNameView: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Poppins-SemiBold", size: 15)
        view.textColor = Colors.colorGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "French Fries"
        view.numberOfLines = 2
        return view
    }()
    
    let menuRating: CosmosView = {
        let view = CosmosView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.rating = 3
        view.settings.updateOnTouch = false
        view.settings.fillMode = .full
        view.settings.starSize = 17
        view.starMargin = 2
        view.totalStars = 5
        view.settings.filledColor = Colors.colorYellowRate
        view.settings.filledBorderColor = Colors.colorYellowRate
        view.settings.emptyColor = Colors.colorVeryLightGray
        view.settings.emptyBorderColor = Colors.colorVeryLightGray
        return view
    }()
    
    let orderQuantityTextView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-Regular", size: 12)
        view.textColor = Colors.colorGray
        return view
    }()
    
    let orderTotalPriceTextView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-SemiBold", size: 27)
        view.textColor = Colors.colorGray
        return view
    }()
    
    let orderSinglePriceTextView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-Regular", size: 14)
        view.textColor = Colors.colorGray
        return view
    }()
    
    let separatorOne: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.colorVeryLightGray
        return view
    }()
    
    let restaurantMenuPromotionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let promotionTitleTextView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-Regular", size: 17)
        view.text = "Promotion".uppercased()
        view.textColor = Colors.colorGray
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
    
    let separatorTwo: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.colorVeryLightGray
        return view
    }()
    
    let orderDataView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let orderPromotionView: IconTextView = {
        let view = IconTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "876"
        view.icon = UIImage(named: "icon_star_outline_25_gray")!
        return view
    }()
    
    let orderStatusView: IconTextView = {
        let view = IconTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.icon = UIImage(named: "icon_check_white_25")!
        view.text = "Pending"
        view.textColor = Colors.colorWhite
        view.background = Colors.colorStatusTimeGreen
        return view
    }()
    
    let orderPendingButtons: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .top
        view.distribution = .fillEqually
        view.spacing = 8.0
        return view
    }()
    
    let notifyOrderButton: UIButton = {
        let view = UIButton()
        view.titleLabel?.text = "Notify Order".uppercased()
        view.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 16)!
        view.titleLabel?.textColor = Colors.colorWhite
        view.titleLabel?.textAlignment = .center
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()
    
    let cancelOrderButton: UIButton = {
        let view = UIButton()
        view.titleLabel?.text = "Cancel".uppercased()
        view.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 16)!
        view.titleLabel?.textColor = Colors.colorWhite
        view.titleLabel?.textAlignment = .center
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()
    
    let reorderButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleLabel?.text = "Re-Order".uppercased()
        view.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 16)!
        view.titleLabel?.textColor = Colors.colorWhite
        view.titleLabel?.textAlignment = .center
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()
    
    var order: Order? {
        didSet {
            numberFormatter.numberStyle = .decimal
            if let order = self.order {
                let images = order.menu.menu?.images?.images
                let imageIndex = Int.random(in: 0...images!.count - 1)
                let image = images![imageIndex]

                menuImageView.kf.setImage(
                    with: URL(string: "\(URLs.hostEndPoint)\(image.image)")!,
                    placeholder: UIImage(named: "default_restaurant"),
                    options: [
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(1)),
                        .cacheOriginalImage
                    ]
                )
                
                menuNameView.text = order.menu.menu?.name
                menuRating.rating = (order.menu.menu?.reviews?.average)!
                
                orderQuantityTextView.text = "\(order.quantity) Pieces / Packs / Bottles"
                orderTotalPriceTextView.text = "\(order.currency) \(numberFormatter.string(from: NSNumber(value: (Double(order.quantity) * order.price)))!)"
                orderSinglePriceTextView.text = "\(order.currency) \(numberFormatter.string(from: NSNumber(value: order.price))!)"
                
                if !order.isDeclined && !order.isAccepted {
                    orderStatusView.text = "Pending"
                    orderStatusView.background = Colors.colorStatusTimeOrange
                    orderStatusView.icon = UIImage(named: "icon_clock_25_white")!
                    
                } else {
                    if order.isAccepted {
                        orderStatusView.text = "Accepted"
                        orderStatusView.background = Colors.colorStatusTimeGreen
                        orderStatusView.icon = UIImage(named: "icon_check_white_25")!
                    }
                    if order.isDeclined {
                        orderStatusView.text = "Declined"
                        orderStatusView.background = Colors.colorStatusTimeRed
                        orderStatusView.icon = UIImage(named: "icon_close_25_white")!
                    }
                }
                
                if UIDevice.smallDevices.contains(device) {
                    menuImageConstant = 55
                    menuNameTextSize = 14
                } else if UIDevice.mediumDevices.contains(device) {
                    menuImageConstant = 70
                    menuNameTextSize = 15
                }
                
                frameWidth = (UIApplication.shared.keyWindow?.frame.width)! - (60 + menuImageConstant)
                
                let menuNameRect = NSString(string: (order.menu.menu?.name)!).boundingRect(with: CGSize(width: frameWidth, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: menuNameTextSize)!], context: nil)
                
                menuNameHeight = menuNameRect.height
                
                if order.hasPromotion {
                    orderPromotionView.text = "YES"
                    if let promotion = order.promotion {
                        if let supplement = promotion.supplement {
                            promotionSupplementView.text = supplement
                            let promotionSupplementRect = NSString(string: supplement).boundingRect(with: CGSize(width: frameWidth, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 13)!], context: nil)
                            promotionSupplementHeight = promotionSupplementRect.height
                        }
                        
                        if let reduction = promotion.reduction {
                            promotionReductionView.text = reduction
                            let promotionReductionRect = NSString(string: reduction).boundingRect(with: CGSize(width: frameWidth, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 13)!], context: nil)
                            promotionReductionHeight = promotionReductionRect.height
                        }
                    }
                } else { orderPromotionView.text = "NO" }
            }
            self.setup()
        }
    }
    
    var onReorder: (() -> ())!
    var onCancel: (() -> ())!
    var onNotify: (() -> ())!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        reorderButton.addTarget(self, action: #selector(reOrder(sender:)), for: .touchUpInside)
        notifyOrderButton.addTarget(self, action: #selector(notifyOrder(sender:)), for: .touchUpInside)
        cancelOrderButton.addTarget(self, action: #selector(cancelOrder(sender:)), for: .touchUpInside)
    }
    
    private func setup() {
        notifyOrderButton.setTitle("Notify Order".uppercased(), for: .normal)
        notifyOrderButton.setTitleColor(Colors.colorWhite, for: .normal)
        notifyOrderButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 16)!
        
        cancelOrderButton.setTitle("Cancel".uppercased(), for: .normal)
        cancelOrderButton.setTitleColor(Colors.colorWhite, for: .normal)
        cancelOrderButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 16)!
        
        reorderButton.setTitle("Re-Order".uppercased(), for: .normal)
        reorderButton.setTitleColor(Colors.colorWhite, for: .normal)
        reorderButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 16)!
        
        notifyOrderButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        cancelOrderButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        notifyOrderButton.setLinearGradientBackgroundColorElse(colorOne: Colors.colorPrimary, colorTwo: Colors.colorPrimaryDark, frame: CGRect(x: 0, y: 0, width: bounds.width, height: 55))
        cancelOrderButton.setLinearGradientBackgroundColorElse(colorOne: Colors.colorGoogleRedTwo, colorTwo: Colors.colorGoogleRedOne, frame: CGRect(x: 0, y: 0, width: bounds.width, height: 55))
        reorderButton.setLinearGradientBackgroundColorElse(colorOne: Colors.colorPrimary, colorTwo: Colors.colorPrimaryDark, frame: CGRect(x: 0, y: 0, width: bounds.width, height: 55))
        
        addSubview(viewCell)
        
        addConstraintsWithFormat(format: "V:|-12-[v0]|", views: viewCell)
        addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: viewCell)
        
        orderDataView.addSubview(orderStatusView)
        orderDataView.addSubview(orderPromotionView)
        
        orderDataView.addConstraintsWithFormat(format: "V:|[v0(26)]|", views: orderStatusView)
        orderDataView.addConstraintsWithFormat(format: "V:|[v0(26)]|", views: orderPromotionView)
        
        orderDataView.addConstraintsWithFormat(format: "H:|[v0]-8-[v1]", views: orderStatusView, orderPromotionView)
        
        var promotionViewHeight: CGFloat = 0
        
        if let promotion = self.order?.promotion {
            if self.order?.hasPromotion ?? false {
                restaurantMenuPromotionView.addSubview(promotionTitleTextView)
                restaurantMenuPromotionView.addConstraintsWithFormat(format: "H:|[v0]|", views: promotionTitleTextView)
                if promotion.reduction != nil {
                    restaurantMenuPromotionView.addSubview(promotionReductionView)
                    restaurantMenuPromotionView.addConstraintsWithFormat(format: "H:|[v0]|", views: promotionReductionView)
                }
                if promotion.supplement != nil {
                    restaurantMenuPromotionView.addSubview(promotionSupplementView)
                    restaurantMenuPromotionView.addConstraintsWithFormat(format: "H:|[v0]|", views: promotionSupplementView)
                }
                
                if promotion.reduction != nil && promotion.supplement != nil {
                    restaurantMenuPromotionView.addConstraintsWithFormat(format: "V:|[v0(18)]-12-[v1(\(promotionReductionHeight))]-4-[v2(\(promotionSupplementHeight))]", views: promotionTitleTextView, promotionReductionView, promotionSupplementView)
                    promotionViewHeight += promotionReductionHeight + promotionSupplementHeight + 18 + 12 + 12
                } else {
                    if promotion.reduction != nil {
                        restaurantMenuPromotionView.addConstraintsWithFormat(format: "V:|[v0(18)]-12-[v1(\(promotionReductionHeight))]", views: promotionTitleTextView, promotionReductionView)
                        promotionViewHeight += promotionReductionHeight + 18 + 8 + 12
                    }
                    
                    if promotion.supplement != nil {
                        restaurantMenuPromotionView.addConstraintsWithFormat(format: "V:|[v0(18)]-12-[v1(\(promotionSupplementHeight))]", views: promotionTitleTextView, promotionSupplementView)
                        promotionViewHeight += promotionSupplementHeight + 18 + 8 + 12
                    }
                }
            }
        }
        
        orderPendingButtons.addArrangedSubview(notifyOrderButton)
        orderPendingButtons.addArrangedSubview(cancelOrderButton)
        
        menuAboutView.addSubview(menuNameView)
        menuAboutView.addSubview(menuRating)
        menuAboutView.addSubview(orderQuantityTextView)
        menuAboutView.addSubview(orderTotalPriceTextView)
        menuAboutView.addSubview(orderSinglePriceTextView)
        
        if self.order?.hasPromotion ?? false {
            menuAboutView.addSubview(separatorOne)
            menuAboutView.addSubview(restaurantMenuPromotionView)
            menuAboutView.addConstraintsWithFormat(format: "H:|[v0]|", views: separatorOne)
            menuAboutView.addConstraintsWithFormat(format: "H:|[v0(\(frameWidth))]|", views: restaurantMenuPromotionView)
        }
        
        menuAboutView.addSubview(separatorTwo)
        menuAboutView.addSubview(orderDataView)
        
        menuNameView.font = UIFont(name: "Poppins-SemiBold", size: menuNameTextSize)
        
        menuAboutView.addConstraintsWithFormat(format: "H:|[v0]|", views: menuNameView)
        menuAboutView.addConstraintsWithFormat(format: "H:|[v0]|", views: menuRating)
        menuAboutView.addConstraintsWithFormat(format: "H:|[v0]|", views: orderQuantityTextView)
        menuAboutView.addConstraintsWithFormat(format: "H:|[v0]|", views: orderTotalPriceTextView)
        menuAboutView.addConstraintsWithFormat(format: "H:|[v0]|", views: orderSinglePriceTextView)
        menuAboutView.addConstraintsWithFormat(format: "H:|[v0]|", views: separatorTwo)
        menuAboutView.addConstraintsWithFormat(format: "H:|[v0]|", views: orderDataView)
        
        if let order = self.order {
            if order.hasPromotion {
                if !order.isAccepted && !order.isDeclined {
                    menuAboutView.addConstraintsWithFormat(format: "V:|[v0(\(menuNameHeight))]-4-[v1]-4-[v2(16)]-[v3(30)]-[v4(16)]-4-[v5(0.5)]-8-[v6(\(promotionViewHeight))]-4-[v7(0.5)]-8-[v8(26)]|", views: menuNameView, menuRating, orderQuantityTextView, orderTotalPriceTextView, orderSinglePriceTextView, separatorOne, restaurantMenuPromotionView, separatorTwo, orderDataView)
                } else {
                    if order.isDeclined {
                        menuAboutView.addConstraintsWithFormat(format: "V:|[v0(\(menuNameHeight))]-4-[v1]-4-[v2(16)]-[v3(30)]-[v4(16)]-4-[v5(0.5)]-8-[v6(\(promotionViewHeight))]-4-[v7(0.5)]-8-[v8(26)]|", views: menuNameView, menuRating, orderQuantityTextView, orderTotalPriceTextView, orderSinglePriceTextView, separatorOne, restaurantMenuPromotionView, separatorTwo, orderDataView)
                    } else {
                        menuAboutView.addConstraintsWithFormat(format: "V:|[v0(\(menuNameHeight))]-4-[v1]-4-[v2(16)]-[v3(30)]-[v4(16)]-4-[v5(0.5)]-8-[v6(\(promotionViewHeight))]-4-[v7(0.5)]-8-[v8(26)]|", views: menuNameView, menuRating, orderQuantityTextView, orderTotalPriceTextView, orderSinglePriceTextView, separatorOne, restaurantMenuPromotionView, separatorTwo, orderDataView)
                    }
                }
                
            } else {
                if !order.isAccepted && !order.isDeclined {
                    menuAboutView.addConstraintsWithFormat(format: "V:|[v0(\(menuNameHeight))]-4-[v1]-4-[v2(16)]-[v3(30)]-[v4(16)]-4-[v5(0.5)]-8-[v6(26)]", views: menuNameView, menuRating, orderQuantityTextView, orderTotalPriceTextView, orderSinglePriceTextView, separatorTwo, orderDataView)
                } else {
                    if order.isDeclined {
                        menuAboutView.addConstraintsWithFormat(format: "V:|[v0(\(menuNameHeight))]-4-[v1]-4-[v2(16)]-[v3(30)]-[v4(16)]-4-[v5(0.5)]-8-[v6(26)]", views: menuNameView, menuRating, orderQuantityTextView, orderTotalPriceTextView, orderSinglePriceTextView, separatorTwo, orderDataView)
                    } else {
                        menuAboutView.addConstraintsWithFormat(format: "V:|[v0(\(menuNameHeight))]-4-[v1]-4-[v2(16)]-[v3(30)]-[v4(16)]-4-[v5(0.5)]-8-[v6(26)]", views: menuNameView, menuRating, orderQuantityTextView, orderTotalPriceTextView, orderSinglePriceTextView, separatorTwo, orderDataView)
                    }
                }
            }
        }
        
        viewCell.addSubview(menuImageView)
        viewCell.addSubview(menuAboutView)
        
        if !(self.order?.isAccepted ?? true) && !(self.order?.isDeclined ?? true) {
            viewCell.addSubview(orderPendingButtons)
            viewCell.addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: orderPendingButtons)
        } else {
            if self.order?.isDeclined ?? false {
                viewCell.addSubview(reorderButton)
                viewCell.addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: reorderButton)
            }
        }
        
        var staticValue: CGFloat = 2 + 4 + 15 + 8 + 16 + 30 + 16 + 4 + 1 + 26 + 24 + promotionViewHeight
        
        if let order = self.order {
            if !order.isAccepted && !order.isDeclined {
                staticValue += 63
            } else {
                if order.isDeclined {
                    staticValue += 63
                }
            }
        }
        
        if promotionViewHeight > 0 {
            staticValue += 8
        }
        
        viewCell.addConstraintsWithFormat(format: "H:|-12-[v0(\(menuImageConstant))]-12-[v1]", views: menuImageView, menuAboutView)
        viewCell.addConstraintsWithFormat(format: "V:|-12-[v0(55)]", views: menuImageView)
        
        if let order = self.order {
            if !order.isAccepted && !order.isDeclined {
                viewCell.addConstraintsWithFormat(format: "V:|-12-[v0(\(staticValue + menuNameHeight))]-8-[v1(55)]-12-|", views: menuAboutView, orderPendingButtons)
            } else {
                if order.isDeclined {
                    viewCell.addConstraintsWithFormat(format: "V:|-12-[v0(\(staticValue + menuNameHeight))]-8-[v1(55)]-12-|", views: menuAboutView, reorderButton)
                } else {
                    viewCell.addConstraintsWithFormat(format: "V:|-12-[v0(\(staticValue + menuNameHeight))]|", views: menuAboutView)
                }
            }
        }
    }
    
    @IBAction func reOrder(sender: UIButton) {
        self.onReorder()
    }
    
    @IBAction func cancelOrder(sender: UIButton) {
        self.onCancel()
    }
    
    @IBAction func notifyOrder(sender: UIButton) {
        self.onNotify()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
