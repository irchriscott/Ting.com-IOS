//
//  RestaurantMenuViewController.swift
//  ting
//
//  Created by Christian Scott on 05/11/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit
import MapKit
import ImageViewer

class RestaurantMenuViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, GalleryDisplacedViewsDataSource, GalleryItemsDataSource, GalleryItemsDelegate {
    
    struct DataImageItem {
        let imageView: UIImageView
        let galleryItem: GalleryItem
    }
    
    var imageItems:[DataImageItem] = []
    
    private var imageIndex: Int = 0
    private let headerIdImage = "headerIdImage"
    private let cellIdMenuDetails = "cellIdMenuDetails"
    
    private let cellIdDefault = "cellId"
    private let headerIdDefault = "headerId"
    
    var restaurantMenu: RestaurantMenu? {
        didSet {
            if let menu = self.restaurantMenu {
                let images = menu.menu?.images?.images
                self.imageIndex = Int.random(in: 0...images!.count - 1)
            }
        }
    }
    
    var controller: HomeRestaurantsViewController? {
        didSet {}
    }
    
    lazy var restaurantDetailsView: UICollectionView = {
        let layout =  UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = Colors.colorWhite
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        view.tag = 1
        return view
    }()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setupNavigationBar()
        self.loadRestaurantMenu()
        
        if let menu = self.restaurantMenu {
            let images = menu.menu?.images?.images
            self.imageIndex = Int.random(in: 0...images!.count - 1)
            
            for image in images! {
                let imageView = UIImageView()
                imageView.load(url: URL(string: "\(URLs.hostEndPoint)\(image.image)")!)
                
                let galleryItem = GalleryItem.image { $0(imageView.image ?? UIImage(named: "default_meal")!) }
                imageItems.append(DataImageItem(imageView: imageView, galleryItem: galleryItem))
            }
        }
        
