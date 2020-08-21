//
//  PromotionMenuDetailsViewCell.swift
//  ting
//
//  Created by Christian Scott on 12/16/19.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit
import MapKit
import FittedSheets
import FaveButton

class PromotionMenuDetailsViewCell: UICollectionViewCell, CLLocationManagerDelegate, FaveButtonDelegate {
    
    let numberFormatter = NumberFormatter()
    
    var promotionOccasionHeight: CGFloat = 28
    var promotionPeriodHeight: CGFloat = 15
    var promotionReductionHeight: CGFloat = 0
    var promotionSupplementHeight: CGFloat = 0
    let device = UIDevice.type
    
    var promotionOccationTextSize: CGFloat = 20
    let promotionTextSize: CGFloat = 13
    
    var locationManager = CLLocationManager()
    var selectedLocation: CLLocation?
    
    let session = UserAuthentication().get()!
    var isMapOpened: Bool = false
    var mapCenter: CLLocation?
    
    let promotionMenuView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var promotionOccationView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-SemiBold", size: self.promotionOccationTextSize)
        view.textColor = Colors.colorGray
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
    
    let promotionAvailabilityView: IconTextView = {
        let view = IconTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.icon = UIImage(named: "icon_check_white_25")!
        view.text = "Is On Today"
        view.textColor = Colors.colorWhite
        view.background = Colors.colorStatusTimeGreen
        return view
    }()
    
