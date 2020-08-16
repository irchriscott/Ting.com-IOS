//
//  CuisineRestaurantsViewController.swift
//  ting
//
//  Created by Christian Scott on 16/08/2020.
//  Copyright © 2020 Ir Christian Scott. All rights reserved.
//

import UIKit
import MapKit
import XLPagerTabStrip
import ShimmerSwift

class CuisineRestaurantsViewController: UITableViewController, CLLocationManagerDelegate, IndicatorInfoProvider {
    
    var cuisine: RestaurantCategory? {
        didSet {}
    }
    
    let cellId = "cellId"
    let shimmerCellId = "shimmerCellId"
    let emptyCellId = "emptyCellId"
    
    var spinnerViewHeight: CGFloat = 0
    var restaurants: [Branch] = []
    
    var locationManager = CLLocationManager()
    var refresherLoadingView = UIRefreshControl()
    var selectedLocation: CLLocation?
    
    let session = UserAuthentication().get()!
    var isMapOpened: Bool = false
    var mapCenter: CLLocation?
    var selectedBranch: Branch?
    
    lazy var mapView: RestaurantMapView = {
        let view = RestaurantMapView()
        view.controller = self
        view.restaurant = self.selectedBranch
        return view
    }()
    
    var pageIndex = 1
    var shouldLoad = true
    var hasLoaded = false
    
    private func getRestaurants(location: CLLocation?, index: Int){
        APIDataProvider.instance.getCuisineRestaurants(cuisine: self.cuisine!.id, page: index) { (branches) in
            DispatchQueue.main.async {
                self.hasLoaded = true
                if !branches.isEmpty {
                    var newBranches: [Branch] = []
                    if let userLocation = location {
                        for var branch in branches {
                            let branchLocation = CLLocation(latitude: CLLocationDegrees(exactly: Double(branch.latitude)!)!, longitude: CLLocationDegrees(exactly: Double(branch.longitude)!)!)
                            branch.dist = Double(branchLocation.distance(from: userLocation) / 1000).rounded(toPlaces: 2)
                            if !self.restaurants.contains(where: { (b) -> Bool in
                                return b.id == branch.id
                            }){ newBranches.append(branch) }
                        }
                    } else { for var branch in newBranches { branch.dist = 0.00 } }
                    
                    self.restaurants.append(contentsOf: newBranches.sorted(by: { $0.dist! < $1.dist! }))
                    self.spinnerViewHeight = 0
                    self.tableView.reloadData()
                    self.refresherLoadingView.endRefreshing()
                   
                } else {
                    self.spinnerViewHeight = 0
                    self.shouldLoad = false
                }
                
                if self.restaurants.isEmpty {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    var loadedRestaurants:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.checkLocationAuthorization(status: CLLocationManager.authorizationStatus())
        
        refresherLoadingView.addTarget(self, action: #selector(refreshRestaurants), for: UIControl.Event.valueChanged)
        tableView.addSubview(refresherLoadingView)
        
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.shimmerCellId)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.emptyCellId)
        tableView.register(CuisineRestaurantViewCell.self, forCellReuseIdentifier: self.cellId)
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
            self.getRestaurants(location: location, index: pageIndex)
            let alert = UIAlertController(title: "Please, Go to settings and allow this app to use your location", message: nil, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            break
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
            break
        case .restricted:
            let location = CLLocation(latitude: CLLocationDegrees(Double((session.addresses?.addresses[0].latitude)!)!), longitude: CLLocationDegrees(Double((session.addresses?.addresses[0].longitude)!)!))
            self.selectedLocation = location
            self.getRestaurants(location: location, index: pageIndex)
            let alert = UIAlertController(title: "Please, Go to settings and allow this app to use your location", message: nil, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            let addresses = session.addresses?.addresses
            let address = addresses![0]
            self.selectedLocation = CLLocation(latitude: CLLocationDegrees(Double(address.latitude)!), longitude: CLLocationDegrees(Double(address.longitude)!))
            self.getRestaurants(location: self.selectedLocation, index: pageIndex)
            return
        }
        self.selectedLocation = location
        self.getRestaurants(location: location, index: pageIndex)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.checkLocationAuthorization(status: CLLocationManager.authorizationStatus())
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let location = CLLocation(latitude: CLLocationDegrees(Double((session.addresses?.addresses[0].latitude)!)!), longitude: CLLocationDegrees(Double((session.addresses?.addresses[0].longitude)!)!))
        self.selectedLocation = location
        self.getRestaurants(location: location, index: pageIndex)
        Toast.makeToast(message: error.localizedDescription, duration: Toast.LONG_LENGTH_DURATION, style: .error)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.hasLoaded {
            return !self.restaurants.isEmpty ? self.restaurants.count : 1
        } else { return 3 }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let emptyTextRect = NSString(string: "No Restaurant To Show").boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: 23)!], context: nil)
        if self.hasLoaded {
            return !self.restaurants.isEmpty ? self.restaurantCellViewHeight(index: indexPath.row) : 30 + 90 + 12 + emptyTextRect.height + 30
        } else { return 94 + 12 }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.hasLoaded {
            if !self.restaurants.isEmpty {
                let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! CuisineRestaurantViewCell
                cell.selectionStyle = .none
                if !self.loadedRestaurants.contains(indexPath.row) {
                    cell.branch = self.restaurants[indexPath.row]
                    self.loadedRestaurants.append(indexPath.row)
                }
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
                    view.image = UIImage(named: "ic_restaurants")!
                    view.contentMode = .scaleAspectFill
                    view.clipsToBounds = true
                    view.alpha = 0.2
                    return view
                }()
                
                let emptyTextView: UILabel = {
                    let view = UILabel()
                    view.translatesAutoresizingMaskIntoConstraints = false
                    view.text = "No Restaurant To Show"
                    view.font = UIFont(name: "Poppins-SemiBold", size: 23)
                    view.textColor = Colors.colorVeryLightGray
                    view.textAlignment = .center
                    return view
                }()
                
                let emptyTextRect = NSString(string: "No Restaurant To Show").boundingRect(with: CGSize(width: cell.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: 23)!], context: nil)
                
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
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.shimmerCellId, for: indexPath)
            cell.selectionStyle = .none
            
