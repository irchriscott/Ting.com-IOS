//
//  RestaurantMapInfoWindowView.swift
//  ting
//
//  Created by Christian Scott on 20/09/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit
import Kingfisher

class RestaurantMapInfoWindowView: UIView {
    
    let frameWidth = 220
    var restaurantAddressHeight: CGFloat = 16
    
    let restaurantImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.image = UIImage(named: "default_restaurant")
        return view
    }()
    
    let restaurantName: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Cafe Java"
        view.textColor = Colors.colorGray
        view.font = UIFont(name: "Poppins-SemiBold", size: 18)
        return view
    }()
    
    let restaurantBranch: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Nana Hostel Branch"
        view.textColor = Colors.colorGray
        view.font = UIFont(name: "Poppins-Regular", size: 15)
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
        view.text = "Nana Hostel, Kampala, Uganda"
        view.numberOfLines = 2
        return view
    }()
    
    let restaurantAddressView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.colorVeryLightGray
        return view
    }()
    
    let restaurantEmail: InlineIconTextView = {
        let view = InlineIconTextView()
        view.size = .small
        view.translatesAutoresizingMaskIntoConstraints = false
        view.icon = UIImage(named: "icon_mail_25_black")
        return view
    }()
    
    let restaurantPhone: InlineIconTextView = {
        let view = InlineIconTextView()
        view.size = .small
        view.translatesAutoresizingMaskIntoConstraints = false
        view.icon = UIImage(named: "icon_phone_25_black")
        return view
    }()
    
    let restaurantTime: InlineIconTextView = {
        let view = InlineIconTextView()
        view.size = .small
        view.translatesAutoresizingMaskIntoConstraints = false
        view.icon = UIImage(named: "icon_clock_25_black")
        return view
    }()
    
    var branch: Branch? {
        didSet {
            if let branch = self.branch {
                self.restaurantImage.kf.setImage(
                    with: URL(string: "\(URLs.hostEndPoint)\(branch.restaurant!.logo)")!,
                    placeholder: UIImage(named: "default_restaurant"),
                    options: [
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(1)),
                        .cacheOriginalImage
                    ]
                )
                
                self.restaurantName.text = branch.restaurant?.name
                self.restaurantBranch.text = branch.name
                self.restaurantAddress.text = branch.address
                self.restaurantEmail.text = branch.email
                self.restaurantPhone.text = branch.phone
                self.restaurantTime.text = "\(branch.restaurant!.opening) - \(branch.restaurant!.closing)"
                let branchAddressRect = NSString(string: branch.address).boundingRect(with: CGSize(width: frameWidth - 18, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 13)!], context: nil)
                restaurantAddressHeight = branchAddressRect.height
            }
            self.setup()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Colors.colorWhite
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }
    
    private func setup(){
        restaurantAddressView.addSubview(iconAddressImageView)
        restaurantAddressView.addSubview(restaurantAddress)
        
        restaurantAddressView.addConstraintsWithFormat(format: "H:|[v0(14)]-4-[v1]|", views: iconAddressImageView, restaurantAddress)
        restaurantAddressView.addConstraintsWithFormat(format: "V:|[v0(14)]", views: iconAddressImageView)
        restaurantAddressView.addConstraintsWithFormat(format: "V:|[v0(\(restaurantAddressHeight))]", views: restaurantAddress)
        
        addSubview(restaurantImage)
        addSubview(restaurantName)
        addSubview(restaurantBranch)
        addSubview(restaurantAddressView)
        addSubview(separatorView)
        addSubview(restaurantEmail)
        addSubview(restaurantPhone)
        addSubview(restaurantTime)
        
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: restaurantImage)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: restaurantName)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: restaurantBranch)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: restaurantAddressView)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: separatorView)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: restaurantEmail)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: restaurantPhone)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: restaurantTime)
        
        addConstraintsWithFormat(format: "V:|-8-[v0(\(frameWidth))]-12-[v1]-0-[v2]-4-[v3(\(restaurantAddressHeight))]-12-[v4(1)]-12-[v5(16)]-6-[v6(16)]-6-[v7(16)]-14-|", views: restaurantImage, restaurantName, restaurantBranch, restaurantAddressView, separatorView, restaurantEmail, restaurantPhone, restaurantTime)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
