//
//  HomeRestaurantsViewController.swift
//  ting
//
//  Created by Ir Christian Scott on 06/08/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit
import MapKit

class HomeRestaurantsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate {
    
    let headerId = "headerId"
    let cellId = "cellId"
    
    var spinnerViewHeight: CGFloat = 100
    var restaurants: [Branch] = []
    
    var locationManager = CLLocationManager()
    var refresherLoadingView = UIRefreshControl()
    var selectedLocation: CLLocation?
    
    let session = UserAuthentication().get()!
    var isMapOpened: Bool = false
    var mapCenter: CLLocation?
    var selectedBranch: Branch?
    
    let mapFloatingButton: FloatingButton = {
        let view = FloatingButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.icon = UIImage(named: "icon_addess_white")
        return view
    }()
    
    lazy var mapView: RestaurantMapView = {
        let view = RestaurantMapView()
        view.controller = self
        view.restaurant = self.selectedBranch
        return view
    }()
    
    var circleView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.colorDarkTransparent
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.backgroundColor = Colors.colorWhite
        self.navigationController?.navigationBar.barTintColor = Colors.colorWhite
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let barButtonAppearance = UIBarButtonItem.appearance()
        barButtonAppearance.setTitleTextAttributes([.foregroundColor : UIColor.clear], for: .normal)
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.checkLocationAuthorization(status: CLLocationManager.authorizationStatus())
        
        collectionView.register(SpinnerViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(RestaurantViewCell.self, forCellWithReuseIdentifier: cellId)
        
        let tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 50
        
        self.view.addSubview(mapFloatingButton)
        self.view.addConstraintsWithFormat(format: "H:[v0(50)]-12-|", views: mapFloatingButton)
        self.view.addConstraintsWithFormat(format: "V:[v0(50)]-\(tabBarHeight + 12)-|", views: mapFloatingButton)
        
        refresherLoadingView.addTarget(self, action: #selector(HomeRestaurantsViewController.refreshRestaurants), for: UIControl.Event.valueChanged)
        collectionView.addSubview(refresherLoadingView)
        mapFloatingButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(HomeRestaurantsViewController.openRestaurantMap)))
        
