//
//  BottomSheetMenuControllerView.swift
//  ting
//
//  Created by Christian Scott on 21/09/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit
import FittedSheets

class BottomSheetMenuControllerView: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var imageIndex = 0
    
    var menu: RestaurantMenu? {
        didSet {
            if let menu = self.menu {
                let images = menu.menu?.images?.images
                self.imageIndex = Int.random(in: 0...images!.count - 1)
            }
        }
    }
    
    var controller: HomeRestaurantsViewController?
    
    let cellId = "cellId"
    let headerId = "headerId"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.colorWhite
        self.sheetViewController!.handleScrollView(self.collectionView)
        
        if let menu = self.menu {
            let images = menu.menu?.images?.images
            self.imageIndex = Int.random(in: 0...images!.count - 1)
        }
        
        self.collectionView.register(BottomSheetMenuHeaderViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: self.headerId)
        self.collectionView.register(BottomSheetMenuViewCell.self, forCellWithReuseIdentifier: self.cellId)
        
        self.collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(BottomSheetMenuControllerView.navigateToRestaurantMenu)))
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! BottomSheetMenuViewCell
        cell.menu = self.menu
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headerId, for: indexPath) as! BottomSheetMenuHeaderViewCell
        cell.menu = self.menu
        cell.imageIndex = self.imageIndex
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 320)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 300)
    }
    
    @objc func navigateToRestaurantMenu(){
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let menuController = storyboard.instantiateViewController(withIdentifier: "RestaurantMenuView") as! RestaurantMenuViewController
        menuController.restaurantMenu = self.menu
        menuController.controller = self.controller
        self.sheetViewController?.closeSheet(completion: {
            self.controller?.navigationController?.pushViewController(menuController, animated: true)
        })
    }
}

class BottomSheetMenuHeaderViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    let titleTextView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-Regular", size: 17)
        view.text = "Restaurant Menu".uppercased()
        view.textColor = Colors.colorGray
        return view
    }()
    
    let menuImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5.0
        view.layer.masksToBounds = true
        view.image = UIImage(named: "default_meal")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    open var imageIndex: Int = 0 {
        didSet { self.setup() }
    }
    
    var menu: RestaurantMenu? {
        didSet {
            if let menu = self.menu {
                self.setup()
                let images = menu.menu?.images?.images
                let image = images![self.imageIndex]
                self.menuImageView.load(url: URL(string: "\(URLs.hostEndPoint)\(image.image)")!)
            }
        }
    }
    
    private func setup(){
        addSubview(titleTextView)
        addSubview(menuImageView)
        
        addConstraintsWithFormat(format: "H:|-8-[v0]", views: titleTextView)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: menuImageView)
        addConstraintsWithFormat(format: "V:|-8-[v0]-8-[v1]-8-|", views: titleTextView, menuImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BottomSheetMenuViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    let numberFormatter = NumberFormatter()
    
    var restaurantMenuNameHeight: CGFloat = 25
    var restaurantMenuDescriptionHeight: CGFloat = 16
    let device = UIDevice.type
    
    var restaurantMenuNameTextSize: CGFloat = 16
    var restaurantDescriptionTextSize: CGFloat = 13
    
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
        view.numberOfLines = 0
        view.sizeToFit()
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
                    restaurantMenuNameTextSize = 14
                    restaurantDescriptionTextSize = 12
                } else if UIDevice.mediumDevices.contains(device) {
                    restaurantMenuNameTextSize = 15
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
                
                let menuDescriptionRect = NSString(string: (menu.menu?.description!)!).boundingRect(with: CGSize(width: frameWidth - 22, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: restaurantMenuNameTextSize)!], context: nil)
                
                restaurantMenuNameHeight = menuNameRect.height
                restaurantMenuDescriptionHeight = menuDescriptionRect.height
            }
            self.setup()
        }
    }
    
    private func setup(){
        restaurantMenuDescriptionView.addSubview(restaurantMenuDescriptionIcon)
        restaurantMenuDescriptionView.addSubview(restaurantMenuDescriptionText)
        
        restaurantMenuDescriptionText.font = UIFont(name: "Poppins-Regular", size: restaurantDescriptionTextSize)
        restaurantMenuDescriptionText.sizeToFit()
        
        restaurantMenuDescriptionView.addConstraintsWithFormat(format: "H:|[v0(14)]-8-[v1]|", views: restaurantMenuDescriptionIcon, restaurantMenuDescriptionText)
        restaurantMenuDescriptionView.addConstraintsWithFormat(format: "V:|[v0(14)]", views: restaurantMenuDescriptionIcon)
        restaurantMenuDescriptionView.addConstraintsWithFormat(format: "V:|[v0(\(restaurantMenuDescriptionHeight - 10))]", views: restaurantMenuDescriptionText)
        
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
        
        addSubview(menuNameTextView)
        addSubview(restaurantMenuRating)
        addSubview(restaurantMenuDescriptionView)
        addSubview(restaurantMenuView)
        addSubview(separatorOne)
        addSubview(restaurantMenuPriceView)
        addSubview(separatorTwo)
        addSubview(restaurantMenuDataView)
        
        addConstraintsWithFormat(format: "H:|-8-[v0]", views: menuNameTextView)
        addConstraintsWithFormat(format: "H:|-8-[v0]", views: restaurantMenuRating)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: restaurantMenuDescriptionView)
        addConstraintsWithFormat(format: "H:|-8-[v0]", views: restaurantMenuView)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: separatorOne)
        addConstraintsWithFormat(format: "H:|-8-[v0]", views: restaurantMenuPriceView)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: separatorTwo)
        addConstraintsWithFormat(format: "H:|-8-[v0]", views: restaurantMenuDataView)
        
        addConstraintsWithFormat(format: "V:|-8-[v0(\(restaurantMenuNameHeight - 10))]-8-[v1]-8-[v2(\(restaurantMenuDescriptionHeight - 10))]-8-[v3(26)]-8-[v4(0.5)]-8-[v5(\(menuPriceHeight))]-8-[v6(0.5)]-8-[v7(26)]", views: menuNameTextView, restaurantMenuRating, restaurantMenuDescriptionView, restaurantMenuView, separatorOne, restaurantMenuPriceView, separatorTwo, restaurantMenuDataView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
