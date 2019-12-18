//
//  RestaurantHeaderViewCell.swift
//  ting
//
//  Created by Christian Scott on 12/17/19.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit

class RestaurantHeaderViewCell: UICollectionViewCell {
    
    let numberFormatter = NumberFormatter()
    
    let coverView: UIView = {
        let view = UIView()
        if let window = UIApplication.shared.keyWindow {
            view.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: 120)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        view.setLinearGradientBackgroundColor(colorOne: Colors.colorPrimaryDark, colorTwo: Colors.colorPrimary)
        return view
    }()
    
    let profileImageView: UIImageView = {
        let view = UIImageView()
        view.frame = CGRect(x: 0, y: 0, width: 180, height: 180)
        view.layer.cornerRadius = view.frame.size.height / 2
        view.layer.masksToBounds = true
        view.layer.borderColor = Colors.colorWhite.cgColor
        view.layer.borderWidth = 4.0
        view.image = UIImage(named: "default_restaurant")
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let namesLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .center
        view.font = UIFont(name: "Poppins-SemiBold", size: 20)
        view.textColor = Colors.colorGray
        return view
    }()
    
    let addressLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .center
        view.font = UIFont(name: "Poppins-Regular", size: 13)
        view.textColor = Colors.colorGray
        return view
    }()
    
    let rateView: CosmosView = {
        let view = CosmosView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.rating = 3
        view.settings.updateOnTouch = false
        view.settings.fillMode = .full
        view.settings.starSize = 30
        view.starMargin = 2
        view.totalStars = 5
        view.settings.filledColor = Colors.colorYellowRate
        view.settings.filledBorderColor = Colors.colorYellowRate
        view.settings.emptyColor = Colors.colorVeryLightGray
        view.settings.emptyBorderColor = Colors.colorVeryLightGray
        return view
    }()
    
    let restaurantStatusView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let restaurantDistanceView: IconTextView = {
        let view = IconTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.iconAlpha = 0.4
        view.icon = UIImage(named: "icon_road_25_black")!
        view.text = "0.0 km"
        return view
    }()
    
    let restaurantTimeStatusView: IconTextView = {
        let view = IconTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.icon = UIImage(named: "icon_clock_25_white")!
        view.text = "Opening in 13 mins"
        view.textColor = Colors.colorWhite
        view.background = Colors.colorStatusTimeOrange
        return view
    }()
    
    var branch: Branch? {
        didSet {
            numberFormatter.numberStyle = .decimal
            if let branch = self.branch, let restaurant = self.branch?.restaurant {
                profileImageView.load(url: URL(string: "\(URLs.hostEndPoint)\(restaurant.logo)")!)
                namesLabel.text = "\(restaurant.name), \(branch.name)"
                addressLabel.text = branch.address
                rateView.rating = Double(branch.reviews?.average ?? 0)
                restaurantDistanceView.text = "\(numberFormatter.string(from: NSNumber(value: branch.dist ?? 0.00)) ?? "0.00") km"
                self.setTimeStatus()
            }
            self.setup()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private func setup(){
        
        restaurantStatusView.addSubview(restaurantDistanceView)
        restaurantStatusView.addSubview(restaurantTimeStatusView)
        
        restaurantStatusView.addConstraintsWithFormat(format: "H:[v0]-8-[v1]", views: restaurantDistanceView, restaurantTimeStatusView)
        restaurantStatusView.addConstraintsWithFormat(format: "V:|[v0(26)]|", views: restaurantDistanceView)
        restaurantStatusView.addConstraintsWithFormat(format: "V:|[v0(26)]|", views: restaurantTimeStatusView)
        
        addSubview(coverView)
        addSubview(profileImageView)
        addSubview(namesLabel)
        addSubview(addressLabel)
        addSubview(rateView)
        addSubview(restaurantStatusView)
        
        addConstraintsWithFormat(format: "H:|-0-[v0]-0-|", views: coverView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: coverView)
        
        addConstraintsWithFormat(format: "H:[v0(180)]", views: profileImageView)
        addConstraintsWithFormat(format: "V:|-20-[v0(180)]", views: profileImageView)
        addConstraint(NSLayoutConstraint.init(item: profileImageView, attribute: .centerX, relatedBy: .equal, toItem: coverView, attribute: .centerX, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: namesLabel, attribute: .top, relatedBy: .equal, toItem: profileImageView, attribute: .bottom, multiplier: 1, constant: 10))
        addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: namesLabel)
        addConstraintsWithFormat(format: "V:[v0(20)]", views: namesLabel)
        
        addConstraint(NSLayoutConstraint(item: addressLabel, attribute: .top, relatedBy: .equal, toItem: namesLabel, attribute: .bottom, multiplier: 1, constant: 5))
        addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: addressLabel)
        addConstraintsWithFormat(format: "V:[v0(20)]", views: addressLabel)
        
        addConstraint(NSLayoutConstraint(item: rateView, attribute: .top, relatedBy: .equal, toItem: addressLabel, attribute: .bottom, multiplier: 1, constant: 3))
        addConstraint(NSLayoutConstraint(item: rateView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraintsWithFormat(format: "H:[v0]", views: rateView)
        addConstraintsWithFormat(format: "V:[v0(30)]", views: rateView)
        
        addConstraint(NSLayoutConstraint(item: restaurantStatusView, attribute: .top, relatedBy: .equal, toItem: rateView, attribute: .bottom, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint(item: restaurantStatusView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraintsWithFormat(format: "H:[v0]", views: restaurantStatusView)
        addConstraintsWithFormat(format: "V:[v0(26)]", views: restaurantStatusView)
        
        if branch?.isAvailable ?? true { Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(setTimeStatus), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func setTimeStatus() {
        if let branch = self.branch {
            if branch.isAvailable {
                let timeStatus = Functions.statusWorkTime(open: branch.restaurant!.opening, close: branch.restaurant!.closing)
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
