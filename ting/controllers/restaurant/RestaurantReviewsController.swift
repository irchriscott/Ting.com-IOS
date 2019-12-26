//
//  RestaurantReviewsController.swift
//  ting
//
//  Created by Christian Scott on 12/25/19.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit
import GradientLoadingBar

class RestaurantReviewsController: UITableViewController {
    
    let cellId = "cellId"
    let emptyCellId = "emptyCellId"
    
    let session = UserAuthentication().get()!
    
    var branch: Branch? {
        didSet {
            if let reviews = self.branch?.reviews?.reviews {
                self.reviews = reviews
                self.gradientLoadingBar.fadeOut()
            }
        }
    }
    
    var reviews: [RestaurantReview]? {
        didSet { self.tableView.reloadData() }
    }
    
    let gradientLoadingBar = GradientLoadingBar(height: 4.0, isRelativeToSafeArea: false)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.tableView.separatorStyle = .none
        
        self.gradientLoadingBar.fadeIn()
        self.loadRestaurantReviews()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_star_outline_25_white"), style: .plain, target: self, action: #selector(editRestaurantReview(_:)))
        
        self.tableView.register(RestaurantReviewCell.self, forCellReuseIdentifier: self.cellId)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.emptyCellId)
    }
    
    
    private func loadRestaurantReviews() {
        self.gradientLoadingBar.fadeIn()
        if let branch = self.branch {
            APIDataProvider.instance.getRestaurantReviews(url: "\(URLs.hostEndPoint)\(branch.urls.apiReviews)") { (reviews) in
                DispatchQueue.main.async {
                    self.gradientLoadingBar.fadeOut()
                    self.reviews = reviews
                }
            }
        }
    }
    
    private func setupNavigationBar(){
        self.navigationController?.navigationBar.barTintColor = Colors.colorPrimaryDark
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = Colors.colorPrimaryDark
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barStyle = .black
        
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "icon_unwind_25_white")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "icon_unwind_25_white")
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.title = "Restaurant Reviews"
        
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
        
        let barButtonAppearance = UIBarButtonItem.appearance()
        barButtonAppearance.setTitleTextAttributes([.foregroundColor : UIColor.white], for: .normal)
        
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
            statusBar.backgroundColor = Colors.colorPrimaryDark
            UIApplication.shared.keyWindow?.addSubview(statusBar)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setupNavigationBar()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reviews?.count ?? 0 > 0 ? self.reviews?.count ?? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.reviews?.count ?? 0 > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! RestaurantReviewCell
            cell.selectionStyle = .none
            cell.review = self.reviews![indexPath.item]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.emptyCellId, for: indexPath)
            
            cell.selectionStyle = .none
            
            let cellView: UIView = {
                let view = UIView()
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            
            let emptyImageView: UIImageView = {
                let view = UIImageView()
                view.translatesAutoresizingMaskIntoConstraints = false
                view.image = UIImage(named: "icon_bubble_chat_96_gray")!
                view.contentMode = .scaleAspectFill
                view.alpha = 0.2
                return view
            }()
            
            let emptyTextView: UILabel = {
                let view = UILabel()
                view.translatesAutoresizingMaskIntoConstraints = false
                view.text = "No Reviews For This Restaurant"
                view.font = UIFont(name: "Poppins-SemiBold", size: 21)
                view.textColor = Colors.colorVeryLightGray
                view.textAlignment = .center
                return view
            }()
            
            let emptyTextRect = NSString(string: "No Reviews For This Restaurant").boundingRect(with: CGSize(width: cell.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: 21)!], context: nil)
            
            cellView.addSubview(emptyImageView)
            cellView.addSubview(emptyTextView)
            
            cellView.addConstraintsWithFormat(format: "H:[v0(90)]", views: emptyImageView)
            cellView.addConstraintsWithFormat(format: "H:|[v0]|", views: emptyTextView)
            cellView.addConstraintsWithFormat(format: "V:|[v0(90)]-6-[v1(\(emptyTextRect.height))]|", views: emptyImageView, emptyTextView)
            
            cellView.addConstraint(NSLayoutConstraint(item: cellView, attribute: .centerX, relatedBy: .equal, toItem: emptyImageView, attribute: .centerX, multiplier: 1, constant: 0))
            cellView.addConstraint(NSLayoutConstraint(item: cellView, attribute: .centerX, relatedBy: .equal, toItem: emptyTextView, attribute: .centerX, multiplier: 1, constant: 0))
            
            cell.selectionStyle = .none
            
            cell.addSubview(cellView)
            cell.addConstraintsWithFormat(format: "H:[v0]", views: cellView)
            cell.addConstraintsWithFormat(format: "V:|-30-[v0(\(90 + 12 + emptyTextRect.height))]-30-|", views: cellView)
            
            cell.addConstraint(NSLayoutConstraint(item: cell, attribute: .centerX, relatedBy: .equal, toItem: cellView, attribute: .centerX, multiplier: 1, constant: 0))
            cell.addConstraint(NSLayoutConstraint(item: cell, attribute: .centerY, relatedBy: .equal, toItem: cellView, attribute: .centerY, multiplier: 1, constant: 0))
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.reviews?.count ?? 0 > 0 {
        
            let review = self.reviews![indexPath.item]
            
            var userNameHeight: CGFloat = 20
            var reviewTextHeight: CGFloat = 15
            
            let userNameTextSize: CGFloat = 14
            let reviewTextSize: CGFloat = 11
            let userImageConstant: CGFloat = 50
            
            let frameWidth = view.frame.width - (60 + userImageConstant)
            
            let userNameRect = NSString(string: review.user!.name).boundingRect(with: CGSize(width: frameWidth, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: userNameTextSize)!], context: nil)
            
            let reviewTextRect = NSString(string: review.comment).boundingRect(with: CGSize(width: frameWidth, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: reviewTextSize)!], context: nil)
            
            reviewTextHeight = reviewTextRect.height
            userNameHeight = userNameRect.height
            
            return 4 + 10 + 4 + 26 + 12 + reviewTextHeight + userNameHeight + 12 + 12
        } else {
            let emptyTextRect = NSString(string: "No Reviews For This Restaurant").boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: 21)!], context: nil)
            return 30 + 90 + 12 + emptyTextRect.height + 30
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = .white
        
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
        
        reviewsBarView.width = view.frame.width - 36 - 70
        
        if let reviews = self.branch?.reviews {
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
        
        headerView.addSubview(reviewsTitleView)
        headerView.addSubview(reviewsAverageView)
        headerView.addSubview(reviewsBarView)
        headerView.addSubview(separatorView)
        headerView.addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: separatorView)
        headerView.addConstraintsWithFormat(format: "H:|-12-[v0]", views: reviewsTitleView)
        headerView.addConstraintsWithFormat(format: "V:|-8-[v0(22)]-4-[v1(80)]-0-[v2(0.5)]|", views: reviewsTitleView, reviewsAverageView, separatorView)
        headerView.addConstraintsWithFormat(format: "V:[v0(80)]|", views: reviewsBarView)
        headerView.addConstraintsWithFormat(format: "H:|-12-[v0(70)]-12-[v1(\(view.frame.width - 36 - 70))]-12-|", views: reviewsAverageView, reviewsBarView)
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 128
    }
    
    @objc private func editRestaurantReview(_ sender: Any?) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let editReviewController = storyboard.instantiateViewController(withIdentifier: "EditRestaurantReview") as! EditRestaurantReviewController
        editReviewController.branch = self.branch
        editReviewController.onDismiss = { edited in
            
            if editReviewController.reviewComment.textColor == Colors.colorGray {
                
                let comment = editReviewController.reviewComment.text!
                let rating = editReviewController.reviewRating.rating
                
                editReviewController.submitButton.isEnabled = false
                editReviewController.reviewComment.resignFirstResponder()
                
                let params: Parameters = ["review": "\(rating)", "comment": comment]
                
                guard let url = URL(string: "\(URLs.hostEndPoint)\((self.branch?.urls.apiAddReview)!)") else { return }
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                
                request.addValue(self.session.token!, forHTTPHeaderField: "AUTHORIZATION")
                request.setValue(self.session.token!, forHTTPHeaderField: "AUTHORIZATION")
                
                let boundary = Requests().generateBoundary()
                request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                
                let httpBody = Requests().createDataBody(withParameters: params, media: nil, boundary: boundary)
                request.httpBody = httpBody
                
                let session = URLSession.shared
                
                session.dataTask(with: request){ (data, response, error) in
                    if response != nil {}
                    if let data = data {
                        do {
                            let serverResponse = try JSONDecoder().decode(ServerResponse.self, from: data)
                            DispatchQueue.main.async {
                                editReviewController.submitButton.isEnabled = true
                                if serverResponse.type == "success" {
                                    editReviewController.dismiss(animated: true, completion: nil)
                                    Toast.makeToast(message: serverResponse.message, duration: Toast.MID_LENGTH_DURATION, style: .success)
                                    self.loadRestaurantReviews()
                                } else {
                                    Toast.makeToast(message: serverResponse.message, duration: Toast.MID_LENGTH_DURATION, style: .error)
                                }
                            }
                        } catch {}
                    }
                }.resume()
                
            } else {
                Toast.makeToast(message: "Review Cannot Be Empty", duration: Toast.MID_LENGTH_DURATION, style: .error)
            }
        }
        self.present(editReviewController, animated: true, completion: nil)
    }
}