    let promotionInterestView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        view.layer.cornerRadius = 23
        view.layer.masksToBounds = true
        view.backgroundColor = Colors.colorDarkTransparent
        return view
    }()
    
    let promotionInterestImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "icon_star_outline_25_gray")
        return view
    }()
    
    lazy var faveButtonInterest: FaveButton = {
        let view = FaveButton(frame: CGRect(x: 0, y: 0, width: 28, height: 28), faveIconNormal: UIImage(named: "icon_star_filled_25_gray"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.selectedColor = Colors.colorPrimary
        view.normalColor = Colors.colorGray
        return view
    }()
    
    let separatorZero: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.colorVeryLightGray
        return view
    }()
    
    let promotionAboutView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
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
    
    let separatorOne: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.colorVeryLightGray
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
    
    let promotionDateView: IconTextView = {
        let view = IconTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "July 25th 2019"
        view.iconAlpha = 0.4
        view.icon = UIImage(named: "icon_clock_25_black")!
        return view
    }()
    
    let separatorTwo: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.colorVeryLightGray
        return view
    }()
    
    let promotionDescriptionView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-Medium", size: 14)
        view.text = "Description".uppercased()
        view.textColor = Colors.colorGray
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
    
    var controller: UIViewController? {
        didSet {}
    }
    
    var parentController: PromotionMenuViewController? {
        didSet {}
    }
    
    var promotion: MenuPromotion? {
        didSet {
            numberFormatter.numberStyle = .decimal
            if let promotion = self.promotion {
                promotionOccationView.text = promotion.occasionEvent
                promotionOnView.text = promotion.promotionItem.type.name
                
                if promotion.promotionItem.category != nil && promotion.promotionItem.type.id == "05" {
                    promotionCategoryView.text = "Promotion On \((promotion.promotionItem.category?.name)!)"
                    promotionCategoryView.imageURL = "\(URLs.hostEndPoint)\((promotion.promotionItem.category?.image)!)"
                }
                
                if promotion.promotionItem.menu != nil && promotion.promotionItem.type.id == "04" {
                    if let menu = promotion.promotionItem.menu {
                        let images = menu.menu?.images?.images
                        let imageIndex = Int.random(in: 0...images!.count - 1)
                        let image = images![imageIndex]
                        promotionCategoryView.imageURL = "\(URLs.hostEndPoint)\(image.image)"
                        promotionCategoryView.text = "Promotion On \((menu.menu?.name)!)"
                        promotionCategoryView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navigatePromotedMenu(_:))))
                    }
                }
                
                if UIDevice.smallDevices.contains(device) {
                    promotionOccationTextSize = 15
                } else if UIDevice.mediumDevices.contains(device) {
                    promotionOccationTextSize = 17
                }
                
                let frameWidth = frame.width - 20
                
                promotionPeriodView.text = promotion.period
                
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
                
                if let branch = promotion.branch, let restaurant = promotion.restaurant {
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
                
                let interests = promotion.interests.interests
                if interests.contains(session.id) {
                    promotionInterestImage.image =  UIImage(named: "icon_star_filled_25_gray")
                }
                
                self.setRestaurantDistance()
            }
            self.setup()
        }
    }
    
    var mapView: RestaurantMapViewController!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.promotionInterestView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PromotionMenuDetailsViewCell.interestPromotionToggle)))
        self.restaurantName.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navigateToRestaurant(_:))))
        self.restaurantDistanceView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(PromotionMenuDetailsViewCell.showUserAddresses)))
        self.restaurantDistanceView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openRestaurantMap)))
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.checkLocationAuthorization(status: CLLocationManager.authorizationStatus())
    }
    
    private func setup() {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        mapView = storyboard.instantiateViewController(withIdentifier: "RestaurantMapView") as? RestaurantMapViewController
        mapView.controller = self.controller
        mapView.restaurant = self.promotion?.branch
        mapView.modalPresentationStyle = .overFullScreen
        
        self.mapView.closeButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeRestaurantMap)))
        
        promotionInterestView.addSubview(faveButtonInterest)
        promotionInterestView.addConstraintsWithFormat(format: "H:[v0(28)]", views: faveButtonInterest)
        promotionInterestView.addConstraintsWithFormat(format: "V:[v0(28)]", views: faveButtonInterest)
        promotionInterestView.addConstraint(NSLayoutConstraint(item: promotionInterestView, attribute: .centerX, relatedBy: .equal, toItem: faveButtonInterest, attribute: .centerX, multiplier: 1, constant: 0))
        promotionInterestView.addConstraint(NSLayoutConstraint(item: promotionInterestView, attribute: .centerY, relatedBy: .equal, toItem: faveButtonInterest, attribute: .centerY, multiplier: 1, constant: 0))
        
        if let interests = self.promotion?.interests.interests {
            if interests.contains(session.id) {
                faveButtonInterest.setSelected(selected: true, animated: true)
            }
        }
        
        promotionMenuView.addSubview(promotionOccationView)
        promotionMenuView.addSubview(promotionOnView)
        promotionMenuView.addSubview(promotionAvailabilityView)
        promotionMenuView.addSubview(promotionInterestView)
        
        promotionMenuView.addConstraintsWithFormat(format: "H:|[v0]", views: promotionOccationView)
        promotionMenuView.addConstraintsWithFormat(format: "H:|[v0]", views: promotionOnView)
        promotionMenuView.addConstraintsWithFormat(format: "H:|[v0]", views: promotionAvailabilityView)
        promotionMenuView.addConstraintsWithFormat(format: "H:[v0(46)]|", views: promotionInterestView)
        
        promotionMenuView.addConstraintsWithFormat(format: "V:|-4-[v0(46)]", views: promotionInterestView)
        
        var promotionMenuHeight = promotionOccasionHeight + 6 + 26 + 6 + 26 + 4
        
        if promotion?.promotionItem.type.id == "04" || promotion?.promotionItem.type.id == "05" {
            promotionMenuView.addSubview(promotionCategoryView)
            promotionMenuView.addConstraintsWithFormat(format: "H:|[v0]", views: promotionCategoryView)
            
            promotionMenuHeight += 32
            
            promotionMenuView.addConstraintsWithFormat(format: "V:|[v0(\(promotionOccasionHeight))]-6-[v1(26)]-6-[v2(26)]-6-[v3(26)]", views: promotionOccationView, promotionOnView, promotionCategoryView, promotionAvailabilityView)
        } else {
            promotionMenuView.addConstraintsWithFormat(format: "V:|[v0(\(promotionOccasionHeight))]-6-[v1(26)]-6-[v2(26)]", views: promotionOccationView, promotionOnView, promotionAvailabilityView)
        }
        
        promotionAboutView.addSubview(promotionPeriodView)
        
        if (promotion?.reduction.hasReduction)! {
            promotionAboutView.addSubview(promotionReductionView)
            promotionAboutView.addConstraintsWithFormat(format: "H:|[v0]|", views: promotionReductionView)
        }
        
        if (promotion?.supplement.hasSupplement)! {
            promotionAboutView.addSubview(promotionSupplementView)
            promotionAboutView.addConstraintsWithFormat(format: "H:|[v0]|", views: promotionSupplementView)
        }
        
        var promotionAboutHeight = promotionPeriodHeight + promotionReductionHeight + promotionSupplementHeight
        
        if (promotion?.reduction.hasReduction)! && (promotion?.supplement.hasSupplement)! {
            promotionAboutHeight += 10
            promotionAboutView.addConstraintsWithFormat(format: "V:|[v0(\(promotionPeriodHeight))]-4-[v1(\(promotionReductionHeight))]-4-[v2(\(promotionSupplementHeight))]", views: promotionPeriodView, promotionReductionView, promotionSupplementView)
        } else if (promotion?.reduction.hasReduction)! && !(promotion?.supplement.hasSupplement)! {
            promotionAboutHeight += 5
            promotionAboutView.addConstraintsWithFormat(format: "V:|[v0(\(promotionPeriodHeight))]-4-[v1(\(promotionReductionHeight))]", views: promotionPeriodView, promotionReductionView)
        } else if !(promotion?.reduction.hasReduction)! && (promotion?.supplement.hasSupplement)! {
            promotionAboutHeight += 5
            promotionAboutView.addConstraintsWithFormat(format: "V:|[v0(\(promotionPeriodHeight))]-4-[v1(\(promotionSupplementHeight))]", views: promotionPeriodView, promotionSupplementView)
        } else {
             promotionAboutView.addConstraintsWithFormat(format: "V:|[v0(\(promotionPeriodHeight))]", views: promotionPeriodView)
        }
        
        promotionDataView.addSubview(promotionDateView)
        promotionDataView.addSubview(promotionInterestsView)
        
        promotionDataView.addConstraintsWithFormat(format: "H:|[v0]-8-[v1]", views: promotionDateView, promotionInterestsView)
        promotionDataView.addConstraintsWithFormat(format: "V:|[v0(26)]|", views: promotionDateView)
        promotionDataView.addConstraintsWithFormat(format: "V:|[v0(26)]|", views: promotionInterestsView)
        
        restaurantDataView.addSubview(restaurantName)
        restaurantDataView.addSubview(restaurantDistanceView)
        restaurantDataView.addSubview(restaurantTimeStatusView)
        
        restaurantDataView.addConstraintsWithFormat(format: "H:|[v0]-8-[v1]", views: restaurantName, restaurantDistanceView)
        restaurantDataView.addConstraintsWithFormat(format: "H:|[v0]", views: restaurantTimeStatusView)
        restaurantDataView.addConstraintsWithFormat(format: "V:|[v0(26)]-8-[v1(26)]|", views: restaurantName, restaurantTimeStatusView)
        
        addSubview(promotionMenuView)
        addSubview(separatorZero)
        addSubview(promotionAboutView)
        addSubview(separatorOne)
        addSubview(promotionDescriptionView)
        addSubview(separatorTwo)
        addSubview(promotionDataView)
        addSubview(separatorThree)
        addSubview(restaurantDataView)
        addSubview(separatorFour)
        
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: promotionMenuView)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: separatorZero)
        addConstraintsWithFormat(format: "H:|-8-[v0]", views: promotionAboutView)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: separatorOne)
        addConstraintsWithFormat(format: "H:|-8-[v0]", views: promotionDescriptionView)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: separatorTwo)
        addConstraintsWithFormat(format: "H:|-8-[v0]", views: promotionDataView)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: separatorThree)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: restaurantDataView)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: separatorFour)
        
        addConstraintsWithFormat(format: "V:|-8-[v0(\(promotionMenuHeight))]-8-[v1(0.5)]-8-[v2(\(promotionAboutHeight))]-8-[v3(0.5)]-8-[v4(20)]-8-[v5(0.5)]-8-[v6(26)]-8-[v7(0.5)]-8-[v8(\(26 + 8 + 26))]-8-[v9(0.5)]", views: promotionMenuView, separatorZero, promotionAboutView, separatorOne, promotionDescriptionView, separatorTwo, promotionDataView, separatorThree, restaurantDataView, separatorFour)
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
        if let branch = self.promotion?.branch, let location = self.selectedLocation {
            let branchLocation = CLLocation(latitude: CLLocationDegrees(exactly: Double(branch.latitude)!)!, longitude: CLLocationDegrees(exactly: Double(branch.longitude)!)!)
            let distance = Double(branchLocation.distance(from: location) / 1000).rounded(toPlaces: 2)
            restaurantDistanceView.text = "\(numberFormatter.string(from: NSNumber(value: distance))!) km"
        } else if let branch = self.promotion?.branch {
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
        if let branch = self.promotion?.branch,  let restaurant = self.promotion?.restaurant {
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
    
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool) {
        interestPromotionToggle()
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
    
    @objc func interestPromotionToggle() {
        
        guard let url = URL(string: "\(URLs.hostEndPoint)\((promotion?.urls.apiInterest)!)") else { return }
        let params: Parameters = ["promo": "\((promotion?.id)!)"]
        
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
                            if serverResponse.message.contains("Not") {
                                self.promotionInterestImage.image =  UIImage(named: "icon_star_outline_25_gray")
                            } else { self.promotionInterestImage.image =  UIImage(named: "icon_star_filled_25_gray") }
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
    
    @objc func openRestaurantMap() {
        if let window = UIApplication.shared.keyWindow {
            if var branch = self.promotion?.branch, let location = self.selectedLocation {
                let branchLocation = CLLocation(latitude: CLLocationDegrees(Double(branch.latitude)!), longitude: CLLocationDegrees(Double(branch.longitude)!))
                branch.dist = Double(branchLocation.distance(from: location) / 1000).rounded(toPlaces: 2)
                isMapOpened = true
                window.windowLevel = UIWindow.Level.statusBar
                
                mapView.mapCenter = branchLocation
                mapView.selectedLocation = location
                mapView.restaurant = branch
                
                controller?.present(mapView, animated: true, completion: nil)
            }
        }
    }
    
    @objc func closeRestaurantMap(){
        UIApplication.shared.keyWindow?.windowLevel = UIWindow.Level.normal
        
        mapView.dismiss(animated: true, completion: nil)
        isMapOpened = false
        mapCenter = nil
    }
    
    @objc func navigatePromotedMenu(_ sender: Any?) {
        if promotion?.promotionItem.menu != nil && promotion?.promotionItem.type.id == "04" {
            if let menu = promotion?.promotionItem.menu {
                let storyboard = UIStoryboard(name: "Home", bundle: nil)
                let menuController = storyboard.instantiateViewController(withIdentifier: "RestaurantMenuBottomView") as! BottomSheetMenuControllerView
                menuController.menu = menu
                menuController.controller = self.parentController
                let sheetController = SheetViewController(controller: menuController, sizes: [.fixed(415), .fixed(640)])
                sheetController.blurBottomSafeArea = false
                sheetController.adjustForBottomSafeArea = true
                sheetController.topCornersRadius = 8
                sheetController.dismissOnBackgroundTap = true
                sheetController.extendBackgroundBehindHandle = false
                sheetController.willDismiss = {_ in }
                sheetController.didDismiss = {_ in }
                self.parentController?.present(sheetController, animated: false, completion: nil)
            }
        }
    }
    
    @objc func navigateToRestaurant(_ sender: Any?) {
        if let branch = promotion?.branch {
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
