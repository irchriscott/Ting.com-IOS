//
//  RestaurantMenuViewCell.swift
//  ting
//
//  Created by Christian Scott on 12/20/19.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit

class RestaurantMenuViewCell: UITableViewCell {
    
    let numberFormatter = NumberFormatter()
    
    var menuNameHeight: CGFloat = 20
    var menuDescriptionHeight: CGFloat = 15
    let device = UIDevice.type
    
    var menuNameTextSize: CGFloat = 15
    var menuDescriptionTextSize: CGFloat = 13
    var menuImageConstant: CGFloat = 80
    
    var menuPriceHeight: CGFloat = 16
    
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
    
    let menuDescriptionIconView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = CGRect(x: 0, y: 0, width: 14, height: 14)
        view.image = UIImage(named: "icon_align_left_25_gray")
        view.alpha = 0.5
        return view
    }()
    
    let menuDescriptionTextView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-Regular", size: 13)
        view.textColor = Colors.colorGray
        view.text = "Menu Description"
        view.numberOfLines = 4
        return view
    }()
    
    let menuDescriptionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let menuClassView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let menuCategoryView: ImageTextView = {
        let view = ImageTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Fries"
        return view
    }()
    
    let menuTypeView: IconTextView = {
        let view = IconTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Breakfast"
        view.icon = UIImage(named: "icon_folder_25_gray")!
        return view
    }()
    
    let menuCuisineView: ImageTextView = {
        let view = ImageTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Fast Food"
        return view
    }()
    
    let separatorOne: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.colorVeryLightGray
        return view
    }()
    
    let restaurantMenuPriceView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let restaurantMenuQuantityTextView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-Regular", size: 12)
        view.textColor = Colors.colorGray
        return view
    }()
    
    let restaurantMenuPriceTextView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-SemiBold", size: 27)
        view.textColor = Colors.colorGray
        return view
    }()
    
    let restaurantMenuLastPriceTextView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-Regular", size: 14)
        view.textColor = Colors.colorGray
        return view
    }()
    
    let separatorTwo: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.colorVeryLightGray
        return view
    }()
    
    let restaurantMenuDataView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let restaurantMenuLikesView: IconTextView = {
        let view = IconTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "2,873"
        view.icon = UIImage(named: "icon_like_outline_25_gray")!
        return view
    }()
    
    let restaurantMenuReviewsView: IconTextView = {
        let view = IconTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "876"
        view.icon = UIImage(named: "icon_star_outline_25_gray")!
        return view
    }()
    
    let restaurantMenuAvailabilityView: IconTextView = {
        let view = IconTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.icon = UIImage(named: "icon_check_white_25")!
        view.text = "Available"
        view.textColor = Colors.colorWhite
        view.background = Colors.colorStatusTimeGreen
        return view
    }()
    
    var restaurantMenu: RestaurantMenu? {
        didSet {
            numberFormatter.numberStyle = .decimal
            if let menu = self.restaurantMenu {
                
                let images = menu.menu?.images?.images
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
                
                menuNameView.text = menu.menu?.name
                menuDescriptionTextView.text = menu.menu?.description
                menuRating.rating = (menu.menu?.reviews?.average)!
                
                if menu.menu?.foodType != nil {
                    self.menuTypeView.icon = UIImage(named: "icon_folder_25_gray")!
                    self.menuTypeView.text = (menu.menu?.foodType)!
                }
                
                if menu.menu?.drinkType != nil {
                    self.menuTypeView.icon = UIImage(named: "icon_folder_25_gray")!
                    self.menuTypeView.text = (menu.menu?.drinkType)!
                }
                
                if menu.menu?.dishTime != nil {
                    self.menuTypeView.icon = UIImage(named: "icon_clock_25_black")!
                    self.menuTypeView.iconAlpha = 0.4
                    self.menuTypeView.text = (menu.menu?.dishTime)!
                }
                
                if let category = menu.menu?.category {
                    self.menuCategoryView.text = category.name!
                    self.menuCategoryView.imageURL = "\(URLs.hostEndPoint)\(category.image!)"
                }
                
                if let cuisine = menu.menu?.cuisine {
                    self.menuCuisineView.imageURL = "\(URLs.hostEndPoint)\(cuisine.image)"
                    self.menuCuisineView.text = cuisine.name
                }
                
                if menu.menu?.isCountable ?? false {
                    switch menu.type?.id {
                    case 1:
                        self.restaurantMenuQuantityTextView.text = "\((menu.menu?.quantity)!) pieces / packs"
                        break
                    case 2:
                        self.restaurantMenuQuantityTextView.text = "\((menu.menu?.quantity)!) cups / bottles"
                        break
                    case 3:
                        self.restaurantMenuQuantityTextView.text = "\((menu.menu?.quantity)!) plates / packs"
                        break
                    default:
                        self.restaurantMenuQuantityTextView.text = "\((menu.menu?.quantity)!) packs"
                        break
                    }
                }
                
                restaurantMenuPriceTextView.text = "\((menu.menu?.currency)!) \(numberFormatter.string(from: NSNumber(value: Double((menu.menu?.price)!)!))!)"
                
                restaurantMenuLastPriceTextView.text = "\((menu.menu?.currency)!) \(numberFormatter.string(from: NSNumber(value: Double((menu.menu?.lastPrice)!)!))!)"
                
                let attributeString = NSMutableAttributedString(string: "\((menu.menu?.currency)!) \(numberFormatter.string(from: NSNumber(value: Double((menu.menu?.lastPrice)!)!))!)")
                
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
                
                self.restaurantMenuLastPriceTextView.attributedText = attributeString
                
                restaurantMenuLikesView.text = numberFormatter.string(from: NSNumber(value: menu.menu?.likes?.count ?? 0))!
                restaurantMenuReviewsView.text = numberFormatter.string(from: NSNumber(value: menu.menu?.reviews?.count ?? 0))!
                
                if menu.menu?.isAvailable ?? true {
                    restaurantMenuAvailabilityView.text = "Available"
                    restaurantMenuAvailabilityView.icon = UIImage(named: "icon_check_white_25")!
                    restaurantMenuAvailabilityView.background = Colors.colorStatusTimeGreen
                } else {
                    restaurantMenuAvailabilityView.text = "Not Available"
                    restaurantMenuAvailabilityView.icon = UIImage(named: "icon_close_25_white")!
                    restaurantMenuAvailabilityView.background = Colors.colorStatusTimeRed
                }
                
                if UIDevice.smallDevices.contains(device) {
                    menuImageConstant = 55
                    menuNameTextSize = 14
                    menuDescriptionTextSize = 12
                } else if UIDevice.mediumDevices.contains(device) {
                    menuImageConstant = 70
                    menuNameTextSize = 15
                    menuDescriptionTextSize = 12
                }
                
                let frameWidth = frame.width - (60 + menuImageConstant)
                
                let menuNameRect = NSString(string: (menu.menu?.name)!).boundingRect(with: CGSize(width: frameWidth, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: menuNameTextSize)!], context: nil)
                
                let menuDescriptionRect = NSString(string: (menu.menu?.description)!).boundingRect(with: CGSize(width: frameWidth - 18, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: menuDescriptionTextSize)!], context: nil)
                
                menuDescriptionHeight = menuDescriptionRect.height
                menuNameHeight = menuNameRect.height
                
                let priceRect = NSString(string: "UGX 10,000").boundingRect(with: CGSize(width: frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: 27)!], context: nil)
                
                let quantityRect = NSString(string: "2 packs / counts").boundingRect(with: CGSize(width: frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 12)!], context: nil)
                
                let lastPriceRect = NSString(string: "UGX 6,000").boundingRect(with: CGSize(width: frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 12)!], context: nil)
                
                if (menu.menu?.isCountable)! && Double((menu.menu?.price)!) != Double((menu.menu?.lastPrice)!) {
                    menuPriceHeight += priceRect.height + quantityRect.height + lastPriceRect.height
                } else if !(menu.menu?.isCountable)! && Double((menu.menu?.price)!) != Double((menu.menu?.lastPrice)!) {
                    menuPriceHeight += priceRect.height + lastPriceRect.height
                } else if (menu.menu?.isCountable)! && !(Double((menu.menu?.price)!) != Double((menu.menu?.lastPrice)!)) {
                    menuPriceHeight += priceRect.height + quantityRect.height
                } else { menuPriceHeight += priceRect.height }
            }
            self.setup()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    private func setup() {
        addSubview(viewCell)
        
        addConstraintsWithFormat(format: "V:|-12-[v0]|", views: viewCell)
        addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: viewCell)
        
        menuDescriptionView.addSubview(menuDescriptionIconView)
        menuDescriptionView.addSubview(menuDescriptionTextView)
        
        menuDescriptionTextView.font = UIFont(name: "Poppins-Regular", size: menuDescriptionTextSize)
        
        menuDescriptionView.addConstraintsWithFormat(format: "H:|[v0(14)]-4-[v1]|", views: menuDescriptionIconView, menuDescriptionTextView)
        menuDescriptionView.addConstraintsWithFormat(format: "V:|[v0(14)]", views: menuDescriptionIconView)
        menuDescriptionView.addConstraintsWithFormat(format: "V:|[v0]", views: menuDescriptionTextView)
        
        menuClassView.addSubview(menuTypeView)
        menuClassView.addConstraintsWithFormat(format: "V:|[v0(26)]|", views: menuTypeView)
        
        if self.restaurantMenu?.type?.id != 2 {
            
            menuClassView.addSubview(menuCuisineView)
            menuClassView.addConstraintsWithFormat(format: "V:|[v0(26)]|", views: menuCuisineView)
            
            if UIDevice.bigDevices.contains(device) || UIDevice.ipadsDevices.contains(device) {
                menuClassView.addSubview(menuCategoryView)
                menuClassView.addConstraintsWithFormat(format: "V:|[v0(26)]|", views: menuCategoryView)
                menuClassView.addConstraintsWithFormat(format: "H:|[v0]-8-[v1]-8-[v2]", views: menuCategoryView, menuTypeView, menuCuisineView)
            } else {
                menuClassView.addConstraintsWithFormat(format: "H:|[v0]-8-[v1]", views: menuTypeView, menuCuisineView)
            }
            
        } else { menuClassView.addConstraintsWithFormat(format: "H:|[v0]", views: menuTypeView) }
        
        restaurantMenuDataView.addSubview(restaurantMenuLikesView)
        restaurantMenuDataView.addSubview(restaurantMenuReviewsView)
        restaurantMenuDataView.addSubview(restaurantMenuAvailabilityView)
        
        restaurantMenuDataView.addConstraintsWithFormat(format: "V:|[v0(26)]|", views: restaurantMenuLikesView)
        restaurantMenuDataView.addConstraintsWithFormat(format: "V:|[v0(26)]|", views: restaurantMenuReviewsView)
        restaurantMenuDataView.addConstraintsWithFormat(format: "V:|[v0(26)]|", views: restaurantMenuAvailabilityView)
        
        restaurantMenuDataView.addConstraintsWithFormat(format: "H:|[v0]-8-[v1]-8-[v2]", views: restaurantMenuLikesView, restaurantMenuReviewsView, restaurantMenuAvailabilityView)
        
        menuAboutView.addSubview(menuNameView)
        menuAboutView.addSubview(menuRating)
        menuAboutView.addSubview(menuDescriptionView)
        menuAboutView.addSubview(separatorOne)
        menuAboutView.addSubview(restaurantMenuPriceTextView)
        menuAboutView.addSubview(separatorTwo)
        menuAboutView.addSubview(menuClassView)
        menuAboutView.addSubview(restaurantMenuDataView)
        
        menuNameView.font = UIFont(name: "Poppins-SemiBold", size: menuNameTextSize)
        
        menuAboutView.addConstraintsWithFormat(format: "H:|[v0]|", views: menuNameView)
        menuAboutView.addConstraintsWithFormat(format: "H:|[v0]|", views: menuRating)
        menuAboutView.addConstraintsWithFormat(format: "H:|[v0]|", views: menuDescriptionView)
        menuAboutView.addConstraintsWithFormat(format: "H:|[v0]|", views: separatorOne)
        menuAboutView.addConstraintsWithFormat(format: "H:|[v0]|", views: restaurantMenuPriceTextView)
        menuAboutView.addConstraintsWithFormat(format: "H:|[v0]|", views: separatorTwo)
        menuAboutView.addConstraintsWithFormat(format: "H:|[v0]|", views: menuClassView)
        menuAboutView.addConstraintsWithFormat(format: "H:|[v0]|", views: restaurantMenuDataView)
        
        let priceRect = NSString(string: "UGX 10,000").boundingRect(with: CGSize(width: frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: 27)!], context: nil)
        
        let quantityRect = NSString(string: "2 packs / counts").boundingRect(with: CGSize(width: frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 12)!], context: nil)
        
        let lastPriceRect = NSString(string: "UGX 6,000").boundingRect(with: CGSize(width: frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 12)!], context: nil)
        
        if let menu = self.restaurantMenu {
            
            if Double((menu.menu?.price)!) != Double((menu.menu?.lastPrice)!) {
                menuAboutView.addSubview(restaurantMenuLastPriceTextView)
                menuAboutView.addConstraintsWithFormat(format: "H:|[v0]|", views: restaurantMenuLastPriceTextView)
            }
            
            if menu.menu?.isCountable ?? false {
                menuAboutView.addSubview(restaurantMenuQuantityTextView)
                menuAboutView.addConstraintsWithFormat(format: "H:|[v0]|", views: restaurantMenuQuantityTextView)
            }
            
            if (menu.menu?.isCountable)! && Double((menu.menu?.price)!) != Double((menu.menu?.lastPrice)!) {
                menuAboutView.addConstraintsWithFormat(format: "V:|[v0(\(menuNameHeight))]-4-[v1]-4-[v2]-4-[v3(0.5)]-8-[v4(\(quantityRect.height))]-0-[v5(\(priceRect.height))]-0-[v6(\(lastPriceRect.height))]-8-[v7(0.5)]-8-[v8(26)]-8-[v9(26)]-12-|", views: menuNameView, menuRating, menuDescriptionView, separatorOne, restaurantMenuQuantityTextView, restaurantMenuPriceTextView, restaurantMenuLastPriceTextView, separatorTwo, menuClassView, restaurantMenuDataView)
            } else if !(menu.menu?.isCountable)! && Double((menu.menu?.price)!) != Double((menu.menu?.lastPrice)!) {
                menuAboutView.addConstraintsWithFormat(format: "V:|[v0(\(menuNameHeight))]-4-[v1]-4-[v2]-4-[v3(0.5)]-8-[v4(\(priceRect.height))]-0-[v5(\(lastPriceRect.height))]-8-[v6(0.5)]-8-[v7(26)]-8-[v8(26)]-12-|", views: menuNameView, menuRating, menuDescriptionView, separatorOne, restaurantMenuPriceTextView, restaurantMenuLastPriceTextView, separatorTwo, menuClassView, restaurantMenuDataView)
            } else if (menu.menu?.isCountable)! && !(Double((menu.menu?.price)!) != Double((menu.menu?.lastPrice)!)) {
                menuAboutView.addConstraintsWithFormat(format: "V:|[v0(\(menuNameHeight))]-4-[v1]-4-[v2]-4-[v3(0.5)]-8-[v4(\(quantityRect.height))]-0-[v5(\(priceRect.height))]-8-[v6(0.5)]-8-[v7(26)]-8-[v8(26)]-12-|", views: menuNameView, menuRating, menuDescriptionView, separatorOne, restaurantMenuQuantityTextView, restaurantMenuPriceTextView, separatorTwo, menuClassView, restaurantMenuDataView)
            } else {
                menuAboutView.addConstraintsWithFormat(format: "V:|[v0(\(menuNameHeight))]-4-[v1]-4-[v2]-4-[v3(0.5)]-8-[v4(\(priceRect.height))]-8-[v5(0.5)]-8-[v6(26)]-8-[v7(26)]-12-|", views: menuNameView, menuRating, menuDescriptionView, separatorOne, restaurantMenuPriceTextView, separatorTwo, menuClassView, restaurantMenuDataView)
            }
        }
        
        viewCell.addSubview(menuImageView)
        viewCell.addSubview(menuAboutView)
        
        let staticValue: CGFloat = 12 + 1 + 4 + 4 + 1 + 8 + 8 + 8 + 8 + 26 + 26 + 12
        
        viewCell.addConstraintsWithFormat(format: "H:|-12-[v0(\(menuImageConstant))]-12-[v1]-12-|", views: menuImageView, menuAboutView)
        viewCell.addConstraintsWithFormat(format: "V:|-12-[v0(55)]", views: menuImageView)
        viewCell.addConstraintsWithFormat(format: "V:|-12-[v0(\(staticValue + menuDescriptionHeight + menuNameHeight + menuPriceHeight))]", views: menuAboutView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
