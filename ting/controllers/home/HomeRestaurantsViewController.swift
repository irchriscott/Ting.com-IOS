//
//  HomeRestaurantsViewController.swift
//  ting
//
//  Created by Ir Christian Scott on 06/08/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit
import MapKit
import GradientLoadingBar
import ShimmerSwift
import FittedSheets

class HomeRestaurantsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate, UITextFieldDelegate {
    
    typealias FilterGroup = [Any]
    
    let cellId = "cellId"
    
    let cellIdCuisine = "cellIdCuisine"
    let cellIdFilter = "cellIdFilter"
    let cellIdShimmer = "cellIdShimmer"
    let cellIdRestaurant = "cellIdRestaurant"
    
    let footerIdRestaurant = "footerIdRestaurant"
    
    var cuisines: [RestaurantCategory] = []
    let filters: [FilterGroup] = [
        [0, "icon_marker_25_gray", "Distance"],
        [1, "icon_clock_25_gray", "Availability"],
        [2, "icon_cuisines_36_gray", "Cuisines"],
        [3, "icon_glass_100_gray", "Services"],
        [4, "icon_wifi_25_gray", "Specials"],
        [5, "icon_categories_36_gray", "Types"],
        [6, "icon_menu_reviews_32_gray", "Ratings"]
    ]
    
    var filterValues: RestaurantFilters?
    
    var spinnerViewHeight: CGFloat = 36
    var restaurants: [Branch] = []
    
    var locationManager = CLLocationManager()
    var refresherLoadingView = UIRefreshControl()
    var selectedLocation: CLLocation?
    
    let session = UserAuthentication().get()!
    var isMapOpened: Bool = false
    var mapCenter: CLLocation?
    var selectedBranch: Branch?
    
    var country: String!
    var town: String!
    
    var gradientLoadingBar: GradientLoadingBar!
    
    let appWindow = UIApplication.shared.keyWindow
    
    let mapFloatingButton: FloatingButton = {
        let view = FloatingButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.icon = UIImage(named: "icon_addess_white")
        return view
    }()
    
    var mapView: RestaurantMapViewController!
    
