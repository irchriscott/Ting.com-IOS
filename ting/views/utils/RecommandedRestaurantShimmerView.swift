//
//  RecommandedRestaurantShimmerView.swift
//  ting
//
//  Created by Christian Scott on 18/08/2020.
//  Copyright © 2020 Ir Christian Scott. All rights reserved.
//

import UIKit

class RecommandedRestaurantShimmerView: UIView {

    var restaurantNameHeight: CGFloat = 25
    var restaurantAddressHeight: CGFloat = 16
    let device = UIDevice.type
    
    var restaurantNameTextSize: CGFloat = 16
    var restaurantAddressTextSize: CGFloat = 13
    
    let restaurantImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        view.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        view.alpha = 0.4
        view.backgroundColor = Colors.colorVeryLightGray
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let restaurantName: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Poppins-SemiBold", size: 16)
        view.textColor = Colors.colorGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.colorVeryLightGray
        view.numberOfLines = 2
        return view
    }()
    
    let restaurantRating: CosmosView = {
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
        view.numberOfLines = 2
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
        restaurantAddressView.addSubview(iconAddressImageView)
        restaurantAddressView.addSubview(restaurantAddress)
        
        restaurantAddress.font = UIFont(name: "Poppins-Regular", size: restaurantAddressTextSize)
        
        restaurantAddressView.addConstraintsWithFormat(format: "H:|[v0(14)]-4-[v1]|", views: iconAddressImageView, restaurantAddress)
        restaurantAddressView.addConstraintsWithFormat(format: "V:|[v0(14)]", views: iconAddressImageView)
        restaurantAddressView.addConstraintsWithFormat(format: "V:|[v0(\(restaurantAddressHeight))]", views: restaurantAddress)
        
        addSubview(restaurantImageView)
        addSubview(restaurantName)
        addSubview(restaurantRating)
        addSubview(restaurantAddressView)
        
        restaurantName.font = UIFont(name: "Poppins-SemiBold", size: restaurantNameTextSize)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: restaurantImageView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: restaurantName)
        addConstraintsWithFormat(format: "H:|[v0]|", views: restaurantRating)
        addConstraintsWithFormat(format: "H:|[v0]|", views: restaurantAddressView)
        
        addConstraintsWithFormat(format: "V:|[v0(200)]-8-[v1(\(restaurantNameHeight))]-2-[v2]-4-[v3(\(restaurantAddressHeight))]", views: restaurantImageView, restaurantName, restaurantRating, restaurantAddressView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
