//
//  RestaurantLikeViewCell.swift
//  ting
//
//  Created by Christian Scott on 12/26/19.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit

class RestaurantLikeViewCell: UITableViewCell {

    var userNameHeight: CGFloat = 20
    var restaurantAddressHeight: CGFloat = 16
    let device = UIDevice.type
        
    let userNameTextSize: CGFloat = 14
    let restaurantAddressTextSize: CGFloat = 13
    let userImageConstant: CGFloat = 74
        
    let viewCell: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.layer.borderColor = Colors.colorVeryLightGray.cgColor
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
        
    let userImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        view.frame = CGRect(x: 0, y: 0, width: 74, height: 74)
        view.image = UIImage(named: "default_user")!
        view.contentMode = .scaleAspectFill
        return view
    }()
        
    let reviewView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    let userNameView: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Poppins-SemiBold", size: 14)
        view.textColor = Colors.colorGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "French Fries"
        view.numberOfLines = 2
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
        
    let reviewDateView: IconTextView = {
        let view = IconTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "May 22, 1998"
        view.alpha = 0.6
        view.textColor = Colors.colorDarkGray
        view.icon = UIImage(named: "icon_clock_25_black")!
        return view
    }()
    
    open var fromUser: Bool = false
        
    var like: UserRestaurant? {
        didSet {
            if let like = self.like {
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "MMM dd,yyyy"

                let date = dateFormatterGet.date(from: like.createdAt)
                reviewDateView.text = dateFormatterPrint.string(from: date!)
                        
                let frameWidth = frame.width - (60 + userImageConstant)
                
                if self.fromUser {
                    if let branch = like.branch, let restaurant = like.branch?.restaurant {
                        userImageView.load(url: URL(string: "\(URLs.hostEndPoint)\(restaurant.logo)")!)
                        userNameView.text = "\(restaurant.name), \(branch.name)"
                        restaurantAddress.text = branch.address
                        let userNameRect = NSString(string: "\(restaurant.name), \(branch.name)").boundingRect(with: CGSize(width: frameWidth, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: userNameTextSize)!], context: nil)
                            
                        let addressRect = NSString(string: branch.address).boundingRect(with: CGSize(width: frameWidth, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: restaurantAddressTextSize)!], context: nil)
                            
                        restaurantAddressHeight = addressRect.height
                        userNameHeight = userNameRect.height
                    }
                } else {
                    if let user = like.user {
                        userImageView.load(url: URL(string: "\(URLs.uploadEndPoint)\(user.image)")!)
                        userNameView.text = user.name
                        restaurantAddress.text = "\(user.town), \(user.country)"
                        let userNameRect = NSString(string: user.name).boundingRect(with: CGSize(width: frameWidth, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: userNameTextSize)!], context: nil)
                            
                        let addressRect = NSString(string: "\(user.town), \(user.country)").boundingRect(with: CGSize(width: frameWidth, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: restaurantAddressTextSize)!], context: nil)
                            
                        restaurantAddressHeight = addressRect.height
                        userNameHeight = userNameRect.height
                    }
                }
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
        
        restaurantAddressView.addSubview(iconAddressImageView)
        restaurantAddressView.addSubview(restaurantAddress)
            
        restaurantAddress.font = UIFont(name: "Poppins-Regular", size: restaurantAddressTextSize)
        
        restaurantAddressView.addConstraintsWithFormat(format: "H:|[v0(14)]-4-[v1]|", views: iconAddressImageView, restaurantAddress)
        restaurantAddressView.addConstraintsWithFormat(format: "V:|[v0(14)]", views: iconAddressImageView)
        restaurantAddressView.addConstraintsWithFormat(format: "V:|[v0(\(restaurantAddressHeight))]", views: restaurantAddress)
            
        reviewView.addSubview(userNameView)
        reviewView.addSubview(restaurantAddressView)
        reviewView.addSubview(reviewDateView)
            
        reviewView.addConstraintsWithFormat(format: "H:|[v0]|", views: userNameView)
        reviewView.addConstraintsWithFormat(format: "H:|[v0]", views: reviewDateView)
        reviewView.addConstraintsWithFormat(format: "V:|[v0(\(userNameHeight))]-0-[v1(\(restaurantAddressHeight))]-4-[v2(26)]-12-|", views: userNameView, restaurantAddressView, reviewDateView)
            
        viewCell.addSubview(userImageView)
        viewCell.addSubview(reviewView)
            
        viewCell.addConstraintsWithFormat(format: "H:|-12-[v0(\(userImageConstant))]-12-[v1]-12-|", views: userImageView, reviewView)
        viewCell.addConstraintsWithFormat(format: "V:|-12-[v0(\(userImageConstant))]", views: userImageView)
        viewCell.addConstraintsWithFormat(format: "V:|-12-[v0(\(4 + 26 + 12 + restaurantAddressHeight + userNameHeight))]-12-|", views: reviewView)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
