//
//  EditRestaurantReviewController.swift
//  ting
//
//  Created by Christian Scott on 12/26/19.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit

class EditRestaurantReviewController: UIViewController, UITextViewDelegate {

    var onDismiss : ((Bool) -> Void)?
    let session = UserAuthentication().get()!
    
    var branch: Branch? {
        didSet {
            if let branch = self.branch {
                guard let url = URL(string: URLs.checkRestaurantReview) else { return }
                
                let params: Parameters = ["resto": "\(branch.id)"]
                
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
                    if let httpResponse = response as? HTTPURLResponse {
                        if let data = data {
                            if httpResponse.statusCode == 200 {
                                do {
                                    let restaurantReview = try JSONDecoder().decode(RestaurantReview.self, from: data)
                                    DispatchQueue.main.async { self.review = restaurantReview }
                                } catch {}
                            } else {
                                do {
                                    let serverResponse = try JSONDecoder().decode(ServerResponse.self, from: data)
                                    DispatchQueue.main.async {
                                        Toast.makeToast(message: serverResponse.message, duration: Toast.MID_LENGTH_DURATION, style: .default)
                                    }
                                } catch {}
                            }
                        }
                    }
                }.resume()
            }
        }
    }
    
    var review: RestaurantReview? {
        didSet {
            if let review = self.review {
                reviewRating.rating = Double(review.review)
                reviewComment.text = review.comment
                reviewComment.textColor = Colors.colorGray
            }
        }
    }
    
    let cancelText: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Cancel".uppercased()
        view.textColor = Colors.colorPrimary
        view.font = UIFont(name: "Poppins-Regular", size: 16)!
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let reviewText: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Review This Restaurant"
        view.font = UIFont(name: "Poppins-SemiBold", size: 22)!
        view.textColor = Colors.colorGray
        view.textAlignment = .center
        return view
    }()
    
    let reviewDescriptionText: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Please select a rate and write a review"
        view.textColor = Colors.colorLightGray
        view.font = UIFont(name: "Poppins-Regular", size: 14)!
        view.textAlignment = .center
        return view
    }()
    
    let reviewRating: CosmosView = {
        let view = CosmosView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.rating = 1
        view.settings.updateOnTouch = true
        view.settings.fillMode = .full
        view.settings.starSize = 36
        view.starMargin = 2
        view.totalStars = 5
        view.settings.filledColor = Colors.colorYellowRate
        view.settings.filledBorderColor = Colors.colorYellowRate
        view.settings.emptyColor = Colors.colorVeryLightGray
        view.settings.emptyBorderColor = Colors.colorVeryLightGray
        return view
    }()
    
    lazy var reviewComment: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isEditable = true
        view.text = "Write your review comment"
        view.textColor = Colors.colorLightGray
        view.font = UIFont(name: "Poppins-Regular", size: 16)!
        view.backgroundColor = Colors.colorDarkTransparent
        view.textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 8, right: 8)
        view.delegate = self
        view.returnKeyType = .done
        return view
    }()
    
    let submitButton: PrimaryButtonElse = {
        let view = PrimaryButtonElse()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleLabel?.text = "Submit".uppercased()
        view.titleLabel?.textColor = Colors.colorWhite
        view.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 17)!
        view.titleLabel?.textAlignment = .center
        view.layer.cornerRadius = 4.0
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(EditMenuReviewViewController.onCancel(_:))))
        
        submitButton.addTarget(self, action: #selector(submitReview(_:)), for: .touchUpInside)
        submitButton.setTitle("Submit".uppercased(), for: .normal)
        submitButton.setTitleColor(Colors.colorWhite, for: .normal)
        submitButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 17)!
        submitButton.setLinearGradientBackgroundColorElse(colorOne: Colors.colorPrimary, colorTwo: Colors.colorPrimaryDark, frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 55))
        
        self.view.addSubview(cancelText)
        self.view.addConstraintsWithFormat(format: "V:|-16-[v0]", views: cancelText)
        self.view.addConstraintsWithFormat(format: "H:[v0]-20-|", views: cancelText)
        
        self.view.addSubview(reviewText)
        self.view.addSubview(reviewDescriptionText)
        self.view.addSubview(reviewRating)
        self.view.addSubview(reviewComment)
        self.view.addSubview(submitButton)
        
        self.view.addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: reviewText)
        self.view.addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: reviewDescriptionText)
        self.view.addConstraintsWithFormat(format: "H:[v0]", views: reviewRating)
        self.view.addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: reviewComment)
        self.view.addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: submitButton)
        
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .centerX, relatedBy: .equal, toItem: reviewRating, attribute: .centerX, multiplier: 1, constant: 0))
        
        self.view.addConstraintsWithFormat(format: "V:|-86-[v0]-4-[v1]-20-[v2]-20-[v3(130)]-12-[v4(45)]", views: reviewText, reviewDescriptionText, reviewRating, reviewComment, submitButton)
    }
    
    @objc func onCancel(_ sender: Any?){
        self.resignFirstResponder()
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if reviewComment.textColor == Colors.colorLightGray {
            reviewComment.text = ""
            reviewComment.textColor = Colors.colorGray
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if reviewComment.text.isEmpty {
            reviewComment.text = "Write your review comment"
            reviewComment.textColor = Colors.colorLightGray
        }
        reviewComment.resignFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            reviewComment.resignFirstResponder()
            return false
        }
        return true
    }
    
    @IBAction func submitReview(_ sender: Any?) { self.onDismiss!(true) }
}