        self.restaurantDetailsView.register(RestaurantMenuHeaderImageViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: self.headerIdImage)
        self.restaurantDetailsView.register(MenuDetailsViewCell.self, forCellWithReuseIdentifier: self.cellIdMenuDetails)
        self.restaurantDetailsView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.cellIdDefault)
        
        self.view.addSubview(restaurantDetailsView)
        
        self.view.addConstraintsWithFormat(format: "H:|[v0]|", views: restaurantDetailsView)
        self.view.addConstraintsWithFormat(format: "V:|[v0]|", views: restaurantDetailsView)
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
        self.navigationItem.title = "Restaurant Menu"
        
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
    
    private func loadRestaurantMenu(){
        if let menu = self.restaurantMenu {
            APIDataProvider.instance.getRestaurantmenu(url: "\(URLs.hostEndPoint)\((menu.urls?.apiGet)!)") { (restoMenu) in
                DispatchQueue.main.async {
                    self.restaurantMenu = restoMenu
                    self.restaurantDetailsView.reloadData()
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupNavigationBar()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case self.restaurantDetailsView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdMenuDetails, for: indexPath) as! MenuDetailsViewCell
            cell.menu = self.restaurantMenu
            return cell
        default:
            return collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdDefault, for: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch collectionView {
        case self.restaurantDetailsView:
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headerIdImage, for: indexPath) as! RestaurantMenuHeaderImageViewCell
            if let menu = self.restaurantMenu {
                let images = menu.menu?.images?.images
                let image = images![self.imageIndex]
                cell.imageURL = "\(URLs.hostEndPoint)\(image.image)"
            }
            
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RestaurantMenuViewController.openMenuImages(_:))))
            
            return cell
        default:
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headerIdDefault, for: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch collectionView {
        case self.restaurantDetailsView:
            return CGSize(width: self.view.frame.width, height: 320)
        default:
            return CGSize(width: self.view.frame.width, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case self.restaurantDetailsView:
            return CGSize(width: self.view.frame.width, height: 380)
        default:
            return CGSize(width: self.view.frame.width, height: 0)
        }
    }
    
    func provideDisplacementItem(atIndex index: Int) -> DisplaceableView? {
        return index < imageItems.count ? imageItems[index].imageView as? DisplaceableView : nil
    }
    
    func itemCount() -> Int {
        return imageItems.count
    }
    
    func provideGalleryItem(_ index: Int) -> GalleryItem {
        return imageItems[index].galleryItem
    }
    
    func removeGalleryItem(at index: Int) {}
    
    func galleryConfiguration() -> GalleryConfiguration {

        return [

            GalleryConfigurationItem.closeButtonMode(.builtIn),

            GalleryConfigurationItem.pagingMode(.standard),
            GalleryConfigurationItem.presentationStyle(.displacement),
            GalleryConfigurationItem.hideDecorationViewsOnLaunch(false),

            GalleryConfigurationItem.swipeToDismissMode(.vertical),
            GalleryConfigurationItem.toggleDecorationViewsBySingleTap(false),
            GalleryConfigurationItem.activityViewByLongPress(false),

            GalleryConfigurationItem.overlayColor(UIColor(white: 0.035, alpha: 1)),
            GalleryConfigurationItem.overlayColorOpacity(1),
            GalleryConfigurationItem.overlayBlurOpacity(1),
            GalleryConfigurationItem.overlayBlurStyle(UIBlurEffect.Style.light),
            
            GalleryConfigurationItem.videoControlsColor(.white),

            GalleryConfigurationItem.maximumZoomScale(8),
            GalleryConfigurationItem.swipeToDismissThresholdVelocity(500),

            GalleryConfigurationItem.doubleTapToZoomDuration(0.15),

            GalleryConfigurationItem.blurPresentDuration(0.5),
            GalleryConfigurationItem.blurPresentDelay(0),
            GalleryConfigurationItem.colorPresentDuration(0.25),
            GalleryConfigurationItem.colorPresentDelay(0),

            GalleryConfigurationItem.blurDismissDuration(0.1),
            GalleryConfigurationItem.blurDismissDelay(0.4),
            GalleryConfigurationItem.colorDismissDuration(0.45),
            GalleryConfigurationItem.colorDismissDelay(0),

            GalleryConfigurationItem.itemFadeDuration(0.3),
            GalleryConfigurationItem.decorationViewsFadeDuration(0.15),
            GalleryConfigurationItem.rotationDuration(0.15),

            GalleryConfigurationItem.displacementDuration(0.55),
            GalleryConfigurationItem.reverseDisplacementDuration(0.25),
            GalleryConfigurationItem.displacementTransitionStyle(.springBounce(0.7)),
            GalleryConfigurationItem.displacementTimingCurve(.linear),

            GalleryConfigurationItem.statusBarHidden(true),
            GalleryConfigurationItem.displacementKeepOriginalInPlace(false),
            GalleryConfigurationItem.displacementInsetMargin(50),
            
            GalleryConfigurationItem.thumbnailsButtonMode(.none),
            GalleryConfigurationItem.deleteButtonMode(.none)
        ]
    }
    
    @objc func openMenuImages(_ sender: UITapGestureRecognizer){
        
        let galleryViewController = GalleryViewController(startIndex: self.imageIndex, itemsDataSource: self, itemsDelegate: self, displacedViewsDataSource: self, configuration: galleryConfiguration())

        galleryViewController.launchedCompletion = {  }
        galleryViewController.closedCompletion = {  }
        galleryViewController.swipedToDismissCompletion = {  }
        galleryViewController.landedPageAtIndexCompletion = { index in }
        
        self.presentImageGallery(galleryViewController)
    }
}

class RestaurantMenuHeaderImageViewCell: UICollectionViewCell {
    
