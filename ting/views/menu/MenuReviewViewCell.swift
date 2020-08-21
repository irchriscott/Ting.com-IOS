//
//  MenuReviewViewCell.swift
//  ting
//
//  Created by Christian Scott on 11/10/19.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import Foundation
import UIKit

class MenuReviewViewCell: UITableViewCell {
    
    var userNameHeight: CGFloat = 20
    var reviewTextHeight: CGFloat = 15
    let device = UIDevice.type
    
    let userNameTextSize: CGFloat = 14
    let reviewTextSize: CGFloat = 11
    let userImageConstant: CGFloat = 50
    
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
        view.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
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
    
    let reviewRatingView: CosmosView = {
        let view = CosmosView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.rating = 3
        view.settings.updateOnTouch = false
        view.settings.fillMode = .full
        view.settings.starSize = 14
        view.starMargin = 2
        view.totalStars = 5
        view.settings.filledColor = Colors.colorYellowRate
        view.settings.filledBorderColor = Colors.colorYellowRate
        view.settings.emptyColor = Colors.colorVeryLightGray
        view.settings.emptyBorderColor = Colors.colorVeryLightGray
        return view
    }()
    
    
    let reviewTextView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-Regular", size: 11)
        view.textColor = Colors.colorGray
        view.text = "Menu Description"
        view.numberOfLines = 3
        return view
    }()
    
    let reviewDateView: IconTextView = {
        let view = IconTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "May 22, 1998"
        view.alpha = 0.3
        view.textColor = Colors.colorDarkGray
        view.icon = UIImage(named: "icon_clock_25_black")!
        return view
    }()
    
    var review: MenuReview? {
        didSet {
            if let review = self.review {
                userImageView.kf.setImage(
                    with: URL(string: "\(URLs.uploadEndPoint)\(review.user.image)")!,
                    placeholder: UIImage(named: "default_user"),
                    options: [
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(1)),
                        .cacheOriginalImage
                    ]
                )
                userNameView.text = review.user.name
                reviewTextView.text = review.comment
                reviewRatingView.rating = Double(review.review)
                
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"

                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "MMM dd,yyyy"

                let date = dateFormatterGet.date(from: review.updatedAt)
                reviewDateView.text = dateFormatterPrint.string(from: date!)
                    
                let frameWidth = frame.width - (60 + userImageConstant)
                
                let userNameRect = NSString(string: review.user.name).boundingRect(with: CGSize(width: frameWidth, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: userNameTextSize)!], context: nil)
                
                let reviewTextRect = NSString(string: review.comment).boundingRect(with: CGSize(width: frameWidth, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: reviewTextSize)!], context: nil)
                
                reviewTextHeight = reviewTextRect.height
                userNameHeight = userNameRect.height
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
        
        reviewView.addSubview(userNameView)
        reviewView.addSubview(reviewRatingView)
        reviewView.addSubview(reviewTextView)
        reviewView.addSubview(reviewDateView)
        
        reviewView.addConstraintsWithFormat(format: "H:|[v0]|", views: userNameView)
        reviewView.addConstraintsWithFormat(format: "H:|[v0]|", views: reviewRatingView)
        reviewView.addConstraintsWithFormat(format: "H:|[v0]|", views: reviewTextView)
        reviewView.addConstraintsWithFormat(format: "H:|[v0]", views: reviewDateView)
        reviewView.addConstraintsWithFormat(format: "V:|[v0(\(userNameHeight))]-0-[v1]-4-[v2(\(reviewTextHeight))]-4-[v3(26)]-12-|", views: userNameView, reviewRatingView, reviewTextView, reviewDateView)
        
        viewCell.addSubview(userImageView)
        viewCell.addSubview(reviewView)
        
        viewCell.addConstraintsWithFormat(format: "H:|-12-[v0(\(userImageConstant))]-12-[v1]-12-|", views: userImageView, reviewView)
        viewCell.addConstraintsWithFormat(format: "V:|-12-[v0(\(userImageConstant))]", views: userImageView)
        viewCell.addConstraintsWithFormat(format: "V:|-12-[v0(\(4 + 10 + 4 + 26 + 12 + reviewTextHeight + userNameHeight))]-12-|", views: reviewView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
