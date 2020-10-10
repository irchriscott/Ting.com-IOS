//
//  MenuDishFoodViewCell.swift
//  ting
//
//  Created by Christian Scott on 11/10/19.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit

class MenuDishFoodViewCell: UITableViewCell {
    
    var menuNameHeight: CGFloat = 20
    var menuDescriptionHeight: CGFloat = 15
    let device = UIDevice.type
    
    var menuNameTextSize: CGFloat = 15
    var menuDescriptionTextSize: CGFloat = 13
    var menuImageConstant: CGFloat = 80
    
    let viewCell: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.layer.borderColor = Colors.colorVeryLightGray.cgColor
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    let menuImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        view.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        view.image = UIImage(named: "default_restaurant")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let menuAboutView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let menuNameView: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Poppins-SemiBold", size: 15)
        view.textColor = Colors.colorGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "French Fries"
        view.numberOfLines = 2
        return view
    }()
    
    let menuRating: CosmosView = {
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
    
    let menuDescriptionIconView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = CGRect(x: 0, y: 0, width: 14, height: 14)
        view.image = UIImage(named: "icon_align_left_25_gray")
        view.alpha = 0.5
        return view
    }()
    
    let menuDescriptionTextView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-Regular", size: 13)
        view.textColor = Colors.colorGray
        view.text = "Menu Description"
        view.numberOfLines = 3
        return view
    }()
    
    let menuDescriptionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let menuClassView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let menuGroupView: IconTextView = {
        let view = IconTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Food"
        view.icon = UIImage(named: "icon_spoon_25_gray")!
        return view
    }()
    
    let menuTypeView: IconTextView = {
        let view = IconTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Breakfast"
        view.icon = UIImage(named: "icon_folder_25_gray")!
        return view
    }()
    
    let menuAvailabilityView: IconTextView = {
        let view = IconTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.icon = UIImage(named: "icon_check_white_25")!
        view.text = "Available"
        view.textColor = Colors.colorWhite
        view.background = Colors.colorStatusTimeGreen
        return view
    }()
    
    var menuFood: MenuDishFood? {
        didSet {
            if let menu = self.menuFood {
                
                let images = menu.food.images?.images
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
                
                menuNameView.text = menu.food.name
                menuDescriptionTextView.text = menu.food.description
                menuTypeView.text = menu.food.foodType!
                menuRating.rating = (menu.food.reviews?.average)!
                
                if menu.food.isAvailable ?? true {
                    menuAvailabilityView.text = "Available"
                    menuAvailabilityView.icon = UIImage(named: "icon_check_white_25")!
                    menuAvailabilityView.background = Colors.colorStatusTimeGreen
                } else {
                    menuAvailabilityView.text = "Not Available"
                    menuAvailabilityView.icon = UIImage(named: "icon_close_25_white")!
                    menuAvailabilityView.background = Colors.colorStatusTimeRed
                }
                
                if UIDevice.smallDevices.contains(device) {
                    menuImageConstant = 55
                    menuNameTextSize = 14
                    menuDescriptionTextSize = 12
                } else if UIDevice.mediumDevices.contains(device) {
                    menuImageConstant = 70
                    menuNameTextSize = 15
                    menuDescriptionTextSize = 12
                }
                
                let frameWidth = frame.width - (60 + menuImageConstant)
                
                let menuNameRect = NSString(string: menu.food.name!).boundingRect(with: CGSize(width: frameWidth, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: menuNameTextSize)!], context: nil)
                
                let menuDescriptionRect = NSString(string: menu.food.description!).boundingRect(with: CGSize(width: frameWidth - 18, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: menuDescriptionTextSize)!], context: nil)
                
                menuDescriptionHeight = menuDescriptionRect.height
                menuNameHeight = menuNameRect.height
            }
            self.setup()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    private func setup() {
        addSubview(viewCell)
        
        addConstraintsWithFormat(format: "V:|[v0]-12-|", views: viewCell)
        addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: viewCell)
        
        menuDescriptionView.addSubview(menuDescriptionIconView)
        menuDescriptionView.addSubview(menuDescriptionTextView)
        
        menuDescriptionTextView.font = UIFont(name: "Poppins-Regular", size: menuDescriptionTextSize)
        
        menuDescriptionView.addConstraintsWithFormat(format: "H:|[v0(14)]-4-[v1]|", views: menuDescriptionIconView, menuDescriptionTextView)
        menuDescriptionView.addConstraintsWithFormat(format: "V:|[v0(14)]", views: menuDescriptionIconView)
        menuDescriptionView.addConstraintsWithFormat(format: "V:|[v0]", views: menuDescriptionTextView)
        
        
        menuClassView.addSubview(menuTypeView)
        menuClassView.addSubview(menuAvailabilityView)
        
        menuClassView.addConstraintsWithFormat(format: "V:|[v0(26)]|", views: menuTypeView)
        menuClassView.addConstraintsWithFormat(format: "V:|[v0(26)]|", views: menuAvailabilityView)
        
        if UIDevice.bigDevices.contains(device) || UIDevice.ipadsDevices.contains(device) {
            menuClassView.addSubview(menuGroupView)
            menuClassView.addConstraintsWithFormat(format: "V:|[v0(26)]|", views: menuGroupView)
            menuClassView.addConstraintsWithFormat(format: "H:|[v0]-8-[v1]-8-[v2]", views: menuGroupView, menuTypeView, menuAvailabilityView)
        } else {
            menuClassView.addConstraintsWithFormat(format: "H:|[v0]-8-[v1]", views: menuTypeView, menuAvailabilityView)
        }
        
        menuAboutView.addSubview(menuNameView)
        menuAboutView.addSubview(menuRating)
        menuAboutView.addSubview(menuDescriptionView)
        menuAboutView.addSubview(menuClassView)
        
        menuNameView.font = UIFont(name: "Poppins-SemiBold", size: menuNameTextSize)
        
        menuAboutView.addConstraintsWithFormat(format: "H:|[v0]|", views: menuNameView)
        menuAboutView.addConstraintsWithFormat(format: "H:|[v0]|", views: menuRating)
        menuAboutView.addConstraintsWithFormat(format: "H:|[v0]|", views: menuDescriptionView)
        menuAboutView.addConstraintsWithFormat(format: "H:|[v0]|", views: menuClassView)
        menuAboutView.addConstraintsWithFormat(format: "V:|[v0(\(menuNameHeight))]-4-[v1]-4-[v2]-8-[v3(26)]-12-|", views: menuNameView, menuRating, menuDescriptionView, menuClassView)
        
        viewCell.addSubview(menuImageView)
        viewCell.addSubview(menuAboutView)
        
        viewCell.addConstraintsWithFormat(format: "H:|-12-[v0(\(menuImageConstant))]-12-[v1]-12-|", views: menuImageView, menuAboutView)
        viewCell.addConstraintsWithFormat(format: "V:|-12-[v0(55)]", views: menuImageView)
        viewCell.addConstraintsWithFormat(format: "V:|-12-[v0(\(69 + menuDescriptionHeight + menuNameHeight))]", views: menuAboutView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
