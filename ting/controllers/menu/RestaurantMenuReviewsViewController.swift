//
//  RestaurantMenuReviewsViewController.swift
//  ting
//
//  Created by Christian Scott on 11/15/19.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit

class RestaurantMenuReviewsViewController: UITableViewController {
    
    private let cellId = "reviewCellId"
    
    var reviews: [MenuReview]? {
        didSet { self.tableView.reloadData() }
    }
    
    var menuReviews: MenuReviews? {
        didSet {
            if let menuReviews = self.menuReviews {
                self.reviews = menuReviews.reviews
            }
        }
    }
    
    var reviewsURL: String? {
        didSet {}
    }
    
    private func getMenuReviews () {
        if let url = self.reviewsURL {
            APIDataProvider.instance.getMenuReviews(url: "\(URLs.hostEndPoint)\(url)") { (allReviews) in
                if allReviews.count > 0 { DispatchQueue.main.async { self.reviews = allReviews } }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getMenuReviews()
        self.tableView.register(MenuReviewViewCell.self, forCellReuseIdentifier: self.cellId)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reviews?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 128
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! MenuReviewViewCell
        cell.selectionStyle = .none
        cell.review = self.reviews![indexPath.item]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let reviews = self.reviews {
            
            let review = reviews[indexPath.item]
            
            var userNameHeight: CGFloat = 20
            var reviewTextHeight: CGFloat = 15
            
            let userNameTextSize: CGFloat = 14
            let reviewTextSize: CGFloat = 11
            let userImageConstant: CGFloat = 50
            
            let frameWidth = view.frame.width - (60 + userImageConstant)
            
            let userNameRect = NSString(string: review.user.name).boundingRect(with: CGSize(width: frameWidth, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: userNameTextSize)!], context: nil)
            
            let reviewTextRect = NSString(string: review.comment).boundingRect(with: CGSize(width: frameWidth, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: reviewTextSize)!], context: nil)
            
            reviewTextHeight = reviewTextRect.height
            userNameHeight = userNameRect.height
            
            return 4 + 10 + 4 + 26 + 12 + reviewTextHeight + userNameHeight + 12 + 12
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = .white
        
        let reviewsCountView: UILabel = {
            let label = UILabel()
            label.textColor = Colors.colorGray
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: "Poppins-SemiBold", size: 32)!
            label.text = "0.0"
            return label
        }()
        
        let reviewsMaxView: UILabel = {
            let label = UILabel()
            label.textColor = Colors.colorGray
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: "Poppins-Regular", size: 14)!
            label.text = "Out of 5"
            return label
        }()
        
        let reviewsAverageView: UIView = {
            let reviewView = UIView()
            reviewView.translatesAutoresizingMaskIntoConstraints = false
            return reviewView
        }()
        
        reviewsAverageView.addSubview(reviewsCountView)
        reviewsAverageView.addSubview(reviewsMaxView)
        
        reviewsAverageView.addConstraintsWithFormat(format: "H:[v0]", views: reviewsCountView)
        reviewsAverageView.addConstraintsWithFormat(format: "H:[v0]", views: reviewsMaxView)
        reviewsAverageView.addConstraintsWithFormat(format: "V:[v0(35)]-4-[v1(16)]", views: reviewsCountView, reviewsMaxView)
        
        reviewsAverageView.addConstraint(NSLayoutConstraint(item: reviewsAverageView, attribute: .centerX, relatedBy: .equal, toItem: reviewsCountView, attribute: .centerX, multiplier: 1, constant: 0))
        reviewsAverageView.addConstraint(NSLayoutConstraint(item: reviewsAverageView, attribute: .centerX, relatedBy: .equal, toItem: reviewsMaxView, attribute: .centerX, multiplier: 1, constant: 0))
        
        let reviewsBarView: ReviewsPercentsView = {
            let barView = ReviewsPercentsView()
            barView.translatesAutoresizingMaskIntoConstraints = false
            return barView
        }()
        
        reviewsBarView.width = self.view.frame.width - 36 - 70
        
        if let reviews = self.menuReviews {
            reviewsBarView.dataEntries = [
                BarChartEntry(score: reviews.percents[4], title: "5 ★"),
                BarChartEntry(score: reviews.percents[3], title: "4 ★"),
                BarChartEntry(score: reviews.percents[2], title: "3 ★"),
                BarChartEntry(score: reviews.percents[1], title: "2 ★"),
                BarChartEntry(score: reviews.percents[0], title: "1 ★")
            ]
            reviewsCountView.text = "\(reviews.average)"
        }
        
        let reviewsTitleView: UILabel = {
            let label = UILabel()
            label.textColor = Colors.colorGray
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: "Poppins-Medium", size: 14)!
            label.text = "Ratings & Reviews".uppercased()
            return label
        }()
        
        let separatorView: UIView = {
            let separator = UIView()
            separator.translatesAutoresizingMaskIntoConstraints = false
            separator.backgroundColor = Colors.colorVeryLightGray
            return separator
        }()
        
        view.addSubview(reviewsTitleView)
        view.addSubview(reviewsAverageView)
        view.addSubview(reviewsBarView)
        view.addSubview(separatorView)
        view.addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: separatorView)
        view.addConstraintsWithFormat(format: "H:|-12-[v0]", views: reviewsTitleView)
        view.addConstraintsWithFormat(format: "V:|-8-[v0(22)]-4-[v1(80)]-0-[v2(0.5)]|", views: reviewsTitleView, reviewsAverageView, separatorView)
        view.addConstraintsWithFormat(format: "V:[v0(80)]|", views: reviewsBarView)
        view.addConstraintsWithFormat(format: "H:|-12-[v0(70)]-12-[v1(\(self.view.frame.width - 36 - 70))]-12-|", views: reviewsAverageView, reviewsBarView)
        
        return view
    }
}
