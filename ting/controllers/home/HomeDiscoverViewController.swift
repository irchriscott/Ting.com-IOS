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
    
    let recommandedRestaurantsHeaderCellId = "recommandedRestaurantsHeaderCellId"
    let recommandedRestaurantsContainerCellId = "recommandedRestaurantsContainerCellId"
    
    let cuisinesHeaderCellId = "cuisineHeaderCellId"
    let cuisinesContainerCellId = "cuisineContainerCellId"
    
    let promotionsHeaderCellId = "promotionsHeaderCellId"
    let promotionsContainerCellId = "promotionsContainerCellId"
    
    let collectionViewHeaderId = "collectionViewHeaderId"
    let recommandedRestaurantCellId = "recommandedRestaurantCellId"
    let cellIdCuisine = "cellIdCuisine"
    
    private var recommandedRestaurants: [Branch] = []
    private var cuisines: [RestaurantCategory] = []
    private var promotions: [MenuPromotion] = []
    
    private let headerTitles = ["Recommanded Restaurants", "Cuisines", "Today's Promotions"]
    
    var locationManager = CLLocationManager()
    var refresherLoadingView = UIRefreshControl()
    
    let session = UserAuthentication().get()!
    var selectedLocation: CLLocation?
    
    private var country: String!
    private var town: String!
    
    private var hasLoadedPromotions: Bool = false
    private var loadedRows:[Int] = []
    
    private lazy var recommandedRestaurantsView: UICollectionView = {
        let carouselFlow = UICollectionViewCarouselLayout()
        carouselFlow.itemSize = CGSize(width: 200, height: 328)
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
    
    private lazy var cuisinesCollectionView: UICollectionView = {
        let layout =  UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
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
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.recommandedRestaurantsHeaderCellId)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.recommandedRestaurantsContainerCellId)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.cuisinesHeaderCellId)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.cuisinesContainerCellId)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.promotionsHeaderCellId)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.promotionsContainerCellId)
        
        recommandedRestaurantsView.register(RecommandedRestaurantViewCell.self, forCellWithReuseIdentifier: self.recommandedRestaurantCellId)
        cuisinesCollectionView.register(CuisineViewCell.self, forCellWithReuseIdentifier: self.cellIdCuisine)
        
        self.getRecommandedRestaurants()
        
        self.cuisines = LocalData.instance.getCuisines()
        self.cuisinesCollectionView.reloadData()
        self.getCuisines()
        
        self.getTodayPromotions()
        
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
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
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
        getCuisines()
        getTodayPromotions()
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
    
    private func getCuisines() {
        APIDataProvider.instance.getCuisines { (restaurantCategories) in
            DispatchQueue.main.async {
                if self.cuisines.isEmpty {
                    self.cuisines = restaurantCategories
                    self.collectionView.reloadData()
                    self.cuisinesCollectionView.reloadData()
                }
            }
        }
    }
    
    private func getTodayPromotions() {
        APIDataProvider.instance.getTodayPromotions(country: country, town: town) { (promos) in
            DispatchQueue.main.async {
                self.hasLoadedPromotions = true
                self.refresherLoadingView.endRefreshing()
                self.promotions = promos
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
            return 6
        case self.recommandedRestaurantsView:
            return self.recommandedRestaurants.isEmpty ? 3 : self.recommandedRestaurants.count
        case self.cuisinesCollectionView:
            return self.cuisines.isEmpty ? 4 : self.cuisines.count
        default:
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case self.collectionView:
            let headerTitle: UILabel = {
                let view = UILabel()
                view.translatesAutoresizingMaskIntoConstraints = false
                view.font = UIFont(name: "Poppins-SemiBold", size: 18)
                view.textColor = Colors.colorDarkGray
                return view
            }()
            switch indexPath.row {
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.recommandedRestaurantsHeaderCellId, for: indexPath)
                headerTitle.text = self.headerTitles[0]
                
                cell.addSubview(headerTitle)
                cell.addConstraintsWithFormat(format: "H:|-12-[v0]", views: headerTitle)
                cell.addConstraintsWithFormat(format: "V:[v0]", views: headerTitle)
                cell.addConstraint(NSLayoutConstraint(item: cell, attribute: .centerY, relatedBy: .equal, toItem: headerTitle, attribute: .centerY, multiplier: 1, constant: 0))
                return cell
            case 1:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.recommandedRestaurantsContainerCellId, for: indexPath)
                cell.addSubview(recommandedRestaurantsView)
                cell.addConstraintsWithFormat(format: "V:|[v0]|", views: recommandedRestaurantsView)
                cell.addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: recommandedRestaurantsView)
                return cell
            case 2:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cuisinesHeaderCellId, for: indexPath)
                headerTitle.text = self.headerTitles[1]
                
                cell.addSubview(headerTitle)
                cell.addConstraintsWithFormat(format: "H:|-12-[v0]", views: headerTitle)
                cell.addConstraintsWithFormat(format: "V:[v0]", views: headerTitle)
                cell.addConstraint(NSLayoutConstraint(item: cell, attribute: .centerY, relatedBy: .equal, toItem: headerTitle, attribute: .centerY, multiplier: 1, constant: 0))
                return cell
            case 3:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cuisinesContainerCellId, for: indexPath)
                cell.addSubview(cuisinesCollectionView)
                cell.addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: cuisinesCollectionView)
                cell.addConstraintsWithFormat(format: "V:|[v0]|", views: cuisinesCollectionView)
                return cell
            case 4:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.promotionsHeaderCellId, for: indexPath)
                headerTitle.text = self.headerTitles[2]
                
                cell.addSubview(headerTitle)
                cell.addConstraintsWithFormat(format: "H:|-12-[v0]", views: headerTitle)
                cell.addConstraintsWithFormat(format: "V:[v0]", views: headerTitle)
                cell.addConstraint(NSLayoutConstraint(item: cell, attribute: .centerY, relatedBy: .equal, toItem: headerTitle, attribute: .centerY, multiplier: 1, constant: 0))
                return cell
            case 5:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.promotionsContainerCellId, for: indexPath)
                let viewShimmer: UIView = {
                    let view = UIView()
                    view.translatesAutoresizingMaskIntoConstraints = false
                    view.backgroundColor = Colors.colorVeryLightGray
                    view.layer.cornerRadius = 5.0
                    view.layer.masksToBounds = true
                    view.clipsToBounds = true
                    return view
                }()
                
                if self.promotions.isEmpty && !self.hasLoadedPromotions {
                    
                    cell.addSubview(viewShimmer)
                    cell.addConstraintsWithFormat(format: "V:|[v0]|", views: viewShimmer)
                    cell.addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: viewShimmer)
                    
                    let shimmerView = ShimmeringView(frame: CGRect(x: 12, y: 0, width: self.view.frame.width - 24, height: 230))
                    
                    cell.addSubview(shimmerView)
                    
                    shimmerView.contentView = viewShimmer
                    shimmerView.shimmerAnimationOpacity = 0.4
                    shimmerView.shimmerSpeed = 250
                    shimmerView.isShimmering = true
                    
                } else if !self.promotions.isEmpty && self.hasLoadedPromotions {
                    var carouselSlides: [CarouselSlide] = []
                    for promo in self.promotions {
                        carouselSlides.append(CarouselSlide(promotion: promo, onClick: { (index) in
                            let promotion = self.promotions[index]
                            let storyboard = UIStoryboard(name: "Home", bundle: nil)
                            let promotionController = storyboard.instantiateViewController(withIdentifier: "PromotionMenuView") as! PromotionMenuViewController
                            promotionController.promotion = promotion
                            promotionController.controller = self
                            self.navigationController?.pushViewController(promotionController, animated: true)
                        }))
                    }
                    let promotionsCarouselView : CarouselView = {
                        let view = CarouselView()
                        view.translatesAutoresizingMaskIntoConstraints = false
                        view.slides = carouselSlides
                        view.rowSize = CGSize(width: self.view.frame.width, height: 230)
                        return view
                    }()
                    
                    promotionsCarouselView.interval = 8.0
                    promotionsCarouselView.start()
                    promotionsCarouselView.disableTap()
                    
                    cell.addSubview(promotionsCarouselView)
                    cell.addConstraintsWithFormat(format: "V:|[v0]|", views: promotionsCarouselView)
                    cell.addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: promotionsCarouselView)
                    
                    viewShimmer.removeFromSuperview()
                    
                    let showMoreButton: UITextView = {
                        let view = UITextView()
                        view.translatesAutoresizingMaskIntoConstraints = false
                        view.text = "Show More".uppercased()
                        view.textColor = Colors.colorWhite
                        view.font = UIFont(name: "Poppins-SemiBold", size: 14.0)
                        view.backgroundColor = .clear
                        return view
                    }()
                    
                    cell.addSubview(showMoreButton)
                    cell.addConstraintsWithFormat(format: "V:[v0(25)]-8-|", views: showMoreButton)
                    cell.addConstraintsWithFormat(format: "H:|-18-[v0(100)]", views: showMoreButton)
                    
                    cell.bringSubviewToFront(showMoreButton)
                    showMoreButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showMorePromotions)))
                }
                return cell
            default:
                return collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath)
            }
        case self.recommandedRestaurantsView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.recommandedRestaurantCellId, for: indexPath) as! RecommandedRestaurantViewCell
            let shimmerView = ShimmeringView(frame: CGRect(x: 0, y: 0, width: 200, height: 328))
            let viewShimmer: RecommandedRestaurantShimmerView = {
                let view = RecommandedRestaurantShimmerView()
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            if self.recommandedRestaurants.isEmpty {
                if !self.recommandedRestaurants.isEmpty {
                    cell.addSubview(shimmerView)
                }
                shimmerView.contentView = viewShimmer
                shimmerView.shimmerAnimationOpacity = 0.4
                shimmerView.shimmerSpeed = 250
                shimmerView.isShimmering = true
            } else {
                cell.branch = self.recommandedRestaurants[indexPath.row]
                shimmerView.removeFromSuperview()
                viewShimmer.removeFromSuperview()
            }
            return cell
        case self.cuisinesCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdCuisine, for: indexPath) as! CuisineViewCell
            
            let viewShimmer: UIView = {
                let view = UIView()
                view.translatesAutoresizingMaskIntoConstraints = false
                view.backgroundColor = Colors.colorVeryLightGray
                view.layer.cornerRadius = 5.0
                view.layer.masksToBounds = true
                view.clipsToBounds = true
                return view
            }()
            
            if self.cuisines.isEmpty {
                
                cell.addSubview(viewShimmer)
                cell.addConstraintsWithFormat(format: "V:|[v0]|", views: viewShimmer)
                cell.addConstraintsWithFormat(format: "H:|[v0]|", views: viewShimmer)
                
                let shimmerView = ShimmeringView(frame: CGRect(x: 0, y: 0, width: 125, height: 160))
                cell.addSubview(shimmerView)
                
                shimmerView.contentView = viewShimmer
                shimmerView.shimmerAnimationOpacity = 0.4
                shimmerView.shimmerSpeed = 250
                shimmerView.isShimmering = true
            } else {
                cell.cuisine = self.cuisines[indexPath.row]
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
                return CGSize(width: self.view.frame.width, height: 328)
            case 2:
                return CGSize(width: self.view.frame.width, height: 40)
            case 3:
                return CGSize(width: self.view.frame.width, height: 168)
            case 4:
                return self.promotions.isEmpty && self.hasLoadedPromotions ? CGSize(width: self.view.frame.width, height: 0) : CGSize(width: self.view.frame.width, height: 40)
            case 5:
            return self.promotions.isEmpty && self.hasLoadedPromotions ? CGSize(width: self.view.frame.width, height: 0) : CGSize(width: self.view.frame.width, height: 230)
            default:
                return CGSize(width: self.view.frame.width, height: 0)
            }
        case self.recommandedRestaurantsView:
            return CGSize(width: 200, height: 328)
        case self.cuisinesCollectionView:
            return CGSize(width: 125, height: 160)
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
        case self.cuisinesCollectionView:
            let cuisine = self.cuisines[indexPath.row]
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let cuisineViewController = storyboard.instantiateViewController(withIdentifier: "CuisineView") as! CuisineViewController
            cuisineViewController.cuisine = cuisine
            self.navigationController?.pushViewController(cuisineViewController, animated: true)
            break
        default:
            break
        }
    }
    
    @objc private func showMorePromotions() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let todayPromotionsViewController = storyboard.instantiateViewController(withIdentifier: "TodayPromotions") as! TodayPromotionsViewController
        self.navigationController?.pushViewController(todayPromotionsViewController, animated: true)
    }
}