            let view: RowShimmerView = {
                let view = RowShimmerView()
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            
            cell.addSubview(view)
            cell.addConstraintsWithFormat(format: "V:|[v0]-12-|", views: view)
            cell.addConstraintsWithFormat(format: "H:|[v0]|", views: view)
            
            let shimmerView = ShimmeringView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 94))
            cell.addSubview(shimmerView)
            
            shimmerView.contentView = view
            shimmerView.shimmerAnimationOpacity = 0.4
            shimmerView.shimmerSpeed = 250
            shimmerView.isShimmering = true
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.restaurants.count - 1 {
            if self.shouldLoad {
                pageIndex += 1
                self.spinnerViewHeight = 40
                getRestaurants(location: self.selectedLocation, index: pageIndex)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let branch = self.restaurants[indexPath.row]
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let restaurantViewController = storyboard.instantiateViewController(withIdentifier: "RestaurantView") as! RestaurantViewController
        restaurantViewController.restaurant = branch
        self.navigationController?.pushViewController(restaurantViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer: UIView = {
            let view = UIView()
            view.backgroundColor = Colors.colorWhite
            view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: self.spinnerViewHeight)
            return view
        }()
        
        let indicatorView: UIActivityIndicatorView = {
            let view = UIActivityIndicatorView(style: .gray)
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        indicatorView.startAnimating()
        footer.addSubview(indicatorView)
        footer.addConstraintsWithFormat(format: "V:|[v0]|", views: indicatorView)
        footer.addConstraintsWithFormat(format: "H:|[v0]|", views: indicatorView)
        footer.addConstraint(NSLayoutConstraint(item: indicatorView, attribute: .centerY, relatedBy: .equal, toItem: footer, attribute: .centerY, multiplier: 1, constant: 0))
        
        return footer
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.spinnerViewHeight
    }
    
    private func restaurantCellViewHeight(index: Int) -> CGFloat {
        
        let branch = self.restaurants[index]
        let device = UIDevice.type
        
        var restaurantNameTextSize: CGFloat = 16
        var restaurantAddressTextSize: CGFloat = 13
        var restaurantImageConstant: CGFloat = 80
        
        if UIDevice.smallDevices.contains(device) {
            restaurantImageConstant = 55
            restaurantNameTextSize = 14
            restaurantAddressTextSize = 12
        } else if UIDevice.mediumDevices.contains(device) {
            restaurantImageConstant = 70
            restaurantNameTextSize = 15
        }
        
        let frameWidth = view.frame.width - (60 + restaurantImageConstant)
        
        let branchNameRect = NSString(string: "\(branch.name), \(branch.restaurant!.name)").boundingRect(with: CGSize(width: frameWidth, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: restaurantNameTextSize)!], context: nil)
        
        let branchAddressRect = NSString(string: branch.address).boundingRect(with: CGSize(width: frameWidth - 18, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: restaurantAddressTextSize)!], context: nil)
        
        var valueToAdd: CGFloat = 0
        if branchNameRect.height > 25 { valueToAdd += 8 }
        if branchAddressRect.height > 25 { valueToAdd += 8 }
        
        let cellHeight: CGFloat = 2 + 20 + 4 + 26 + 8 + 26 + branchNameRect.height + branchAddressRect.height + 16 + 8 + valueToAdd + 12
        
        return cellHeight
    }
    
    @objc private func refreshRestaurants() {
        pageIndex = 1
        self.restaurants = []
        self.spinnerViewHeight = 0
        self.getRestaurants(location: self.selectedLocation, index: pageIndex)
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "RESTAURANTS")
    }
}