    var circleView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.colorDarkTransparent
        return view
    }()
    
    var didLoadWithLocation: Bool = false
    
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
    
    private lazy var filtersCollectionView: UICollectionView = {
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
    
    private lazy var restaurantsShimmerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.isScrollEnabled = false
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var restaurantsCollectionView: UICollectionView = {
        let layout =  UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.isScrollEnabled = false
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var searchView: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.keyboardType = .default
        view.returnKeyType = .search
        view.font = UIFont(name: "Poppins-Regular", size: 14.0)
        view.placeholder = "Search & Filter Restaurants"
        view.textColor = Colors.colorGray
        view.delegate = self
        view.attributedPlaceholder = NSAttributedString(string: "Search & Filter Restaurants", attributes: [NSAttributedString.Key.foregroundColor: Colors.colorLightGray])
        return view
    }()
    
    private var hideKeyboardGesture: UITapGestureRecognizer!
    
    var pageIndex = 1
    var shouldLoad = true
    var isFiltering = false
    
    var loadedRestaurants:[Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.backgroundColor = Colors.colorWhite
        self.navigationController?.navigationBar.barTintColor = Colors.colorWhite
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.didLoadWithLocation = false
        
        self.gradientLoadingBar = GradientLoadingBar(height: 4.0, isRelativeToSafeArea: false)
        
       let searchButton = UIBarButtonItem(image: UIImage(named: "icon_searchbar_25_gray"), style: .plain, target: self, action: #selector(openSearch(_:)))
        searchButton.tintColor = Colors.colorGray
        self.navigationItem.rightBarButtonItem = searchButton
        
        country = session.country
        town = session.town
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        mapView = storyboard.instantiateViewController(withIdentifier: "RestaurantMapView") as? RestaurantMapViewController
        mapView.modalPresentationStyle = .overFullScreen
        mapView.controller = self
        mapView.restaurant = self.selectedBranch
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.checkLocationAuthorization(status: CLLocationManager.authorizationStatus())
        
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        self.cuisinesCollectionView.register(CuisineViewCell.self, forCellWithReuseIdentifier: cellIdCuisine)
        self.filtersCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdFilter)
        self.restaurantsShimmerCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdShimmer)
        self.restaurantsCollectionView.register(RestaurantViewCell.self, forCellWithReuseIdentifier: cellIdRestaurant)
        self.restaurantsCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: self.footerIdRestaurant)
        
        self.searchView.addTarget(self, action: #selector(search(_:)), for: .editingDidEnd)
        
        self.cuisines = LocalData.instance.getCuisines()
        self.cuisinesCollectionView.reloadData()
        self.getCuisines()
        
        self.filterValues = LocalData.instance.getFilters()
        self.filtersCollectionView.reloadData()
        self.getFilters()
        
        hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        
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
        self.didLoadWithLocation = false
        self.locationManager.startUpdatingLocation()
        self.setupNavigationBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.locationManager.stopUpdatingLocation()
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
    
    private func getFilters() {
        APIDataProvider.instance.getFilters { (data) in
            DispatchQueue.main.async {
                if let filters = data {
                    self.filterValues = filters
                }
            }
        }
    }
    
    private func getRestaurants(location: CLLocation?, index: Int){
        self.gradientLoadingBar.fadeIn()
        APIDataProvider.instance.getRestaurants(url: "\(URLs.restaurantsGlobal)?page=\(index)") { (branches) in
            DispatchQueue.main.async {
                self.refresherLoadingView.endRefreshing()
                self.gradientLoadingBar.fadeOut()
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
                    self.collectionView.reloadData()
                    self.restaurantsCollectionView.reloadData()
                    self.restaurantsShimmerCollectionView.reloadData()
                    
                } else { self.shouldLoad = false }
            }
        }
    }
    
    private func searchFilteredRestaurants(location: CLLocation?, index: Int){
        
        let filterParams = LocalData.instance.getFiltersParams()
        
        do {
            let data = try JSONEncoder().encode(filterParams)
            APIDataProvider.instance.searchFilterRestaurants(country: country, town: town, query: searchView.text ?? "", filters: String(data: data, encoding: .utf8)!, page: "\(index)") { (branches) in
                DispatchQueue.main.async {
                    self.appWindow?.rootViewController?.removeSpinner()
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
                        self.collectionView.reloadData()
                        self.restaurantsCollectionView.reloadData()
                        
                    } else {
                        self.shouldLoad = false
                        if self.pageIndex == 1 {
                            self.showErrorMessage(message: "No Result Found", title: "Result")
                            self.isFiltering = false
                            self.getRestaurants(location: self.selectedLocation, index: self.pageIndex)
                        }
                    }
                }
            }
        } catch {
            self.appWindow?.rootViewController?.removeSpinner()
            self.showErrorMessage(message: error.localizedDescription, title: "Error")
        }
    }
    
    @objc func refreshRestaurants(){
        pageIndex = 1
        self.loadedRestaurants = []
        self.restaurants = []
        self.spinnerViewHeight = 0
        self.getRestaurants(location: self.selectedLocation, index: pageIndex)
    }
    
    @objc func showAddresses(){
        let addresses = UIAlertController(title: "Restaurants Near Location", message: nil, preferredStyle: .actionSheet)
        addresses.addAction(UIAlertAction(title: "Current Location", style: .default) { (action) in
            DispatchQueue.main.async { self.checkLocationAuthorization(status: CLLocationManager.authorizationStatus()) }
        })
        session.addresses?.addresses.forEach({ (address) in
            addresses.addAction(UIAlertAction(title: address.address, style: .default, handler: { (action) in
                DispatchQueue.main.async {
                    let location = CLLocation(latitude: CLLocationDegrees(Double(address.latitude)!), longitude: CLLocationDegrees(Double(address.longitude)!))
                    self.pageIndex = 1
                    self.loadedRestaurants = []
                    self.restaurants = []
                    self.spinnerViewHeight = 0
                    self.selectedLocation = location
                    self.getRestaurants(location: location, index: self.pageIndex)
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
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationItem.title = "Restaurants"
        
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
        
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
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
        if !self.didLoadWithLocation {
            self.didLoadWithLocation = true
            self.selectedLocation = location
            self.getRestaurants(location: location, index: pageIndex)
            self.locationManager.stopUpdatingLocation()
        }
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
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.collectionView:
            return 4
        case self.cuisinesCollectionView:
            return self.cuisines.isEmpty ? 4 : self.cuisines.count
        case self.filtersCollectionView:
            return self.filters.count
        case self.restaurantsShimmerCollectionView:
            return restaurants.isEmpty ? 3 : 0
        case self.restaurantsCollectionView:
            return restaurants.count
        default:
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case self.collectionView:
            switch indexPath.row {
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
                cell.backgroundColor = Colors.colorWhite
                
                cell.addSubview(cuisinesCollectionView)
                cell.addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: cuisinesCollectionView)
                cell.addConstraintsWithFormat(format: "V:|[v0]|", views: cuisinesCollectionView)
                
                return cell
            case 1:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
                cell.backgroundColor = Colors.colorWhite
                
                cell.addSubview(filtersCollectionView)
                cell.addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: filtersCollectionView)
                cell.addConstraintsWithFormat(format: "V:|[v0]|", views: filtersCollectionView)
                
                return cell
            case 2:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
                cell.backgroundColor = Colors.colorWhite
                
                let contentView : UIView = {
                    let view = UIView()
                    view.translatesAutoresizingMaskIntoConstraints = false
                    view.layer.borderColor = Colors.colorVeryLightGray.cgColor
                    view.layer.borderWidth = 2.0
                    view.layer.cornerRadius = 5.0
                    view.clipsToBounds = true
                    return view
                }()
                
                let iconView: UIImageView = {
                    let view = UIImageView()
                    view.translatesAutoresizingMaskIntoConstraints = false
                    view.image = UIImage(named: "icon_search_25_gray")
                    view.alpha = 0.4
                    return view
                }()
                
                let filterView: UIView = {
                    let view = UIView()
                    view.translatesAutoresizingMaskIntoConstraints = false
                    view.backgroundColor = Colors.colorDarkTransparent.withAlphaComponent(0.2)
                    view.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
                    view.layer.cornerRadius = 35 / 2
                    view.clipsToBounds = true
                    return view
                }()
                
                let filterIconView: UIImageView = {
                    let view = UIImageView()
                    view.translatesAutoresizingMaskIntoConstraints = false
                    view.image = UIImage(named: "icon_filter_25_gray")
                    view.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
                    view.alpha = 0.7
                    return view
                }()
                
                filterView.addSubview(filterIconView)
                filterView.addConstraintsWithFormat(format: "V:|-7-[v0(22)]-7-|", views: filterIconView)
                filterView.addConstraintsWithFormat(format: "H:|-7-[v0(22)]-7-|", views: filterIconView)
                
                filterView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(filterRestaurants(_:))))
                filterView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(clearFilters(_:))))
                
                contentView.addSubview(iconView)
                contentView.addSubview(searchView)
                
                contentView.addConstraintsWithFormat(format: "V:|-12-[v0(26)]-12-|", views: iconView)
                contentView.addConstraintsWithFormat(format: "V:|-6-[v0(38)]-6-|", views: searchView)
                contentView.addConstraintsWithFormat(format: "H:|-16-[v0(26)]-12-[v1]-|", views: iconView, searchView)
                
                cell.addSubview(contentView)
                cell.addConstraintsWithFormat(format: "V:|[v0]|", views: contentView)
                cell.addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: contentView)
                
                cell.addSubview(filterView)
                cell.addConstraintsWithFormat(format: "H:[v0]-26-|", views: filterView)
                cell.addConstraintsWithFormat(format: "V:|-9-[v0]-9-|", views: filterView)
                
                return cell
            case 3:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
                cell.backgroundColor = Colors.colorWhite
                
                cell.addSubview(restaurantsCollectionView)
                cell.addSubview(restaurantsShimmerCollectionView)
                cell.addConstraintsWithFormat(format: "H:|[v0]|", views: restaurantsCollectionView)
                cell.addConstraintsWithFormat(format: "H:|[v0]|", views: restaurantsShimmerCollectionView)
                cell.addConstraintsWithFormat(format: "V:|[v0]-[v1]|", views: restaurantsShimmerCollectionView, restaurantsCollectionView)
                
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
                cell.backgroundColor = Colors.colorWhite
                return cell
            }
        case self.cuisinesCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdCuisine, for: indexPath) as! CuisineViewCell
            
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
        case self.filtersCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdFilter, for: indexPath)
            
            let filterView : IconTextView = {
                let view = IconTextView()
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            
            let data = self.filters[indexPath.row]
            let filterRect = NSString(string: data[2] as! String).boundingRect(with: CGSize(width: view.frame.width, height: 26), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Medium", size: 12)!], context: nil)
            
            filterView.text = data[2] as! String
            filterView.icon = UIImage(named: data[1] as! String)!
            
            cell.addSubview(filterView)
            cell.addConstraintsWithFormat(format: "V:|-8-[v0(26)]-8-|", views: filterView)
            cell.addConstraintsWithFormat(format: "H:|[v0(\(filterRect.width + 40))]|", views: filterView)
            
            return cell
        case self.restaurantsShimmerCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdShimmer, for: indexPath)
            
            let view: RowShimmerView = {
                let view = RowShimmerView()
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            
            cell.addSubview(view)
            cell.addConstraintsWithFormat(format: "V:|[v0]|", views: view)
            cell.addConstraintsWithFormat(format: "H:|[v0]|", views: view)
            
            let shimmerView = ShimmeringView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 94))
            cell.addSubview(shimmerView)
            
            shimmerView.contentView = view
            shimmerView.shimmerAnimationOpacity = 0.4
            shimmerView.shimmerSpeed = 250
            shimmerView.isShimmering = true
            
            return cell
        case self.restaurantsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdRestaurant, for: indexPath) as! RestaurantViewCell
            let restaurant = self.restaurants[indexPath.row]
            if !self.loadedRestaurants.contains(indexPath.row) {
                cell.controller = self
                cell.branch = restaurant
                cell.backgroundColor = .white
                self.loadedRestaurants.append(indexPath.row)
            }
            return cell
        default:
            return collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case self.cuisinesCollectionView:
            let cuisine = self.cuisines[indexPath.row]
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let cuisineViewController = storyboard.instantiateViewController(withIdentifier: "CuisineView") as! CuisineViewController
            cuisineViewController.cuisine = cuisine
            self.navigationController?.pushViewController(cuisineViewController, animated: true)
            break
        case self.filtersCollectionView:
            
            var selectedFilters: [Filter]!
            
            let data = self.filters[indexPath.row]
            
            switch data[0] as! Int {
            case 0:
                Toast.makeToast(message: "Not Available Yet", duration: Toast.MID_LENGTH_DURATION, style: .default)
                break
            default:
                if let filters = self.filterValues {
                    switch data[0] as! Int {
                    case 1:
                        selectedFilters = filters.availability
                        break
                    case 2:
                        selectedFilters = filters.cuisines
                        break
                    case 3:
                        selectedFilters = filters.services
                        break
                    case 4:
                        selectedFilters = filters.specials
                        break
                    case 5:
                        selectedFilters = filters.types
                        break
                    case 6:
                        selectedFilters = filters.ratings
                        break
                    default:
                        selectedFilters = []
                    }
                    
                    let storyboard = UIStoryboard(name: "Home", bundle: nil)
                    let filtersController = storyboard.instantiateViewController(withIdentifier: "RestaurantFilters") as! RestaurantFiltersViewController
                    filtersController.filters = selectedFilters
                    filtersController.type = data[0] as? Int
                    
                    filtersController.onFilterRestaurants = { filter in
                        if filter {
                            self.appWindow?.rootViewController?.showSpinner(onView: self.appWindow?.rootViewController?.view ?? self.view)
                            
                            self.pageIndex = 1
                            self.loadedRestaurants = []
                            self.restaurants = []
                            self.spinnerViewHeight = 0
                            self.searchFilteredRestaurants(location: self.selectedLocation, index: self.pageIndex)
                        }
                    }
                    
                    var heightPlus: CGFloat = 140
                    if UIDevice.largeNavbarDevices.contains(UIDevice.type) {
                        heightPlus = 160
                    }
                    
                    let sheetController = SheetViewController(controller: filtersController, sizes: [.fixed(CGFloat(CGFloat((50 * selectedFilters.count)) + heightPlus))])
                    sheetController.blurBottomSafeArea = false
                    sheetController.adjustForBottomSafeArea = true
                    sheetController.topCornersRadius = 8
                    sheetController.dismissOnBackgroundTap = true
                    sheetController.extendBackgroundBehindHandle = false
                    sheetController.willDismiss = {_ in }
                    sheetController.didDismiss = {_ in
                        filtersController.updateFilterParams()
                    }
                    self.present(sheetController, animated: false, completion: nil)
                    
                    break;
                }
            }
            
            break
        case self.restaurantsCollectionView:
            let branch = self.restaurants[indexPath.row]
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let restaurantViewController = storyboard.instantiateViewController(withIdentifier: "RestaurantView") as! RestaurantViewController
            restaurantViewController.restaurant = branch
            self.navigationController?.pushViewController(restaurantViewController, animated: true)
            break
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case self.collectionView:
            switch indexPath.row {
            case 0:
                return CGSize(width: view.frame.width, height: 168)
            case 1:
                return CGSize(width: view.frame.width, height: 42)
            case 2:
                return CGSize(width: view.frame.width, height: 54)
            case 3:
                var height = self.spinnerViewHeight
                if self.restaurants.count > 0 {
                    height += 12
                    for (index, _) in self.restaurants.enumerated() {
                        height += self.restaurantCellViewHeight(index: index) + 5
                    }
                } else {
                    height += (94 * 3)
                }
                return CGSize(width: view.frame.width, height: height)
            default:
                return CGSize(width: view.frame.width, height: 0)
            }
        case self.cuisinesCollectionView:
            return CGSize(width: 125, height: 160)
        case self.filtersCollectionView:
            let data = self.filters[indexPath.row]
            let filterRect = NSString(string: data[2] as! String).boundingRect(with: CGSize(width: view.frame.width, height: 26), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Medium", size: 12)!], context: nil)
            return CGSize(width: filterRect.width + 40, height: 42)
        case self.restaurantsShimmerCollectionView:
            return CGSize(width: view.frame.width, height: 94)
        case self.restaurantsCollectionView:
            if !self.restaurants.isEmpty {
                return CGSize(width: view.frame.width, height: self.restaurantCellViewHeight(index: indexPath.row))
            }
            return CGSize(width: view.frame.width, height: 210)
        default:
            return CGSize(width: view.frame.width, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionView {
        case self.cuisinesCollectionView:
            return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 12)
        case self.filtersCollectionView:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)
        case self.restaurantsShimmerCollectionView:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            return UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch collectionView {
        case self.restaurantsCollectionView:
            if indexPath.row == self.restaurants.count - 1 {
                if self.shouldLoad {
                    pageIndex += 1
                    self.spinnerViewHeight = 36
                    if isFiltering {
                        self.searchFilteredRestaurants(location: self.selectedLocation, index: pageIndex)
                    } else { getRestaurants(location: self.selectedLocation, index: pageIndex) }
                }
            }
            break
        default:
            break
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch collectionView {
        case self.restaurantsCollectionView:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerIdRestaurant, for: indexPath)
            
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
        default:
            break
        }
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerIdRestaurant, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        switch collectionView {
        case self.restaurantsCollectionView:
            return CGSize(width: self.view.frame.width, height: self.spinnerViewHeight)
        default:
            return CGSize(width: 0, height: 0)
        }
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
            
            
            mapView.restaurants = self.restaurants
            mapView.restaurant = self.selectedBranch
            
            self.present(mapView, animated: true, completion: nil)
        }
    }
    
    @objc func closeRestaurantMap(){
        UIApplication.shared.keyWindow?.windowLevel = UIWindow.Level.normal
        
        self.mapView.dismiss(animated: true, completion: nil)
        
        isMapOpened = false
        mapCenter = nil
        selectedBranch = nil
    }
    
    public func navigateToRestaurant(restaurant: Branch){
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let restaurantViewController = storyboard.instantiateViewController(withIdentifier: "RestaurantView") as! RestaurantViewController
        restaurantViewController.restaurant = restaurant
        self.navigationController?.pushViewController(restaurantViewController, animated: true)
    }
    
    @objc private func filterRestaurants(_ sender: Any) {
        self.appWindow?.rootViewController?.showSpinner(onView: self.appWindow?.rootViewController?.view ?? self.view)
        
        self.pageIndex = 1
        self.loadedRestaurants.removeAll(keepingCapacity: false)
        self.loadedRestaurants = []
        self.restaurants = []
        self.spinnerViewHeight = 0
        self.searchFilteredRestaurants(location: self.selectedLocation, index: self.pageIndex)
    }
    
    @objc private func clearFilters(_ sender: Any) {
        let alertDialog = UIAlertController(title: "Reset All Filters", message: "Do you really want to reset all filters ?", preferredStyle: UIAlertController.Style.alert)
        alertDialog.addAction(UIAlertAction(title: "YES", style: UIAlertAction.Style.default, handler: { (action) in
            LocalData.instance.resetFiltersParams()
            Toast.makeToast(message: "Filters Reset Successfully", duration: Toast.MID_LENGTH_DURATION, style: .success)
            self.pageIndex = 1
            self.loadedRestaurants = []
            self.restaurants = []
            self.isFiltering = false
            self.getRestaurants(location: self.selectedLocation, index: self.pageIndex)
        }))
        alertDialog.addAction(UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertDialog, animated: true, completion: nil)
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
        
        var restaurantCuisinesText: String
        
        if let cuisines = branch.restaurant?.foodCategories?.categories {
            restaurantCuisinesText = cuisines.map { (cuisine) -> String in cuisine.name! }.joined(separator: ", ")
        } else {
            restaurantCuisinesText = " - "
        }
        
        let restaurantCategoriesText = branch.categories.categories.map { (category) -> String in
            category.name
        }.joined(separator: ", ")
        
        let restaurantCuisinesRect = NSString(string: restaurantCuisinesText).boundingRect(with: CGSize(width: frameWidth - 18, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 13)!], context: nil)
        
        let restaurantCategoriesRect = NSString(string: restaurantCategoriesText).boundingRect(with: CGSize(width: frameWidth - 18, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 13)!], context: nil)
        
        let cellHeight: CGFloat = 2 + 20 + 4 + 8 + 45 + 8 + 26 + 8 + 26 + branchNameRect.height + branchAddressRect.height + 16 + restaurantCuisinesRect.height + restaurantCategoriesRect.height + 12 + valueToAdd
        
        return cellHeight
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchView.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.view.addGestureRecognizer(hideKeyboardGesture)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            self.searchView.resignFirstResponder()
            return false
        }
        return true
    }
    
    @objc private func search(_ sender: UITextField) {
        self.view.removeGestureRecognizer(hideKeyboardGesture)
        self.searchView.resignFirstResponder()
    }
    
    @objc private func hideKeyboard(_ sender: Any) {
        self.view.endEditing(true)
        self.view.removeGestureRecognizer(hideKeyboardGesture)
    }
    
    @objc private func openSearch(_ sender: Any?) {
        
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
    
    private func setup(){
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
