//
//  RecommandedMenuViewCell.swift
//  ting
//
//  Created by Christian Scott on 20/08/2020.
//  Copyright © 2020 Ir Christian Scott. All rights reserved.
//

import UIKit

class RecommandedMenuViewCell: UICollectionViewCell {
    
    let numberFormatter = NumberFormatter()
    
    var restaurantMenuNameHeight: CGFloat = 22
    var restaurantAddressHeight: CGFloat = 16
    let device = UIDevice.type
    
    var restaurantMenuNameTextSize: CGFloat = 15
    var restaurantAddressTextSize: CGFloat = 13
    
    let menuImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        view.frame = CGRect(x: 0, y: 0, width: 260, height: 130)
        view.backgroundColor = Colors.colorVeryLightGray
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let menuName: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Poppins-SemiBold", size: 15)
        view.textColor = Colors.colorGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 2
        return view
    }()
    
    let menuRating: CosmosView = {
        let view = CosmosView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.rating = 0
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
    
    let iconAddressImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = CGRect(x: 0, y: 0, width: 14, height: 14)
        view.image = UIImage(named: "icon_address_black")
        view.alpha = 0.5
        return view
    }()
    
    let restaurantName: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-Regular", size: 13)
        view.textColor = Colors.colorGray
        view.numberOfLines = 1
        return view
    }()
    
    let menuPrice: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-Medium", size: 20)
        view.textColor = Colors.colorGray
        return view
    }()
    
    let restaurantAddressView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var menu: RestaurantMenu? {
        didSet {
            numberFormatter.numberStyle = .decimal
            if let menu = self.menu {
                
                let images = menu.menu?.images?.images
                let imageIndex = Int.random(in: 0...images!.count - 1)
                let image = images![imageIndex]
                
                menuImageView.kf.setImage(
                    with: URL(string: "\(URLs.hostEndPoint)\(image.image)")!,
                    placeholder: UIImage(named: "default_meal"),
                    options: [
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(1)),
                        .cacheOriginalImage
                    ]
                )
                
                self.menuName.text = menu.menu?.name
                self.menuRating.rating = Double(menu.menu?.reviews?.average ?? 0)
                
                if UIDevice.smallDevices.contains(device) {
                    restaurantMenuNameTextSize = 14
                    restaurantAddressTextSize = 12
                } else if UIDevice.mediumDevices.contains(device) {
                    restaurantMenuNameTextSize = 17
                }
                
                menuPrice.text = "\((menu.menu?.currency)!) \(numberFormatter.string(from: NSNumber(value: Double((menu.menu?.price)!)!))!)"
                
                restaurantName.text = menu.restaurant?.name
                
                let menuNameRect = NSString(string: (menu.menu?.name!)!).boundingRect(with: CGSize(width: 230, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: restaurantMenuNameTextSize)!], context: nil)
                
                restaurantMenuNameHeight = menuNameRect.height
            }
            self.setup()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private func setup() {
        restaurantAddressView.addSubview(iconAddressImageView)
        restaurantAddressView.addSubview(restaurantName)
        
        restaurantName.font = UIFont(name: "Poppins-Regular", size: restaurantAddressTextSize)
        
        restaurantAddressView.addConstraintsWithFormat(format: "H:|[v0(14)]-4-[v1]|", views: iconAddressImageView, restaurantName)
        restaurantAddressView.addConstraintsWithFormat(format: "V:|[v0(14)]", views: iconAddressImageView)
        restaurantAddressView.addConstraintsWithFormat(format: "V:|[v0(\(restaurantAddressHeight))]", views: restaurantName)
        
        addSubview(menuImageView)
        addSubview(menuName)
        addSubview(menuRating)
        addSubview(restaurantAddressView)
        addSubview(menuPrice)
        
        menuName.font = UIFont(name: "Poppins-SemiBold", size: restaurantMenuNameTextSize)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: menuImageView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: menuName)
        addConstraintsWithFormat(format: "H:|[v0]|", views: menuRating)
        addConstraintsWithFormat(format: "H:|[v0]|", views: restaurantAddressView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: menuPrice)
        
        addConstraintsWithFormat(format: "V:|[v0(130)]-8-[v1(\(restaurantMenuNameHeight))]-2-[v2]-4-[v3(\(restaurantAddressHeight))]-8-[v4]", views: menuImageView, menuName, menuRating, restaurantAddressView, menuPrice)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
