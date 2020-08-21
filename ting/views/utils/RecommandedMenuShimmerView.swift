//
//  RecommandedMenuShimmerView.swift
//  ting
//
//  Created by Christian Scott on 20/08/2020.
//  Copyright © 2020 Ir Christian Scott. All rights reserved.
//

import UIKit

class RecommandedMenuShimmerView: UIView {

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
        view.backgroundColor = Colors.colorVeryLightGray
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
    
    let restaurantAddress: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-Regular", size: 13)
        view.textColor = Colors.colorGray
        view.backgroundColor = Colors.colorVeryLightGray
        view.numberOfLines = 1
        view.backgroundColor = Colors.colorVeryLightGray
        return view
    }()
    
    let menuPrice: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-Medium", size: 20)
        view.textColor = Colors.colorGray
        view.backgroundColor = Colors.colorVeryLightGray
        return view
    }()
    
    let restaurantAddressView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    private func setup() {
        
        if UIDevice.smallDevices.contains(device) {
            restaurantMenuNameTextSize = 14
            restaurantAddressTextSize = 12
        } else if UIDevice.mediumDevices.contains(device) {
            restaurantMenuNameTextSize = 17
        }
        
        restaurantAddressView.addSubview(iconAddressImageView)
        restaurantAddressView.addSubview(restaurantAddress)
        
        restaurantAddress.font = UIFont(name: "Poppins-Regular", size: restaurantAddressTextSize)
        
        restaurantAddressView.addConstraintsWithFormat(format: "H:|[v0(14)]-4-[v1]|", views: iconAddressImageView, restaurantAddress)
        restaurantAddressView.addConstraintsWithFormat(format: "V:|[v0(14)]", views: iconAddressImageView)
        restaurantAddressView.addConstraintsWithFormat(format: "V:|[v0(\(restaurantAddressHeight))]", views: restaurantAddress)
        
        addSubview(menuImageView)
        addSubview(menuName)
        addSubview(menuRating)
        addSubview(restaurantAddressView)
        addSubview(menuPrice)
        
        menuName.font = UIFont(name: "Poppins-SemiBold", size: restaurantMenuNameTextSize)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: menuImageView)
        addConstraintsWithFormat(format: "H:|[v0(200)]", views: menuName)
        addConstraintsWithFormat(format: "H:|[v0]|", views: menuRating)
        addConstraintsWithFormat(format: "H:|[v0]|", views: restaurantAddressView)
        addConstraintsWithFormat(format: "H:|[v0(120)]", views: menuPrice)
        
        addConstraintsWithFormat(format: "V:|[v0(130)]-8-[v1(\(restaurantMenuNameHeight))]-2-[v2]-4-[v3(\(restaurantAddressHeight))]-8-[v4(30)]-|", views: menuImageView, menuName, menuRating, restaurantAddressView, menuPrice)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