    let menuImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "default_meal")
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    open var imageURL: String? {
        didSet { self.setup() }
    }
    
    private func setup(){
        menuImageView.load(url: URL(string: self.imageURL!)!)
        addSubview(menuImageView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: menuImageView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: menuImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MenuDetailsViewCell: UICollectionViewCell, CLLocationManagerDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    let numberFormatter = NumberFormatter()
    
    var restaurantMenuNameHeight: CGFloat = 28
    var restaurantMenuDescriptionHeight: CGFloat = 16
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
    
    lazy var mapView: RestaurantMapView = {
        let view = RestaurantMapView()
        //view.controller = self
        //view.restaurant = self.selectedBranch
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
                    self.restaurantMenuGroupView.alpha = 0.4
                    self.restaurantMenuGroupView.text = (menu.type?.name)!
                    
                    self.restaurantMenuTypeView.icon = UIImage(named: "icon_clock_25_black")!
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
                    
                    self.selectedLocation = CLLocation(latitude: latitude!, longitude: longitude!)
                }
            }
            self.setup()
        }
    }
    
    private func setup(){
        restaurantMenuDescriptionView.addSubview(restaurantMenuDescriptionIcon)
        restaurantMenuDescriptionView.addSubview(restaurantMenuDescriptionText)
        
        restaurantMenuDescriptionText.font = UIFont(name: "Poppins-Regular", size: restaurantDescriptionTextSize)
        
        restaurantMenuDescriptionView.addConstraintsWithFormat(format: "H:|[v0(14)]-8-[v1]|", views: restaurantMenuDescriptionIcon, restaurantMenuDescriptionText)
        restaurantMenuDescriptionView.addConstraintsWithFormat(format: "V:|[v0(14)]", views: restaurantMenuDescriptionIcon)
        restaurantMenuDescriptionView.addConstraintsWithFormat(format: "V:|[v0(\(restaurantMenuDescriptionHeight))]", views: restaurantMenuDescriptionText)
        
        if menu?.type?.id != 2 {
            restaurantMenuView.addSubview(restaurantMenuCategoryView)
        }
        
        restaurantMenuView.addSubview(restaurantMenuGroupView)
        restaurantMenuView.addSubview(restaurantMenuTypeView)
        
        if menu?.type?.id != 2 {
            restaurantMenuView.addConstraintsWithFormat(format: "H:|[v0]-8-[v1]-8-[v2]", views: restaurantMenuCategoryView, restaurantMenuGroupView, restaurantMenuTypeView)
        } else {
            restaurantMenuView.addConstraintsWithFormat(format: "H:|[v0]-8-[v1]", views: restaurantMenuGroupView, restaurantMenuTypeView)
        }
        
        if menu?.type?.id != 2 {
            restaurantMenuView.addConstraintsWithFormat(format: "V:|[v0(26)]|", views: restaurantMenuCategoryView)
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
        
        var menuPriceHeight: Int = 16
        
        if let menu = self.menu {
            
            if Double((menu.menu?.price)!) != Double((menu.menu?.lastPrice)!) {
                restaurantMenuPriceView.addSubview(restaurantMenuLastPriceTextView)
                restaurantMenuPriceView.addConstraintsWithFormat(format: "H:|-8-[v0]", views: restaurantMenuLastPriceTextView)
            }
            
            if (menu.menu?.isCountable)! && Double((menu.menu?.price)!) != Double((menu.menu?.lastPrice)!) {
                restaurantMenuPriceView.addConstraintsWithFormat(format: "V:|[v0]-4-[v1]-4-[v2]|", views: restaurantMenuQuantityTextView, restaurantMenuPriceTextView, restaurantMenuLastPriceTextView)
                menuPriceHeight += 45
            } else if !(menu.menu?.isCountable)! && Double((menu.menu?.price)!) != Double((menu.menu?.lastPrice)!) {
                restaurantMenuPriceView.addConstraintsWithFormat(format: "V:|[v0]-4-[v1]|", views: restaurantMenuPriceTextView, restaurantMenuLastPriceTextView)
                menuPriceHeight += 38
            } else if (menu.menu?.isCountable)! && !(Double((menu.menu?.price)!) != Double((menu.menu?.lastPrice)!)){
                restaurantMenuPriceView.addConstraintsWithFormat(format: "V:|[v0]-4-[v1]|", views: restaurantMenuQuantityTextView, restaurantMenuPriceTextView)
                menuPriceHeight += 35
            } else {
                restaurantMenuPriceView.addConstraintsWithFormat(format: "V:|[v0]|", views: restaurantMenuPriceTextView)
                menuPriceHeight += 25
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
        addSubview(separatorOne)
        addSubview(restaurantMenuPriceView)
        addSubview(separatorTwo)
        addSubview(restaurantMenuDataView)
        addSubview(separatorThree)
        addSubview(restaurantDataView)
        
        addConstraintsWithFormat(format: "H:|-8-[v0]", views: menuNameTextView)
        addConstraintsWithFormat(format: "H:|-8-[v0]", views: restaurantMenuRating)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: restaurantMenuDescriptionView)
        addConstraintsWithFormat(format: "H:|-8-[v0]", views: restaurantMenuView)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: separatorOne)
        addConstraintsWithFormat(format: "H:|-8-[v0]", views: restaurantMenuPriceView)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: separatorTwo)
        addConstraintsWithFormat(format: "H:|-8-[v0]", views: restaurantMenuDataView)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: separatorThree)
        addConstraintsWithFormat(format: "H:|-8-[v0]", views: restaurantDataView)
        
        addConstraintsWithFormat(format: "V:|-8-[v0(\(restaurantMenuNameHeight - 5))]-8-[v1]-8-[v2(\(restaurantMenuDescriptionHeight))]-8-[v3(26)]-8-[v4(0.5)]-8-[v5(\(menuPriceHeight))]-8-[v6(0.5)]-8-[v7(26)]-8-[v8(0.5)]-8-[v9(60)]", views: menuNameTextView, restaurantMenuRating, restaurantMenuDescriptionView, restaurantMenuView, separatorOne, restaurantMenuPriceView, separatorTwo, restaurantMenuDataView, separatorThree, restaurantDataView)
    }
    
    @objc private func setTimeStatus(){
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

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