        mapFloatingButton.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(HomeRestaurantsViewController.showAddresses)))
        
        self.mapView.closeButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(HomeRestaurantsViewController.closeRestaurantMap)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setupNavigationBar()
        if isMapOpened == true, self.restaurants.count > 0 { self.openRestaurantMap() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupNavigationBar()
    }
    
    private func getRestaurants(location: CLLocation?){
        self.spinnerViewHeight = 100
        self.restaurants = []
        APIDataProvider.instance.loadRestaurants(url: URLs.restaurantsGlobal) { (branches) in
            DispatchQueue.main.async {
                if !branches.isEmpty {
                    if let userLocation = location {
                        for var branch in branches {
                            let branchLocation = CLLocation(latitude: CLLocationDegrees(exactly: Double(branch.latitude)!)!, longitude: CLLocationDegrees(exactly: Double(branch.longitude)!)!)
                            branch.dist = Double(branchLocation.distance(from: userLocation) / 1000).rounded(toPlaces: 2)
                            if !self.restaurants.contains(where: { (b) -> Bool in
                                return b.id == branch.id
                            }){ self.restaurants.append(branch) }
                        }
                    } else { for var branch in self.restaurants { branch.dist = 0.00 } }
                }
                self.restaurants = self.restaurants.sorted(by: { $0.dist! < $1.dist! })
                self.spinnerViewHeight = 0
                self.collectionView.reloadData()
                self.refresherLoadingView.endRefreshing()
            }
        }
    }
    
    @objc func refreshRestaurants(){ self.getRestaurants(location: self.selectedLocation) }
    
    @objc func showAddresses(){
        let addresses = UIAlertController(title: "Restaurants Near Location", message: nil, preferredStyle: .actionSheet)
        addresses.addAction(UIAlertAction(title: "Current Location", style: .default) { (action) in
            DispatchQueue.main.async { self.checkLocationAuthorization(status: CLLocationManager.authorizationStatus()) }
        })
        session.addresses?.addresses.forEach({ (address) in
            addresses.addAction(UIAlertAction(title: address.address, style: .default, handler: { (action) in
                DispatchQueue.main.async {
                    let location = CLLocation(latitude: CLLocationDegrees(Double(address.latitude)!), longitude: CLLocationDegrees(Double(address.longitude)!))
                    self.selectedLocation = location
                    self.getRestaurants(location: location)
                }
            }))
        })
        addresses.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { (action) in }))
        if let window = UIApplication.shared.keyWindow {
            window.rootViewController?.present(addresses, animated: true, completion: nil)
        }
    }
    
    func setupNavigationBar(){
        self.navigationController?.navigationBar.backgroundColor = Colors.colorWhite
        self.navigationController?.navigationBar.barTintColor = Colors.colorWhite
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationItem.title = "Restaurants"
        
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.black]
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : Colors.colorDarkGray]
        
        let barButtonAppearance = UIBarButtonItem.appearance()
        barButtonAppearance.setTitleTextAttributes([.foregroundColor : UIColor.clear], for: .normal)
        
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
            statusBar.backgroundColor = Colors.colorWhite
            UIApplication.shared.keyWindow?.addSubview(statusBar)
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
            self.getRestaurants(location: location)
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
            self.getRestaurants(location: location)
            let alert = UIAlertController(title: "Please, Go to settings and allow this app to use your location", message: nil, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.selectedLocation = location
        self.getRestaurants(location: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.checkLocationAuthorization(status: CLLocationManager.authorizationStatus())
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let location = CLLocation(latitude: CLLocationDegrees(Double((session.addresses?.addresses[0].latitude)!)!), longitude: CLLocationDegrees(Double((session.addresses?.addresses[0].longitude)!)!))
        self.selectedLocation = location
        self.getRestaurants(location: location)
        Toast.makeToast(message: error.localizedDescription, duration: Toast.LONG_LENGTH_DURATION, style: .error)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! RestaurantViewCell
        let restaurant = self.restaurants[indexPath.item]
        cell.branch = restaurant
        cell.menus = restaurant.menus.menus
        cell.controller = self
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! SpinnerViewCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let branch = self.restaurants[indexPath.item]
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let restaurantViewController = storyboard.instantiateViewController(withIdentifier: "RestaurantView") as! RestaurantViewController
        restaurantViewController.restaurant = branch
        self.navigationController?.pushViewController(restaurantViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.spinnerViewHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if !self.restaurants.isEmpty {
            
            let branch = self.restaurants[indexPath.item]
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
            
            let cellHeight: CGFloat = 2 + 20 + 4 + 8 + 45 + 8 + 26 + 8 + 26 + branchNameRect.height + branchAddressRect.height + 16 + valueToAdd
            
            return CGSize(width: view.frame.width, height: cellHeight)
        }
        return CGSize(width: view.frame.width, height: 210)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    }
    
    @objc func openRestaurantMap(){
        if let window = UIApplication.shared.keyWindow {
            let startingPoint = mapFloatingButton.convert(mapFloatingButton.center, to: self.view)
            circleView.frame = Functions.frameForCircle(withViewCenter: window.center, size: window.frame.size, startPoint: startingPoint)
            circleView.layer.cornerRadius = circleView.frame.size.height / 2
            circleView.center = startingPoint
            
            isMapOpened = true
            window.windowLevel = UIWindow.Level.statusBar
            mapView.mapCenter = self.selectedLocation
            mapView.frame = window.frame
            mapView.center = window.center
            mapView.restaurants = self.restaurants
            mapView.restaurant = self.selectedBranch
            window.addSubview(mapView)
        }
    }
    
    @objc func closeRestaurantMap(){
        UIApplication.shared.keyWindow?.windowLevel = UIWindow.Level.normal
        self.mapView.closeImageView.removeFromSuperview()
        self.mapView.closeButtonView.removeFromSuperview()
        self.mapView.removeFromSuperview()
        isMapOpened = false
        mapCenter = nil
        selectedBranch = nil
    }
    
    public func navigateToRestaurant(restaurant: Branch){
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let userViewController = storyboard.instantiateViewController(withIdentifier: "RestaurantView") as! RestaurantViewController
        self.navigationController?.pushViewController(userViewController, animated: true)
    }
}

class SpinnerViewCell: UICollectionViewCell {
    
    let spinnerView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.colorWhite
        return view
    }()
    
    let indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .gray)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    func setup(){
        spinnerView.frame = self.frame
        spinnerView.center = self.center
        indicatorView.startAnimating()
        indicatorView.center = spinnerView.center
        spinnerView.addSubview(indicatorView)
        addSubview(spinnerView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
