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

class HomeDiscoverViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    let cellId = "cellId"
    
    let recommandedRestaurantsHeaderCellId = "recommandedRestaurantsHeaderCellId"
    let recommandedRestaurantsContainerCellId = "recommandedRestaurantsContainerCellId"
    
    let cuisinesHeaderCellId = "cuisineHeaderCellId"
    let cuisinesContainerCellId = "cuisineContainerCellId"
    
    let promotionsHeaderCellId = "promotionsHeaderCellId"
    let promotionsContainerCellId = "promotionsContainerCellId"
    
    let recommandedMenusHeaderCellId = "recommandedMenusHeaderCellId"
    let recommandedMenusContainerCellId = "recommandedMenusContainerCellId"
    
    let topRestaurantsHeaderCellId = "topRestaurantHeaderCellId"
    let topRestaurantsContainerCellId = "topRestaurantContainerCellId"
    
    let topMenusHeaderCellId = "topMenusHeaderCellId"
    let topMenusContainerCellId = "topMenusContainerCellId"
    
    let collectionViewHeaderId = "collectionViewHeaderId"
    let recommandedRestaurantCellId = "recommandedRestaurantCellId"
    
    let cellIdCuisine = "cellIdCuisine"
    
    let recommandedMenuCellId = "recommandedMenuCellId"
    let recommandedMenuShimmerCellId = "recommandedMenuShimmerCellId"
    
    let topRestaurantCellId = "topRestaurantCellId"
    let topRestaurantShimmerCellId = "topRestaurantShimmerCellId"
    
    let topMenuCellId = "topMenuCellId"
    let topMenuShimmerCellId = "topMenuShimmerCellId"
    
    private var recommandedRestaurants: [Branch] = []
    private var cuisines: [RestaurantCategory] = []
    private var promotions: [MenuPromotion] = []
    private var recommandedMenus: [RestaurantMenu] = []
    private var topRestaurants: [Branch] = []
    private var topMenus: [RestaurantMenu] = []
    
    private let headerTitles = ["Recommanded Restaurants", "Cuisines", "Today's Promotions", "Recommanded Menus", "Top Restaurants", "Top Menus"]
    
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
    
    private lazy var recommandedMenusCollectionView: UICollectionView = {
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
    
    lazy var topRestaurantsTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.isScrollEnabled = false
        view.backgroundColor = .white
        return view
    }()
    
    lazy var topMenusTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.isScrollEnabled = false
        view.backgroundColor = .white
        return view
    }()
    
    let placementFloatingButton: FloatingButton = {
        let view = FloatingButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.icon = UIImage(named: "icon_dot_filled_25_white")
        view.imageFrame = CGRect(x: 0, y: 0, width: 15, height: 15)
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
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.recommandedMenusHeaderCellId)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.recommandedMenusContainerCellId)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.topRestaurantsHeaderCellId)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.topRestaurantsContainerCellId)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.topMenusHeaderCellId)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.topMenusContainerCellId)
        
        recommandedRestaurantsView.register(RecommandedRestaurantViewCell.self, forCellWithReuseIdentifier: self.recommandedRestaurantCellId)
        cuisinesCollectionView.register(CuisineViewCell.self, forCellWithReuseIdentifier: self.cellIdCuisine)
        recommandedMenusCollectionView.register(RecommandedMenuViewCell.self, forCellWithReuseIdentifier: self.recommandedMenuCellId)
        recommandedMenusCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.recommandedMenuShimmerCellId)
        
        topRestaurantsTableView.register(CuisineRestaurantViewCell.self, forCellReuseIdentifier: self.topRestaurantCellId)
        topRestaurantsTableView.register(UITableViewCell.self, forCellReuseIdentifier: self.topRestaurantShimmerCellId)
        
        topMenusTableView.register(RestaurantMenuViewCell.self, forCellReuseIdentifier: self.topMenuCellId)
        topMenusTableView.register(UITableViewCell.self, forCellReuseIdentifier: self.topMenuShimmerCellId)
        
        self.getRecommandedRestaurants()
        
        self.cuisines = LocalData.instance.getCuisines()
        self.cuisinesCollectionView.reloadData()
        self.getCuisines()
        
        self.getTodayPromotions()
        
        self.getRecommandedMenus()
        
        self.getTopMenus()
        
        refresherLoadingView.addTarget(self, action: #selector(refreshDiscovery), for: UIControl.Event.valueChanged)
        collectionView.addSubview(refresherLoadingView)
        
        let tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 50
        
        self.view.addSubview(placementFloatingButton)
        self.view.addConstraintsWithFormat(format: "H:[v0(50)]-12-|", views: placementFloatingButton)
        self.view.addConstraintsWithFormat(format: "V:[v0(50)]-\(tabBarHeight + 12)-|", views: placementFloatingButton)
        
        
        placementFloatingButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navigateToPlacement)))
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
        refresherLoadingView.beginRefreshing()
        
        recommandedRestaurants = []
        promotions = []
        recommandedMenus = []
        topRestaurants = []
        topMenus = []
        
        getRecommandedRestaurants()
        getCuisines()
        getTodayPromotions()
        getRecommandedMenus()
        getTopRestaurants(location: self.selectedLocation)
        getTopMenus()
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
    
    private func getRecommandedMenus() {
        APIDataProvider.instance.getRecommandedMenus(country: country, town: town) { (menus) in
            DispatchQueue.main.async {
                self.recommandedMenus = menus
                self.refresherLoadingView.endRefreshing()
                self.recommandedMenusCollectionView.reloadData()
                self.collectionView.reloadData()
            }
        }
    }
    
    private func getTopRestaurants(location: CLLocation?) {
        APIDataProvider.instance.getTopRestaurants(country: country, town: town) { (branches) in
            DispatchQueue.main.async {
                if let userLocation = location {
                    for var branch in branches {
                        let branchLocation = CLLocation(latitude: CLLocationDegrees(exactly: Double(branch.latitude)!)!, longitude: CLLocationDegrees(exactly: Double(branch.longitude)!)!)
                        branch.dist = Double(branchLocation.distance(from: userLocation) / 1000).rounded(toPlaces: 2)
                        if !self.topRestaurants.contains(where: { (b) -> Bool in
                            return b.id == branch.id
                        }){ self.topRestaurants.append(branch) }
                    }
                } else { for var branch in self.topRestaurants { branch.dist = 0.00 } }
                
                self.refresherLoadingView.endRefreshing()
                self.topRestaurantsTableView.reloadData()
                self.collectionView.reloadData()
            }
        }
    }
    
    private func getTopMenus() {
        APIDataProvider.instance.getTopMenus(country: country, town: town) { (menus) in
            DispatchQueue.main.async {
                self.topMenus = menus
                self.refresherLoadingView.endRefreshing()
                self.topMenusTableView.reloadData()
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
            self.getTopRestaurants(location: location)
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
            self.getTopRestaurants(location: location)
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
            self.getTopRestaurants(location: self.selectedLocation)
            return
        }
        self.selectedLocation = location
        self.getTopRestaurants(location: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.checkLocationAuthorization(status: CLLocationManager.authorizationStatus())
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let location = CLLocation(latitude: CLLocationDegrees(Double((session.addresses?.addresses[0].latitude)!)!), longitude: CLLocationDegrees(Double((session.addresses?.addresses[0].longitude)!)!))
        self.selectedLocation = location
        self.getTopRestaurants(location: location)
        Toast.makeToast(message: error.localizedDescription, duration: Toast.LONG_LENGTH_DURATION, style: .error)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.collectionView:
            return self.promotions.isEmpty && self.hasLoadedPromotions ? 10 : 12
        case self.recommandedRestaurantsView:
            return self.recommandedRestaurants.isEmpty ? 3 : self.recommandedRestaurants.count
        case self.cuisinesCollectionView:
            return self.cuisines.isEmpty ? 4 : self.cuisines.count
        case self.recommandedMenusCollectionView:
            return self.recommandedMenus.isEmpty ? 2 : self.recommandedMenus.count
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
            
            if self.promotions.isEmpty && self.hasLoadedPromotions {
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
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.recommandedMenusHeaderCellId, for: indexPath)
                    headerTitle.text = self.headerTitles[3]
                    
                    cell.addSubview(headerTitle)
                    cell.addConstraintsWithFormat(format: "H:|-12-[v0]", views: headerTitle)
                    cell.addConstraintsWithFormat(format: "V:[v0]", views: headerTitle)
                    cell.addConstraint(NSLayoutConstraint(item: cell, attribute: .centerY, relatedBy: .equal, toItem: headerTitle, attribute: .centerY, multiplier: 1, constant: 0))
                    return cell
                case 5:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.recommandedMenusContainerCellId, for: indexPath)
                    cell.addSubview(recommandedMenusCollectionView)
                    cell.addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: recommandedMenusCollectionView)
                    cell.addConstraintsWithFormat(format: "V:|[v0]|", views: recommandedMenusCollectionView)
                    return cell
                case 6:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.topRestaurantsHeaderCellId, for: indexPath)
                    headerTitle.text = self.headerTitles[4]
                    
                    cell.addSubview(headerTitle)
                    cell.addConstraintsWithFormat(format: "H:|-12-[v0]", views: headerTitle)
                    cell.addConstraintsWithFormat(format: "V:[v0]", views: headerTitle)
                    cell.addConstraint(NSLayoutConstraint(item: cell, attribute: .centerY, relatedBy: .equal, toItem: headerTitle, attribute: .centerY, multiplier: 1, constant: 0))
                    
                    return cell
                case 7:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.topRestaurantsContainerCellId, for: indexPath)
                    cell.addSubview(topRestaurantsTableView)
                    cell.addConstraintsWithFormat(format: "H:|[v0]|", views: topRestaurantsTableView)
                    cell.addConstraintsWithFormat(format: "V:|[v0]|", views: topRestaurantsTableView)
                    return cell
                case 8:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.topMenusHeaderCellId, for: indexPath)
                    headerTitle.text = self.headerTitles[5]
                    
                    cell.addSubview(headerTitle)
                    cell.addConstraintsWithFormat(format: "H:|-12-[v0]", views: headerTitle)
                    cell.addConstraintsWithFormat(format: "V:[v0]", views: headerTitle)
                    cell.addConstraint(NSLayoutConstraint(item: cell, attribute: .centerY, relatedBy: .equal, toItem: headerTitle, attribute: .centerY, multiplier: 1, constant: 0))
                    return cell
                case 9:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.topMenusContainerCellId, for: indexPath)
                    cell.addSubview(topMenusTableView)
                    cell.addConstraintsWithFormat(format: "H:|[v0]|", views: topMenusTableView)
                    cell.addConstraintsWithFormat(format: "V:|[v0]|", views: topMenusTableView)
                    return cell
                default:
                    return collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath)
                }
            } else {
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
                case 6:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.recommandedMenusHeaderCellId, for: indexPath)
                    headerTitle.text = self.headerTitles[3]
                    
                    cell.addSubview(headerTitle)
                    cell.addConstraintsWithFormat(format: "H:|-12-[v0]", views: headerTitle)
                    cell.addConstraintsWithFormat(format: "V:[v0]", views: headerTitle)
                    cell.addConstraint(NSLayoutConstraint(item: cell, attribute: .centerY, relatedBy: .equal, toItem: headerTitle, attribute: .centerY, multiplier: 1, constant: 0))
                    return cell
                case 7:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.recommandedMenusContainerCellId, for: indexPath)
                    cell.addSubview(recommandedMenusCollectionView)
                    cell.addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: recommandedMenusCollectionView)
                    cell.addConstraintsWithFormat(format: "V:|[v0]|", views: recommandedMenusCollectionView)
                    return cell
                case 8:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.topRestaurantsHeaderCellId, for: indexPath)
                    headerTitle.text = self.headerTitles[4]
                    
                    cell.addSubview(headerTitle)
                    cell.addConstraintsWithFormat(format: "H:|-12-[v0]", views: headerTitle)
                    cell.addConstraintsWithFormat(format: "V:[v0]", views: headerTitle)
                    cell.addConstraint(NSLayoutConstraint(item: cell, attribute: .centerY, relatedBy: .equal, toItem: headerTitle, attribute: .centerY, multiplier: 1, constant: 0))
                    
                    return cell
                case 9:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.topRestaurantsContainerCellId, for: indexPath)
                    cell.addSubview(topRestaurantsTableView)
                    cell.addConstraintsWithFormat(format: "H:|[v0]|", views: topRestaurantsTableView)
                    cell.addConstraintsWithFormat(format: "V:|[v0]|", views: topRestaurantsTableView)
                    return cell
                case 10:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.topMenusHeaderCellId, for: indexPath)
                    headerTitle.text = self.headerTitles[5]
                    
                    cell.addSubview(headerTitle)
                    cell.addConstraintsWithFormat(format: "H:|-12-[v0]", views: headerTitle)
                    cell.addConstraintsWithFormat(format: "V:[v0]", views: headerTitle)
                    cell.addConstraint(NSLayoutConstraint(item: cell, attribute: .centerY, relatedBy: .equal, toItem: headerTitle, attribute: .centerY, multiplier: 1, constant: 0))
                    return cell
                case 11:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.topMenusContainerCellId, for: indexPath)
                    cell.addSubview(topMenusTableView)
                    cell.addConstraintsWithFormat(format: "H:|[v0]|", views: topMenusTableView)
                    cell.addConstraintsWithFormat(format: "V:|[v0]|", views: topMenusTableView)
                    return cell
                default:
                    return collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath)
                }
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
        case self.recommandedMenusCollectionView:
            
            if !self.recommandedMenus.isEmpty {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.recommandedMenuCellId, for: indexPath) as! RecommandedMenuViewCell
                cell.menu = self.recommandedMenus[indexPath.row]
                return cell
            } else {
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.recommandedMenuShimmerCellId, for: indexPath)
                
                let viewShimmer: RecommandedMenuShimmerView = {
                    let view = RecommandedMenuShimmerView()
                    view.translatesAutoresizingMaskIntoConstraints = false
                    return view
                }()
                
                cell.addSubview(viewShimmer)
                cell.addConstraintsWithFormat(format: "V:|[v0]|", views: viewShimmer)
                cell.addConstraintsWithFormat(format: "H:|[v0]|", views: viewShimmer)
                
                let shimmerView = ShimmeringView(frame: CGRect(x: 0, y: 0, width: 125, height: 160))
                cell.addSubview(shimmerView)
                
                shimmerView.contentView = viewShimmer
                shimmerView.shimmerAnimationOpacity = 0.4
                shimmerView.shimmerSpeed = 250
                shimmerView.isShimmering = true
                
                return cell
            }
            
        default:
            return collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case self.collectionView:
            if self.promotions.isEmpty && self.hasLoadedPromotions {
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
                    return CGSize(width: self.view.frame.width, height: 40)
                case 5:
                    return CGSize(width: self.view.frame.width, height: 240)
                case 6:
                    return CGSize(width: self.view.frame.width, height: 40)
                case 7:
                    if self.topRestaurants.isEmpty {
                        return CGSize(width: self.view.frame.width, height: (94 + 12) * 3)
                    } else {
                        var height: CGFloat = 0
                        for (index, _) in topRestaurants.enumerated() {
                            height += self.restaurantCellViewHeight(index: index)
                        }
                        return CGSize(width: self.view.frame.width, height: height)
                    }
                case 8:
                    return CGSize(width: self.view.frame.width, height: 40)
                case 9:
                    if self.topMenus.isEmpty {
                        return CGSize(width: self.view.frame.width, height: (94 + 12) * 3)
                    } else {
                        var height: CGFloat = 12
                        for (index, _) in topMenus.enumerated() {
                            height += self.restaurantMenuCellHeight(index: index)
                        }
                        return CGSize(width: self.view.frame.width, height: height)
                    }
                default:
                    return CGSize(width: self.view.frame.width, height: 0)
                }
            } else {
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
                    return CGSize(width: self.view.frame.width, height: 40)
                case 5:
                return CGSize(width: self.view.frame.width, height: 230)
                case 6:
                    return CGSize(width: self.view.frame.width, height: 40)
                case 7:
                    return CGSize(width: self.view.frame.width, height: 240)
                case 8:
                    return CGSize(width: self.view.frame.width, height: 40)
                case 9:
                    if self.topRestaurants.isEmpty {
                        return CGSize(width: self.view.frame.width, height: (94 + 12) * 3)
                    } else {
                        var height: CGFloat = 0
                        for (index, _) in topRestaurants.enumerated() {
                            height += self.restaurantCellViewHeight(index: index)
                        }
                        return CGSize(width: self.view.frame.width, height: height)
                    }
                case 10:
                    return CGSize(width: self.view.frame.width, height: 40)
                case 11:
                    if self.topMenus.isEmpty {
                        return CGSize(width: self.view.frame.width, height: (94 + 12) * 3)
                    } else {
                        var height: CGFloat = 12
                        for (index, _) in topMenus.enumerated() {
                            height += self.restaurantMenuCellHeight(index: index)
                        }
                        return CGSize(width: self.view.frame.width, height: height)
                    }
                default:
                    return CGSize(width: self.view.frame.width, height: 0)
                }
            }
        case self.recommandedRestaurantsView:
            return CGSize(width: 200, height: 328)
        case self.cuisinesCollectionView:
            return CGSize(width: 125, height: 160)
        case self.recommandedMenusCollectionView:
            return CGSize(width: 260, height: 240)
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
        case self.recommandedMenusCollectionView:
            let menu = self.recommandedMenus[indexPath.item]
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let menuController = storyboard.instantiateViewController(withIdentifier: "RestaurantMenuView") as! RestaurantMenuViewController
            menuController.restaurantMenu = menu
            menuController.controller = self
            self.navigationController?.pushViewController(menuController, animated: true)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.topRestaurantsTableView:
            return self.topRestaurants.isEmpty ? 3 : self.topRestaurants.count
        case self.topMenusTableView:
            return self.topMenus.isEmpty ? 3 : self.topMenus.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case self.topRestaurantsTableView:
            if !self.topRestaurants.isEmpty {
                let cell = tableView.dequeueReusableCell(withIdentifier: self.topRestaurantCellId, for: indexPath) as! CuisineRestaurantViewCell
                cell.selectionStyle = .none
                cell.branch = self.topRestaurants[indexPath.row]
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: self.topRestaurantCellId, for: indexPath)
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
        case self.topMenusTableView:
            if !self.topMenus.isEmpty {
                let cell = tableView.dequeueReusableCell(withIdentifier: self.topMenuCellId, for: indexPath) as! RestaurantMenuViewCell
                cell.selectionStyle = .none
                cell.restaurantMenu = self.topMenus[indexPath.row]
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: self.topMenuShimmerCellId, for: indexPath)
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
        default:
            return tableView.dequeueReusableCell(withIdentifier: self.topMenuShimmerCellId, for: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case self.topRestaurantsTableView:
            return !self.topRestaurants.isEmpty ? self.restaurantCellViewHeight(index: indexPath.row) : 94 + 12
        case self.topMenusTableView:
            return !self.topMenus.isEmpty ? self.restaurantMenuCellHeight(index: indexPath.row) : 94 + 12
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case self.topRestaurantsTableView:
            if !self.topRestaurants.isEmpty {
                let branch = self.topRestaurants[indexPath.row]
                let storyboard = UIStoryboard(name: "Home", bundle: nil)
                let restaurantViewController = storyboard.instantiateViewController(withIdentifier: "RestaurantView") as! RestaurantViewController
                restaurantViewController.restaurant = branch
                self.navigationController?.pushViewController(restaurantViewController, animated: true)
            }
            break
        case self.topMenusTableView:
            if !self.topMenus.isEmpty {
                let menu = self.topMenus[indexPath.item]
                let storyboard = UIStoryboard(name: "Home", bundle: nil)
                let menuController = storyboard.instantiateViewController(withIdentifier: "RestaurantMenuView") as! RestaurantMenuViewController
                menuController.restaurantMenu = menu
                menuController.controller = self
                self.navigationController?.pushViewController(menuController, animated: true)
            }
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
    
    private func restaurantCellViewHeight(index: Int) -> CGFloat {
        
        let branch = self.topRestaurants[index]
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
    
    private func restaurantMenuCellHeight(index: Int) -> CGFloat {
        
        let device = UIDevice.type
        
        var menuNameTextSize: CGFloat = 15
        var menuDescriptionTextSize: CGFloat = 13
        var menuImageConstant: CGFloat = 80
        
        let menu = self.topMenus[index]
        
        let heightConstant: CGFloat = 12 + 25 + 1 + 4 + 4 + 4 + 1 + 8 + 8 + 8 + 8 + 26 + 26 + 12
        
        if UIDevice.smallDevices.contains(device) {
            menuImageConstant = 55
            menuNameTextSize = 14
            menuDescriptionTextSize = 12
        } else if UIDevice.mediumDevices.contains(device) {
            menuImageConstant = 70
            menuNameTextSize = 15
            menuDescriptionTextSize = 12
        }
        
        let frameWidth = view.frame.width - (60 + menuImageConstant)
        
        let menuNameRect = NSString(string: (menu.menu?.name!)!).boundingRect(with: CGSize(width: frameWidth, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: menuNameTextSize)!], context: nil)
        
        let menuDescriptionRect = NSString(string: (menu.menu?.description!)!).boundingRect(with: CGSize(width: frameWidth - 18, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: menuDescriptionTextSize)!], context: nil)
        
        var menuPriceHeight: CGFloat = 16
        
        let priceRect = NSString(string: "UGX 10,000").boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: 27)!], context: nil)
        
        let quantityRect = NSString(string: "2 packs / counts").boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 12)!], context: nil)
        
        let lastPriceRect = NSString(string: "UGX 6,000").boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 12)!], context: nil)
        
        if (menu.menu?.isCountable)! && Double((menu.menu?.price)!) != Double((menu.menu?.lastPrice)!) {
            menuPriceHeight += priceRect.height + quantityRect.height + lastPriceRect.height
        } else if !(menu.menu?.isCountable)! && Double((menu.menu?.price)!) != Double((menu.menu?.lastPrice)!) {
            menuPriceHeight += priceRect.height + lastPriceRect.height + 4
        } else if (menu.menu?.isCountable)! && !(Double((menu.menu?.price)!) != Double((menu.menu?.lastPrice)!)) {
            menuPriceHeight += priceRect.height + quantityRect.height + 4
        } else { menuPriceHeight += priceRect.height + 4 }
        
        return heightConstant + menuNameRect.height + menuDescriptionRect.height + CGFloat(menuPriceHeight)
    }
    
    @objc private func navigateToPlacement() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let tableScannerViewController = storyboard.instantiateViewController(withIdentifier: "TableScannerView") as! TableScannerViewController
        tableScannerViewController.controller = self.navigationController
        tableScannerViewController.modalPresentationStyle = .overFullScreen
        self.present(tableScannerViewController, animated: true, completion: nil)
    }
}
