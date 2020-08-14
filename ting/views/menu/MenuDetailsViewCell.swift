//
//  MenuDetailsViewCell.swift
//  ting
//
//  Created by Christian Scott on 11/10/19.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import FaveButton

class MenuDetailsViewCell: UICollectionViewCell, CLLocationManagerDelegate, FaveButtonDelegate {
    
    let numberFormatter = NumberFormatter()
    
    var restaurantMenuNameHeight: CGFloat = 28
    var restaurantMenuDescriptionHeight: CGFloat = 16
    var restaurantMenuIngredientsHeight: CGFloat = 16
    let device = UIDevice.type
    
    var restaurantMenuNameTextSize: CGFloat = 20
    var restaurantDescriptionTextSize: CGFloat = 13
    
    var locationManager = CLLocationManager()
    var selectedLocation: CLLocation?
    
    let session = UserAuthentication().get()!
    var isMapOpened: Bool = false
    var mapCenter: CLLocation?
    
    let mapFloatingButton: FloatingButton = {
        let view = FloatingButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.icon = UIImage(named: "icon_addess_white")
        return view
    }()
    
    lazy var menuNameTextView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-SemiBold", size: self.restaurantMenuNameTextSize)
        view.textColor = Colors.colorGray
        return view
    }()
    
    let restaurantMenuRating: CosmosView = {
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
    
    let restaurantMenuDescriptionIcon: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = CGRect(x: 0, y: 0, width: 14, height: 14)
        view.image = UIImage(named: "icon_align_left_25_gray")
        view.alpha = 0.5
        return view
    }()
    
    let restaurantMenuDescriptionText: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-Regular", size: 13)
        view.textColor = Colors.colorGray
        view.text = "Restaurant Menu Description"
        view.numberOfLines = 4
        return view
    }()
    
    let restaurantMenuDescriptionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let restaurantMenuView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let restaurantMenuCategoryView: ImageTextView = {
        let view = ImageTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Fries"
        return view
    }()
    
    let restaurantMenuGroupView: IconTextView = {
        let view = IconTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Food"
        view.icon = UIImage(named: "icon_star_outline_25_gray")!
        return view
    }()
    
    let restaurantMenuTypeView: IconTextView = {
        let view = IconTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Breakfast"
        view.icon = UIImage(named: "icon_plus_filled_25_gray")!
        return view
    }()
    
    let restaurantMenuCuisineView: ImageTextView = {
        let view = ImageTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Fast Food"
        return view
    }()
    
    let separatorZero: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.colorVeryLightGray
        return view
    }()
    
    let restaurantIngredientsTitleView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-Medium", size: 14)
        view.text = "Ingredients".uppercased()
        view.textColor = Colors.colorGray
        return view
    }()
    
    let restaurantIngredientsView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-Regular", size: 13)
        view.text = "Not Available"
        view.textColor = Colors.colorGray
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
    
    let restaurantLikeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        view.layer.cornerRadius = 23
        view.layer.masksToBounds = true
        view.backgroundColor = Colors.colorDarkTransparent
        return view
    }()
    
    let restaurantLikeImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "icon_heart_like_32_gray")
        return view
    }()
    
    lazy var faveButtonLike: FaveButton = {
        let view = FaveButton(frame: CGRect(x: 0, y: 0, width: 28, height: 28), faveIconNormal: UIImage(named: "icon_heart_fill_25_gray"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.selectedColor = Colors.colorPrimary
        view.normalColor = Colors.colorGray
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
    
    let separatorThree: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.colorVeryLightGray
        return view
    }()
    
    let restaurantDataView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let restaurantName: ImageTextView = {
        let view = ImageTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.iconView.backgroundColor = Colors.colorGray
        view.text = "Loading ..."
        return view
    }()
    
    let restaurantDistanceView: IconTextView = {
        let view = IconTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.iconAlpha = 0.4
        view.icon = UIImage(named: "icon_road_25_black")!
        view.text = "Loading ..."
        return view
    }()
    
    let restaurantTimeStatusView: IconTextView = {
        let view = IconTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.icon = UIImage(named: "icon_clock_25_white")!
        view.text = "Loading ..."
        view.textColor = Colors.colorWhite
        view.background = Colors.colorStatusTimeOrange
        return view
    }()
    
    let separatorFour: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.colorVeryLightGray
        return view
    }()
    
    var parentController: RestaurantMenuViewController? {
        didSet { self.setup() }
    }
    
    var controller: UIViewController? {
        didSet { self.setup() }
    }
    
    var menu: RestaurantMenu? {
        didSet {
            numberFormatter.numberStyle = .decimal
            if let menu = self.menu {
                self.menuNameTextView.text = menu.menu?.name
                self.restaurantMenuRating.rating = Double(menu.menu?.reviews?.average ?? 0)
                self.restaurantMenuDescriptionText.text = menu.menu?.description
                
                if menu.type?.id != 2 {
                    self.restaurantMenuCategoryView.imageURL = "\(URLs.hostEndPoint)\((menu.menu?.category?.image)!)"
                    self.restaurantMenuCategoryView.text = (menu.menu?.category?.name)!
                    
                    self.restaurantMenuCuisineView.imageURL = "\(URLs.hostEndPoint)\((menu.menu?.cuisine?.image)!)"
                    self.restaurantMenuCuisineView.text = (menu.menu?.cuisine?.name)!
                }
                
                if menu.menu?.foodType != nil {
                    self.restaurantMenuGroupView.icon = UIImage(named: "icon_spoon_25_gray")!
                    self.restaurantMenuGroupView.text = (menu.type?.name)!
                    
                    self.restaurantMenuTypeView.icon = UIImage(named: "icon_folder_25_gray")!
                    self.restaurantMenuTypeView.text = (menu.menu?.foodType)!
                }
                
                if menu.menu?.drinkType != nil {
                    self.restaurantMenuGroupView.icon = UIImage(named: "icon_wine_glass_25_gray")!
                    self.restaurantMenuGroupView.text = (menu.type?.name)!
                    
                    self.restaurantMenuTypeView.icon = UIImage(named: "icon_folder_25_gray")!
                    self.restaurantMenuTypeView.text = (menu.menu?.drinkType)!
                }
                
                if menu.menu?.dishTime != nil {
                    self.restaurantMenuGroupView.icon = UIImage(named: "ic_restaurants")!
                    self.restaurantMenuGroupView.iconAlpha = 0.4
                    self.restaurantMenuGroupView.text = (menu.type?.name)!
                    
                    self.restaurantMenuTypeView.icon = UIImage(named: "icon_clock_25_black")!
                    self.restaurantMenuTypeView.iconAlpha = 0.4
                    self.restaurantMenuTypeView.text = (menu.menu?.dishTime)!
                }
                
                if UIDevice.smallDevices.contains(device) {
                    restaurantMenuNameTextSize = 15
                    restaurantDescriptionTextSize = 12
                } else if UIDevice.mediumDevices.contains(device) {
                    restaurantMenuNameTextSize = 17
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
                
                let frameWidth = frame.width - 16
                
                let menuNameRect = NSString(string: (menu.menu?.name!)!).boundingRect(with: CGSize(width: frameWidth, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: restaurantMenuNameTextSize)!], context: nil)
                
                let menuDescriptionRect = NSString(string: (menu.menu?.description!)!).boundingRect(with: CGSize(width: frameWidth - 20, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: restaurantDescriptionTextSize)!], context: nil)
                
                if menu.menu?.showIngredients ?? true {
                    let menuIngredientsRect = NSString(string: (menu.menu?.ingredients!)!.withoutHtml).boundingRect(with: CGSize(width: frameWidth, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 13)!], context: nil)
                    
                    restaurantIngredientsView.text = menu.menu?.ingredients!.withoutHtml
                    restaurantMenuIngredientsHeight = menuIngredientsRect.height
                }
                
                restaurantMenuNameHeight = menuNameRect.height
                restaurantMenuDescriptionHeight = menuDescriptionRect.height
                
                if let branch = menu.menu?.branch, let restaurant = menu.menu?.restaurant {
                    restaurantName.text = "\(restaurant.name), \(branch.name)"
                    restaurantName.imageURL = "\(URLs.hostEndPoint)\(restaurant.logo)"
                    
                    self.setTimeStatus()
                    
                    if branch.isAvailable { Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(setTimeStatus), userInfo: nil, repeats: true)
                    }
                    
                    let latitude = CLLocationDegrees(exactly: Double(branch.latitude)!)
                    let longitude = CLLocationDegrees(exactly: Double(branch.longitude)!)
                    
                    self.mapCenter = CLLocation(latitude: latitude!, longitude: longitude!)
                    self.checkLocationAuthorization(status: CLLocationManager.authorizationStatus())
                }
                
                if let likes = menu.menu?.likes?.likes {
                    if likes.contains(session.id) {
                        restaurantLikeImage.image =  UIImage(named: "icon_heart_like_32_primary")
                        faveButtonLike.setSelected(selected: true, animated: true)
                    }
                }
                
                self.setRestaurantDistance()
            }
            self.setup()
        }
    }
    
    lazy var mapView: RestaurantMapView = {
        let view = RestaurantMapView()
        view.controller = self.controller
        view.restaurant = self.menu?.menu?.branch
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.restaurantDistanceView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(MenuDetailsViewCell.showUserAddresses)))
        self.restaurantName.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navigateToRestaurant(_:))))
        self.restaurantLikeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MenuDetailsViewCell.likeRestaurantMenuToggle)))
        self.restaurantDistanceView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openRestaurantMap)))
        self.mapView.closeButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeRestaurantMap)))
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.checkLocationAuthorization(status: CLLocationManager.authorizationStatus())
    }
    
    private func setup() {
        
        restaurantMenuDescriptionView.addSubview(restaurantMenuDescriptionIcon)
        restaurantMenuDescriptionView.addSubview(restaurantMenuDescriptionText)
        
        restaurantMenuDescriptionText.font = UIFont(name: "Poppins-Regular", size: restaurantDescriptionTextSize)
        
        restaurantMenuDescriptionView.addConstraintsWithFormat(format: "H:|[v0(14)]-8-[v1]|", views: restaurantMenuDescriptionIcon, restaurantMenuDescriptionText)
        restaurantMenuDescriptionView.addConstraintsWithFormat(format: "V:|[v0(14)]", views: restaurantMenuDescriptionIcon)
        restaurantMenuDescriptionView.addConstraintsWithFormat(format: "V:|[v0(\(restaurantMenuDescriptionHeight))]", views: restaurantMenuDescriptionText)
        
        if menu?.type?.id != 2 {
            restaurantMenuView.addSubview(restaurantMenuCategoryView)
            restaurantMenuView.addSubview(restaurantMenuCuisineView)
        }
        
        restaurantMenuView.addSubview(restaurantMenuGroupView)
        restaurantMenuView.addSubview(restaurantMenuTypeView)
        
        if menu?.type?.id != 2 {
            restaurantMenuView.addConstraintsWithFormat(format: "H:|[v0]-8-[v1]-8-[v2]-8-[v3]", views: restaurantMenuCategoryView, restaurantMenuGroupView, restaurantMenuTypeView, restaurantMenuCuisineView)
        } else {
            restaurantMenuView.addConstraintsWithFormat(format: "H:|[v0]-8-[v1]", views: restaurantMenuGroupView, restaurantMenuTypeView)
        }
        
        if menu?.type?.id != 2 {
            restaurantMenuView.addConstraintsWithFormat(format: "V:|[v0(26)]|", views: restaurantMenuCategoryView)
            restaurantMenuView.addConstraintsWithFormat(format: "V:|[v0(26)]|", views: restaurantMenuCuisineView)
        }
        
        restaurantMenuView.addConstraintsWithFormat(format: "V:|[v0(26)]|", views: restaurantMenuGroupView)
        restaurantMenuView.addConstraintsWithFormat(format: "V:|[v0(26)]|", views: restaurantMenuTypeView)
        
        if let menu = self.menu {
            if menu.menu?.isCountable ?? false {
                restaurantMenuPriceView.addSubview(restaurantMenuQuantityTextView)
                restaurantMenuPriceView.addConstraintsWithFormat(format: "H:|-8-[v0]", views: restaurantMenuQuantityTextView)
            }
        }
        
        restaurantMenuPriceView.addSubview(restaurantMenuPriceTextView)
        restaurantMenuPriceView.addConstraintsWithFormat(format: "H:|-8-[v0]", views: restaurantMenuPriceTextView)

        restaurantLikeView.addSubview(faveButtonLike)
        restaurantLikeView.addConstraintsWithFormat(format: "H:[v0(28)]", views: faveButtonLike)
        restaurantLikeView.addConstraintsWithFormat(format: "V:[v0(28)]", views: faveButtonLike)
        restaurantLikeView.addConstraint(NSLayoutConstraint(item: restaurantLikeView, attribute: .centerX, relatedBy: .equal, toItem: faveButtonLike, attribute: .centerX, multiplier: 1, constant: 0))
        restaurantLikeView.addConstraint(NSLayoutConstraint(item: restaurantLikeView, attribute: .centerY, relatedBy: .equal, toItem: faveButtonLike, attribute: .centerY, multiplier: 1, constant: 0))
        
        restaurantMenuPriceView.addSubview(restaurantLikeView)
        restaurantMenuPriceView.addConstraintsWithFormat(format: "H:[v0(46)]|", views: restaurantLikeView)
        restaurantMenuPriceView.addConstraintsWithFormat(format: "V:[v0(46)]", views: restaurantLikeView)
        restaurantMenuPriceView.addConstraint(NSLayoutConstraint(item: restaurantMenuPriceView, attribute: .centerY, relatedBy: .equal, toItem: restaurantLikeView, attribute: .centerY, multiplier: 1, constant: 0))
        
        var menuPriceHeight: CGFloat = 0
        
        if let menu = self.menu {
            
            let priceRect = NSString(string: "UGX 10,000").boundingRect(with: CGSize(width: frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: 27)!], context: nil)
                           
            let quantityRect = NSString(string: "2 packs / counts").boundingRect(with: CGSize(width: frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 12)!], context: nil)
                           
            let lastPriceRect = NSString(string: "UGX 6,000").boundingRect(with: CGSize(width: frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 14)!], context: nil)
            
            if Double((menu.menu?.price)!) != Double((menu.menu?.lastPrice)!) {
                restaurantMenuPriceView.addSubview(restaurantMenuLastPriceTextView)
                restaurantMenuPriceView.addConstraintsWithFormat(format: "H:|-8-[v0]", views: restaurantMenuLastPriceTextView)
            }
            
            if (menu.menu?.isCountable)! && Double((menu.menu?.price)!) != Double((menu.menu?.lastPrice)!) {
                restaurantMenuPriceView.addConstraintsWithFormat(format: "V:|[v0(\(quantityRect.height))]-0-[v1(\(priceRect.height))]-0-[v2(\(lastPriceRect.height))]|", views: restaurantMenuQuantityTextView, restaurantMenuPriceTextView, restaurantMenuLastPriceTextView)
                menuPriceHeight += priceRect.height + quantityRect.height + lastPriceRect.height
            } else if !(menu.menu?.isCountable)! && Double((menu.menu?.price)!) != Double((menu.menu?.lastPrice)!) {
                restaurantMenuPriceView.addConstraintsWithFormat(format: "V:|[v0(\(priceRect.height))]-0-[v1(\(lastPriceRect.height))]|", views: restaurantMenuPriceTextView, restaurantMenuLastPriceTextView)
                menuPriceHeight += priceRect.height + lastPriceRect.height
            } else if (menu.menu?.isCountable)! && !(Double((menu.menu?.price)!) != Double((menu.menu?.lastPrice)!)){
                restaurantMenuPriceView.addConstraintsWithFormat(format: "V:|[v0(\(quantityRect.height))]-0-[v1(\(priceRect.height))]|", views: restaurantMenuQuantityTextView, restaurantMenuPriceTextView)
                menuPriceHeight += priceRect.height + quantityRect.height
            } else {
                restaurantMenuPriceView.addConstraintsWithFormat(format: "V:|[v0(\(priceRect.height))]|", views: restaurantMenuPriceTextView)
                menuPriceHeight += priceRect.height
            }
        }
        
        restaurantMenuDataView.addSubview(restaurantMenuLikesView)
        restaurantMenuDataView.addSubview(restaurantMenuReviewsView)
        restaurantMenuDataView.addSubview(restaurantMenuAvailabilityView)
        
        restaurantMenuDataView.addConstraintsWithFormat(format: "H:|[v0]-8-[v1]-8-[v2]", views: restaurantMenuLikesView, restaurantMenuReviewsView, restaurantMenuAvailabilityView)
        restaurantMenuDataView.addConstraintsWithFormat(format: "V:|[v0(26)]|", views: restaurantMenuLikesView)
        restaurantMenuDataView.addConstraintsWithFormat(format: "V:|[v0(26)]|", views: restaurantMenuReviewsView)
        restaurantMenuDataView.addConstraintsWithFormat(format: "V:|[v0(26)]|", views: restaurantMenuAvailabilityView)
        
        restaurantDataView.addSubview(restaurantName)
        restaurantDataView.addSubview(restaurantDistanceView)
        restaurantDataView.addSubview(restaurantTimeStatusView)
        
        restaurantDataView.addConstraintsWithFormat(format: "H:|[v0]-8-[v1]", views: restaurantName, restaurantDistanceView)
        restaurantDataView.addConstraintsWithFormat(format: "H:|[v0]", views: restaurantTimeStatusView)
        restaurantDataView.addConstraintsWithFormat(format: "V:|[v0(26)]-8-[v1(26)]|", views: restaurantName, restaurantTimeStatusView)
        
        addSubview(menuNameTextView)
        addSubview(restaurantMenuRating)
        addSubview(restaurantMenuDescriptionView)
        addSubview(restaurantMenuView)
        addSubview(separatorZero)
        addSubview(restaurantIngredientsTitleView)
        addSubview(restaurantIngredientsView)
        addSubview(separatorOne)
        addSubview(restaurantMenuPriceView)
        addSubview(separatorTwo)
        addSubview(restaurantMenuDataView)
        addSubview(separatorThree)
        addSubview(restaurantDataView)
        addSubview(separatorFour)
        
        addConstraintsWithFormat(format: "H:|-8-[v0]", views: menuNameTextView)
        addConstraintsWithFormat(format: "H:|-8-[v0]", views: restaurantMenuRating)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: restaurantMenuDescriptionView)
        addConstraintsWithFormat(format: "H:|-8-[v0]", views: restaurantMenuView)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: separatorZero)
        addConstraintsWithFormat(format: "H:|-8-[v0]", views: restaurantIngredientsTitleView)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: restaurantIngredientsView)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: separatorOne)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: restaurantMenuPriceView)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: separatorTwo)
        addConstraintsWithFormat(format: "H:|-8-[v0]", views: restaurantMenuDataView)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: separatorThree)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: restaurantDataView)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: separatorFour)
        
        addConstraintsWithFormat(format: "V:|-8-[v0(\(restaurantMenuNameHeight - 5))]-8-[v1]-8-[v2(\(restaurantMenuDescriptionHeight))]-8-[v3(26)]-8-[v4(0.5)]-8-[v5(18)]-8-[v6(\(restaurantMenuIngredientsHeight))]-8-[v7(0.5)]-8-[v8(\(menuPriceHeight))]-8-[v9(0.5)]-8-[v10(26)]-8-[v11(0.5)]-8-[v12(60)]-8-[v13(0.5)]", views: menuNameTextView, restaurantMenuRating, restaurantMenuDescriptionView, restaurantMenuView, separatorZero, restaurantIngredientsTitleView, restaurantIngredientsView, separatorOne, restaurantMenuPriceView, separatorTwo, restaurantMenuDataView, separatorThree, restaurantDataView, separatorFour)
    }
    
    private func checkLocationAuthorization(status: CLAuthorizationStatus){
        self.locationManager.delegate = self
        switch status {
        case .authorizedAlways:
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.startUpdatingLocation()
            break
        case .authorizedWhenInUse:
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.startUpdatingLocation()
            break
        case .denied:
            let location = CLLocation(latitude: CLLocationDegrees(Double((session.addresses?.addresses[0].latitude)!)!), longitude: CLLocationDegrees(Double((session.addresses?.addresses[0].longitude)!)!))
            self.selectedLocation = location
            self.setRestaurantDistance()
            let alert = UIAlertController(title: "Please, Go to settings and allow this app to use your location", message: nil, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            Toast.makeToast(message: "Please, Go to settings and allow this app to use your location", duration: Toast.MID_LENGTH_DURATION, style: .default)
            break
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
            break
        case .restricted:
            let location = CLLocation(latitude: CLLocationDegrees(Double((session.addresses?.addresses[0].latitude)!)!), longitude: CLLocationDegrees(Double((session.addresses?.addresses[0].longitude)!)!))
            self.selectedLocation = location
            self.setRestaurantDistance()
            let alert = UIAlertController(title: "Please, Go to settings and allow this app to use your location", message: nil, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            Toast.makeToast(message: "Please, Go to settings and allow this app to use your location", duration: Toast.MID_LENGTH_DURATION, style: .default)
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            let addresses = session.addresses?.addresses
            let address = addresses![0]
            self.selectedLocation = CLLocation(latitude: CLLocationDegrees(Double(address.latitude)!), longitude: CLLocationDegrees(Double(address.longitude)!))
            self.setRestaurantDistance()
            return
        }
        self.selectedLocation = location
        self.setRestaurantDistance()
    }
    
    private func setRestaurantDistance() {
        if let branch = self.menu?.menu?.branch, let location = self.selectedLocation {
            let branchLocation = CLLocation(latitude: CLLocationDegrees(exactly: Double(branch.latitude)!)!, longitude: CLLocationDegrees(exactly: Double(branch.longitude)!)!)
            let distance = Double(branchLocation.distance(from: location) / 1000).rounded(toPlaces: 2)
            restaurantDistanceView.text = "\(numberFormatter.string(from: NSNumber(value: distance))!) km"
        } else if let branch = self.menu?.menu?.branch {
            let address = session.addresses?.addresses[0]
            let branchLocation = CLLocation(latitude: CLLocationDegrees(exactly: Double(branch.latitude)!)!, longitude: CLLocationDegrees(exactly: Double(branch.longitude)!)!)
            self.selectedLocation = CLLocation(latitude: CLLocationDegrees(exactly: Double(address!.latitude)!)!, longitude: CLLocationDegrees(exactly: Double(address!.longitude)!)!)
            
            if let location = self.selectedLocation {
                let distance = Double(branchLocation.distance(from: location) / 1000).rounded(toPlaces: 2)
                restaurantDistanceView.text = "\(numberFormatter.string(from: NSNumber(value: distance))!) km"
            }
        }
    }
    
    @objc private func setTimeStatus() {
        if let branch = self.menu?.menu?.branch,  let restaurant = self.menu?.menu?.restaurant {
            if branch.isAvailable {
                let timeStatus = Functions.statusWorkTime(open: restaurant.opening, close: restaurant.closing)
                if let status = timeStatus {
                    self.restaurantTimeStatusView.text = status["msg"]!
                    switch status["clr"] {
                    case "orange":
                        self.restaurantTimeStatusView.background = Colors.colorStatusTimeOrange
                    case "red":
                        self.restaurantTimeStatusView.background = Colors.colorStatusTimeRed
                    case "green":
                        self.restaurantTimeStatusView.background = Colors.colorStatusTimeGreen
                    default:
                        self.restaurantTimeStatusView.background = Colors.colorStatusTimeOrange
                    }
                }
            } else {
                self.restaurantTimeStatusView.background = Colors.colorStatusTimeRed
                self.restaurantTimeStatusView.text = "Not Available"
                self.restaurantTimeStatusView.icon = UIImage(named: "icon_close_bold_25_white")!
            }
        }
    }
    
    @objc func showUserAddresses() {
        let addresses = UIAlertController(title: "Restaurants Near Location", message: nil, preferredStyle: .actionSheet)
        addresses.addAction(UIAlertAction(title: "Current Location", style: .default) { (action) in
            DispatchQueue.main.async { self.checkLocationAuthorization(status: CLLocationManager.authorizationStatus()) }
        })
        session.addresses?.addresses.forEach({ (address) in
            addresses.addAction(UIAlertAction(title: address.address, style: .default, handler: { (action) in
                DispatchQueue.main.async {
                    let location = CLLocation(latitude: CLLocationDegrees(Double(address.latitude)!), longitude: CLLocationDegrees(Double(address.longitude)!))
                    self.selectedLocation = location
                    self.setRestaurantDistance()
                }
            }))
        })

        addresses.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { (action) in }))
        self.parentController?.present(addresses, animated: true, completion: nil)
    }
    
    @objc func likeRestaurantMenuToggle() {
        
        guard let url = URL(string: "\(URLs.hostEndPoint)\((menu?.urls?.apiLike)!)") else { return }
        let params: Parameters = ["menu": "\((menu?.id)!)"]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue(self.session.token!, forHTTPHeaderField: "AUTHORIZATION")
        request.setValue(self.session.token!, forHTTPHeaderField: "AUTHORIZATION")
        
        let boundary = Requests().generateBoundary()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let httpBody = Requests().createDataBody(withParameters: params, media: nil, boundary: boundary)
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request){ (data, response, error) in
            if response != nil {}
            if let data = data {
                do {
                    let serverResponse = try JSONDecoder().decode(ServerResponse.self, from: data)
                    if serverResponse.type == "success" {
                        DispatchQueue.main.async {
                            Toast.makeToast(message: serverResponse.message, duration: Toast.MID_LENGTH_DURATION, style: .success)
                            if serverResponse.message.contains("Disliked") {
                                self.restaurantLikeImage.image =  UIImage(named: "icon_heart_like_32_gray")
                            } else { self.restaurantLikeImage.image =  UIImage(named: "icon_heart_like_32_primary") }
                        }
                    } else {
                        DispatchQueue.main.async {
                            Toast.makeToast(message: serverResponse.message, duration: Toast.MID_LENGTH_DURATION, style: .error)
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        Toast.makeToast(message: error.localizedDescription, duration: Toast.MID_LENGTH_DURATION, style: .error)
                    }
                }
            }
        }.resume()
    }
    
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool) {
        likeRestaurantMenuToggle()
    }
    
    func color(_ rgbColor: Int) -> UIColor {
        return UIColor(
            red:   CGFloat((rgbColor & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbColor & 0x00FF00) >> 8 ) / 255.0,
            blue:  CGFloat((rgbColor & 0x0000FF) >> 0 ) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func faveButtonDotColors(_ faveButton: FaveButton) -> [DotColors]? {
        return [
            DotColors(first: color(0x7DC2F4), second: color(0xE2264D)),
            DotColors(first: color(0xF8CC61), second: color(0x9BDFBA)),
            DotColors(first: color(0xAF90F4), second: color(0x90D1F9)),
            DotColors(first: color(0xE9A966), second: color(0xF8C852)),
            DotColors(first: color(0xF68FA7), second: color(0xF6A2B8))
        ]
    }
    
    @objc func openRestaurantMap() {
        if let window = UIApplication.shared.keyWindow {
            if var branch = self.menu?.menu?.branch, let location = self.selectedLocation {
                let branchLocation = CLLocation(latitude: CLLocationDegrees(Double(branch.latitude)!), longitude: CLLocationDegrees(Double(branch.longitude)!))
                branch.dist = Double(branchLocation.distance(from: location) / 1000).rounded(toPlaces: 2)
                isMapOpened = true
                window.windowLevel = UIWindow.Level.statusBar
                mapView.frame = window.frame
                mapView.center = window.center
                mapView.mapCenter = branchLocation
                mapView.selectedLocation = location
                mapView.restaurant = branch
                window.addSubview(mapView)
            }
        }
    }
    
    @objc func closeRestaurantMap(){
        UIApplication.shared.keyWindow?.windowLevel = UIWindow.Level.normal
        mapView.closeImageView.removeFromSuperview()
        mapView.closeButtonView.removeFromSuperview()
        mapView.removeFromSuperview()
        isMapOpened = false
        mapCenter = nil
    }
    
    @objc func navigateToRestaurant(_ sender: Any?) {
        if let branch = self.menu?.menu?.branch {
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let restaurantViewController = storyboard.instantiateViewController(withIdentifier: "RestaurantView") as! RestaurantViewController
            restaurantViewController.restaurant = branch
            self.parentController?.navigationController?.pushViewController(restaurantViewController, animated: true)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
