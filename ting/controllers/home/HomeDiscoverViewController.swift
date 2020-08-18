//
//  HomeDiscoverViewController.swift
//  ting
//
//  Created by Ir Christian Scott on 06/08/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit
import MapKit
import ToosieSlide
import ShimmerSwift

class HomeDiscoverViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate {
    
    let cellId = "cellId"
    
    let collectionViewHeaderId = "collectionViewHeaderId"
    let recommandedRestaurantCellId = "recommandedRestaurantCellId"
    
    private var recommandedRestaurants: [Branch] = []
    
    private let headerTitles = ["Recommanded Restaurants"]
    
    var locationManager = CLLocationManager()
    var refresherLoadingView = UIRefreshControl()
    
    let session = UserAuthentication().get()!
    var selectedLocation: CLLocation?
    
    private var country: String!
    private var town: String!
    
    private lazy var recommandedRestaurantsView: UICollectionView = {
        let carouselFlow = UICollectionViewCarouselLayout()
        carouselFlow.itemSize = CGSize(width: 200, height: 320)
        carouselFlow.minimumLineSpacing = 0
        let view = UICollectionView(collectionViewCarouselLayout: carouselFlow)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        view.showsHorizontalScrollIndicator = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNavigationBar()
        
        country = session.country
        town = session.town
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.checkLocationAuthorization(status: CLLocationManager.authorizationStatus())
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.cellId)
        recommandedRestaurantsView.register(RecommandedRestaurantViewCell.self, forCellWithReuseIdentifier: self.recommandedRestaurantCellId)
        recommandedRestaurantsView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: self.collectionViewHeaderId)
        
        self.getRecommandedRestaurants()
        
        refresherLoadingView.addTarget(self, action: #selector(refreshDiscovery), for: UIControl.Event.valueChanged)
        collectionView.addSubview(refresherLoadingView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupNavigationBar()
    }

    func setupNavigationBar(){
        
        self.navigationController?.navigationBar.backgroundColor = Colors.colorWhite
        self.navigationController?.navigationBar.barTintColor = Colors.colorWhite
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationItem.title = "Discovery"
        
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
    
    @objc func refreshDiscovery(){
        getRecommandedRestaurants()
    }
    
    private func getRecommandedRestaurants() {
        APIDataProvider.instance.getRecommandedRestaurants(country: country, town: town) { (branches) in
            DispatchQueue.main.async {
                self.refresherLoadingView.endRefreshing()
                self.recommandedRestaurants = branches
                self.recommandedRestaurantsView.reloadData()
                self.collectionView.reloadData()
            }
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
            //CALL GET RESTAURANTS
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
            //CALL GET RESTAURANTS
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
            //CALL GET RESTAURANTS
            return
        }
        self.selectedLocation = location
        //CALL GET RESTAURANTS
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.checkLocationAuthorization(status: CLLocationManager.authorizationStatus())
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let location = CLLocation(latitude: CLLocationDegrees(Double((session.addresses?.addresses[0].latitude)!)!), longitude: CLLocationDegrees(Double((session.addresses?.addresses[0].longitude)!)!))
        self.selectedLocation = location
        //CALL GET RESTAURANTS
        Toast.makeToast(message: error.localizedDescription, duration: Toast.LONG_LENGTH_DURATION, style: .error)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.collectionView:
            return 12
        case self.recommandedRestaurantsView:
            return self.recommandedRestaurants.isEmpty ? 3 : self.recommandedRestaurants.count
        default:
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case self.collectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath)
            let headerTitle: UILabel = {
                let view = UILabel()
                view.translatesAutoresizingMaskIntoConstraints = false
                view.font = UIFont(name: "Poppins-SemiBold", size: 18)
                view.textColor = Colors.colorDarkGray
                return view
            }()
            switch indexPath.row {
            case 0:
                headerTitle.text = self.headerTitles[0]
                
                cell.addSubview(headerTitle)
                cell.addConstraintsWithFormat(format: "H:|-20-[v0]", views: headerTitle)
                cell.addConstraintsWithFormat(format: "V:[v0]", views: headerTitle)
                cell.addConstraint(NSLayoutConstraint(item: cell, attribute: .centerY, relatedBy: .equal, toItem: headerTitle, attribute: .centerY, multiplier: 1, constant: 0))
                break
            case 1:
                cell.addSubview(recommandedRestaurantsView)
                cell.addConstraintsWithFormat(format: "V:|[v0]|", views: recommandedRestaurantsView)
                cell.addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: recommandedRestaurantsView)
                break
            default:
                break
            }
            
            return cell
        case self.recommandedRestaurantsView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.recommandedRestaurantCellId, for: indexPath) as! RecommandedRestaurantViewCell
            if self.recommandedRestaurants.isEmpty {
                let shimmerView = ShimmeringView(frame: CGRect(x: 0, y: 0, width: 200, height: 320))
                cell.addSubview(shimmerView)
                
                let view: UIView = {
                    let view = UIView()
                    view.translatesAutoresizingMaskIntoConstraints = false
                    view.backgroundColor = .clear
                    return view
                }()
                
                shimmerView.contentView = view
                shimmerView.shimmerAnimationOpacity = 0.4
                shimmerView.shimmerSpeed = 250
                shimmerView.isShimmering = true
            } else {
                cell.branch = self.recommandedRestaurants[indexPath.row]
            }
            return cell
        default:
            return collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case self.collectionView:
            switch indexPath.item {
            case 0:
                return CGSize(width: self.view.frame.width, height: 40)
            case 1:
                return CGSize(width: self.view.frame.width, height: 320)
            default:
                return CGSize(width: self.view.frame.width, height: 0)
            }
        case self.recommandedRestaurantsView:
            return CGSize(width: 200, height: 320)
        default:
            return CGSize(width: self.view.frame.width, height: 0)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case self.recommandedRestaurantsView:
            if !self.recommandedRestaurants.isEmpty {
                let branch = self.recommandedRestaurants[indexPath.row]
                let storyboard = UIStoryboard(name: "Home", bundle: nil)
                let restaurantViewController = storyboard.instantiateViewController(withIdentifier: "RestaurantView") as! RestaurantViewController
                restaurantViewController.restaurant = branch
                self.navigationController?.pushViewController(restaurantViewController, animated: true)
                break
            }
            break
        default:
            break
        }
    }
}
