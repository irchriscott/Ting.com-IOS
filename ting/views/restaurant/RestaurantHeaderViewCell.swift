//
//  RestaurantHeaderViewCell.swift
//  ting
//
//  Created by Christian Scott on 12/17/19.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit
import MapKit

class RestaurantHeaderViewCell: UICollectionViewCell, CLLocationManagerDelegate {
    
    let numberFormatter = NumberFormatter()
    
    var locationManager = CLLocationManager()
    var selectedLocation: CLLocation?
    
    let session = UserAuthentication().get()!
    var isMapOpened: Bool = false
    var mapCenter: CLLocation?
    
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
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
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
                self.setRestaurantDistance()
            }
            self.setup()
        }
    }
    
    var controller: UIViewController? {
        didSet {}
    }
    
    var mapView: RestaurantMapViewController!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.restaurantDistanceView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(showUserAddresses)))
        self.restaurantDistanceView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openRestaurantMap)))
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(likeRestaurantToggle(_sender:)))
        doubleTap.numberOfTapsRequired = 2
        self.profileImageView.addGestureRecognizer(doubleTap)
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.checkLocationAuthorization(status: CLLocationManager.authorizationStatus())
    }
    
    private func setup(){
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        mapView = storyboard.instantiateViewController(withIdentifier: "RestaurantMapView") as? RestaurantMapViewController
        mapView.controller = self.controller
        mapView.restaurant = self.branch
        mapView.modalPresentationStyle = .overFullScreen
        
        self.mapView.closeButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeRestaurantMap)))
        
        restaurantStatusView.addSubview(restaurantDistanceView)
        restaurantStatusView.addSubview(restaurantTimeStatusView)
        
        restaurantStatusView.addConstraintsWithFormat(format: "H:|[v0]-8-[v1]|", views: restaurantDistanceView, restaurantTimeStatusView)
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
    
    private func checkLocationAuthorization(status: CLAuthorizationStatus){
        self.locationManager.delegate = self
        switch status {
        case .authorizedAlways:
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.startUpdatingLocation()
            break
        case .authorizedWhenInUse:
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.startUpdatingLocation()
            break
        case .denied:
            let location = CLLocation(latitude: CLLocationDegrees(Double((session.addresses?.addresses[0].latitude)!)!), longitude: CLLocationDegrees(Double((session.addresses?.addresses[0].longitude)!)!))
            self.selectedLocation = location
            self.setRestaurantDistance()
            let alert = UIAlertController(title: "Please, Go to settings and allow this app to use your location", message: nil, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            Toast.makeToast(message: "Please, Go to settings and allow this app to use your location", duration: Toast.MID_LENGTH_DURATION, style: .default)
            break
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
            break
        case .restricted:
            let location = CLLocation(latitude: CLLocationDegrees(Double((session.addresses?.addresses[0].latitude)!)!), longitude: CLLocationDegrees(Double((session.addresses?.addresses[0].longitude)!)!))
            self.selectedLocation = location
            self.setRestaurantDistance()
            let alert = UIAlertController(title: "Please, Go to settings and allow this app to use your location", message: nil, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            Toast.makeToast(message: "Please, Go to settings and allow this app to use your location", duration: Toast.MID_LENGTH_DURATION, style: .default)
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            let addresses = session.addresses?.addresses
            let address = addresses![0]
            self.selectedLocation = CLLocation(latitude: CLLocationDegrees(Double(address.latitude)!), longitude: CLLocationDegrees(Double(address.longitude)!))
            self.setRestaurantDistance()
            return
        }
        self.selectedLocation = location
        self.setRestaurantDistance()
    }
    
    private func setRestaurantDistance() {
        if let branch = self.branch, let location = self.selectedLocation {
            let branchLocation = CLLocation(latitude: CLLocationDegrees(exactly: Double(branch.latitude)!)!, longitude: CLLocationDegrees(exactly: Double(branch.longitude)!)!)
            let distance = Double(branchLocation.distance(from: location) / 1000).rounded(toPlaces: 2)
            restaurantDistanceView.text = "\(numberFormatter.string(from: NSNumber(value: distance))!) km"
        } else if let branch = self.branch {
            let address = session.addresses?.addresses[0]
            let branchLocation = CLLocation(latitude: CLLocationDegrees(exactly: Double(branch.latitude)!)!, longitude: CLLocationDegrees(exactly: Double(branch.longitude)!)!)
            self.selectedLocation = CLLocation(latitude: CLLocationDegrees(exactly: Double(address!.latitude)!)!, longitude: CLLocationDegrees(exactly: Double(address!.longitude)!)!)
            
            if let location = self.selectedLocation {
                let distance = Double(branchLocation.distance(from: location) / 1000).rounded(toPlaces: 2)
                restaurantDistanceView.text = "\(numberFormatter.string(from: NSNumber(value: distance))!) km"
            }
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
    
    @objc func showUserAddresses() {
        let addresses = UIAlertController(title: "Restaurants Near Location", message: nil, preferredStyle: .actionSheet)
        addresses.addAction(UIAlertAction(title: "Current Location", style: .default) { (action) in
            DispatchQueue.main.async { self.checkLocationAuthorization(status: CLLocationManager.authorizationStatus()) }
        })
        session.addresses?.addresses.forEach({ (address) in
            addresses.addAction(UIAlertAction(title: address.address, style: .default, handler: { (action) in
                DispatchQueue.main.async {
                    let location = CLLocation(latitude: CLLocationDegrees(Double(address.latitude)!), longitude: CLLocationDegrees(Double(address.longitude)!))
                    self.selectedLocation = location
                    self.setRestaurantDistance()
                }
            }))
        })

        addresses.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { (action) in }))
        self.controller?.present(addresses, animated: true, completion: nil)
    }
    
    @objc func openRestaurantMap() {
        if let window = UIApplication.shared.keyWindow {
            if var branch = self.branch, let location = self.selectedLocation {
                let branchLocation = CLLocation(latitude: CLLocationDegrees(Double(branch.latitude)!), longitude: CLLocationDegrees(Double(branch.longitude)!))
                branch.dist = Double(branchLocation.distance(from: location) / 1000).rounded(toPlaces: 2)
                isMapOpened = true
                window.windowLevel = UIWindow.Level.statusBar
                
                mapView.mapCenter = branchLocation
                mapView.selectedLocation = location
                mapView.restaurant = branch
                controller?.present(mapView, animated: true, completion: nil)
            }
        }
    }
    
    @objc func closeRestaurantMap(){
        UIApplication.shared.keyWindow?.windowLevel = UIWindow.Level.normal
        mapView.dismiss(animated: true, completion: nil)
        isMapOpened = false
        mapCenter = nil
    }
    
    @objc func likeRestaurantToggle(_sender: Any?) {
        
        if let branch = self.branch, let restaurant = self.branch?.restaurant {
            
            guard let url = URL(string: "\(URLs.hostEndPoint)\(branch.urls.apiAddLike)") else { return }
            let params: Parameters = ["restaurant": "\(restaurant.id)"]
            
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
                        if serverResponse.type == "success" {
                            DispatchQueue.main.async {
                                Toast.makeToast(message: serverResponse.message, duration: Toast.MID_LENGTH_DURATION, style: .success)
                                
                                let imageLikeView: UIImageView = {
                                    let view =  UIImageView()
                                    view.translatesAutoresizingMaskIntoConstraints = false
                                    view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
                                    view.alpha = 0.0
                                    view.contentMode = .scaleAspectFill
                                    return view
                                }()
                                
                                if serverResponse.message.contains("Disliked") {
                                    imageLikeView.image = UIImage(named: "icon_like_filled_100_gray")!
                                } else { imageLikeView.image = UIImage(named: "icon_like_filled_100_primary")! }
                                
                                self.profileImageView.addSubview(imageLikeView)
                                self.profileImageView.addConstraintsWithFormat(format: "H:[v0(100)]", views: imageLikeView)
                                self.profileImageView.addConstraintsWithFormat(format: "V:[v0(100)]", views: imageLikeView)
                                
                                self.profileImageView.addConstraint(NSLayoutConstraint(item: self.profileImageView, attribute: .centerX, relatedBy: .equal, toItem: imageLikeView, attribute: .centerX, multiplier: 1, constant: 0))
                                self.profileImageView.addConstraint(NSLayoutConstraint(item: self.profileImageView, attribute: .centerY, relatedBy: .equal, toItem: imageLikeView, attribute: .centerY, multiplier: 1, constant: 0))
                                
                                UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
                                    imageLikeView.alpha = 0.6
                                }) { (success) in
                                    imageLikeView.alpha = 0.0
                                    imageLikeView.removeFromSuperview()
                                }
                            }
                        } else {
                            DispatchQueue.main.async {
                                Toast.makeToast(message: serverResponse.message, duration: Toast.MID_LENGTH_DURATION, style: .error)
                            }
                        }
                    } catch {
                        DispatchQueue.main.async {
                            Toast.makeToast(message: error.localizedDescription, duration: Toast.MID_LENGTH_DURATION, style: .error)
                        }
                    }
                }
            }.resume()
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
