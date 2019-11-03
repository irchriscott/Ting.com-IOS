//
//  UserAddressesView.swift
//  ting
//
//  Created by Christian Scott on 26/08/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import GooglePlaces

class UserAddressesView: UIView, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate {
    
    let tableCellId = "tableCellId"
    var session = UserAuthentication().get()
    var editUserController: EditUserCollectionViewController?
    let appWindow = UIApplication.shared.keyWindow
    var navbarHeight: CGFloat?
    
    let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var addresses = UserAuthentication().get()?.addresses
    var height: Int?
    
    let addAddressButton: SecondaryButton = {
        let view =  SecondaryButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("ADD", for: .normal)
        view.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 16)
        return view
    }()
    
    let mapOverlay: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let mapViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.colorWhite
        return view
    }()
    
    let input: InputTextFieldElse = {
        let view = InputTextFieldElse()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Colors.colorDarkGray
        view.font = UIFont(name: "Poppins-Regular", size: 15)
        return view
    }()
    
    let mapView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.colorVeryLightGray
        return view
    }()
    
    let button: PrimaryButtonElse = {
        let view = PrimaryButtonElse()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = CGRect(x: 0, y: 0, width: 300, height: 40)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = view.frame.size.height / 2
        view.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 16)
        return view
    }()
    
    let searchButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "icon_search_25_white"), for: .normal)
        view.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        view.backgroundColor = UIColor(red: 0.56, green: 0.55, blue: 0.93, alpha: 0.5)
        view.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        view.layer.cornerRadius = view.frame.height / 2
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let inputLongitude = UITextField()
    let inputLatitude = UITextField()
    let inputAddress = UITextField()
    let inputAddressType = UITextField()
    let inputId = UITextField()
    
    var locationManager = CLLocationManager()
    var googleMapsView: GMSMapView!
    var mapTag: Int = 0
    let spinner = Spinner()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        self.setup()
    }
    
    private func setup(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UserAddressCell.self, forCellReuseIdentifier: tableCellId)
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        addSubview(tableView)
        addSubview(addAddressButton)
        
        height = 61 * addresses!.addresses.count
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        addConstraintsWithFormat(format: "V:|[v0(\(height!))]-15-[v1(43)]-15-|", views: tableView, addAddressButton)
        addConstraintsWithFormat(format: "H:|[v0(120)]", views: addAddressButton)
        
        input.addTarget(self, action: #selector(doneEditing), for: .primaryActionTriggered)
        input.returnKeyType = .done
        
        searchButton.addTarget(self, action: #selector(openPlaces), for: .touchUpInside)
        addAddressButton.addTarget(self, action: #selector(addLocationMap), for: .touchUpInside)
        button.addTarget(self, action: #selector(addOrUpdateAddress), for: .touchUpInside)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses?.addresses.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellId, for: indexPath) as! UserAddressCell
        cell.setup(address: addresses?.addresses[indexPath.item])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = editAddress(at: indexPath)
        let delete = deleteAddress(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
    
    func editAddress(at indexPath: IndexPath) -> UIContextualAction {
        let address = addresses?.addresses[indexPath.item]
        let action = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion) in
            
            self.input.text = address?.address
            self.inputAddress.text = address!.address
            self.inputLatitude.text = address!.latitude
            self.inputLongitude.text = address!.longitude
            self.inputAddressType.text = address!.type
            self.inputId.text = String(address!.id)
            self.mapTag = 0
            
            let coords = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: Double(address!.latitude)!)!, longitude: CLLocationDegrees(exactly: Double(address!.longitude)!)!)
            self.showMap(coords: coords, text: "UPDATE")
            
            completion(true)
        }
        action.backgroundColor = Colors.colorPrimary
        action.image = UIImage(named: "icon_edit_filled_25_white")
        return action
    }
    
    func deleteAddress(at indexPath: IndexPath) -> UIContextualAction {
        let address = addresses?.addresses[indexPath.row]
        let action = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion) in
            let confirm = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let accept = UIAlertAction(title: "Delete Address", style: .destructive, handler: { (action) in
                
                guard let url = URL(string: "\(URLs.deleteUserAddress)\(address!.id)/") else { return }
                
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.addValue(self.session!.token!, forHTTPHeaderField: "AUTHORIZATION")
                request.setValue(self.session!.token!, forHTTPHeaderField: "AUTHORIZATION")
                
                let session = URLSession.shared
                
                session.dataTask(with: request){ (data, response, error) in
                    if response != nil {}
                    if let data = data {
                        do {
                            let serverResponse = try JSONDecoder().decode(ServerResponse.self, from: data)
                            if serverResponse.type == "success" {
                                DispatchQueue.main.async {
                                    Toast.makeToast(message: serverResponse.message, duration: Toast.MID_LENGTH_DURATION, style: .success)
                                    self.addresses?.addresses.remove(at: indexPath.item)
                                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                                    self.height = (self.addresses?.addresses.count)! * 61
                                    self.addConstraintsWithFormat(format: "V:|[v0(\(self.height!))]-15-[v1(43)]-15-|", views: self.tableView, self.addAddressButton)
                                    do {
                                        guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return }
                                        let _ = json["msgs"] as? NSArray
                                        let user = try JSONEncoder().encode(serverResponse.user!)
                                        UserAuthentication().saveUserData(data: user)
                                    } catch {}
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.appWindow?.rootViewController?.showErrorMessage(message: serverResponse.message)
                                }
                            }
                        } catch {
                            DispatchQueue.main.async {
                                self.appWindow?.rootViewController?.showErrorMessage(message: error.localizedDescription)
                            }
                        }
                    }
                }.resume()
            })
            let cancel = UIAlertAction(title: "CANCEL", style: .cancel, handler: { (action) in })
            confirm.addAction(accept)
            confirm.addAction(cancel)
            if let window = UIApplication.shared.keyWindow {
                window.rootViewController?.present(confirm, animated: true, completion: nil)
            }
            completion(true)
        }
        action.backgroundColor = Colors.colorGoogleRedOne
        action.image = UIImage(named: "icon_delete_filled_25_white")
        return action
    }
    
    @objc func closeMapsUserLocation(){
        UIView.animate(withDuration: 0.5, animations: {
            self.mapOverlay.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.mapViewContainer.frame = CGRect(origin: CGPoint(x: 0, y: window.frame.height), size: CGSize(width: self.mapViewContainer.frame.width, height: self.mapViewContainer.frame.height))
            }
            self.mapOverlay.removeFromSuperview()
            self.mapViewContainer.removeFromSuperview()
        })
    }
    
    private func showMap(coords: CLLocationCoordinate2D, text: String){
        
        if let window = UIApplication.shared.keyWindow {
            
            self.mapOverlay.backgroundColor =  Colors.colorTransparent
            self.mapOverlay.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.closeMapsUserLocation)))
            
            let _ = UIApplication.shared.statusBarFrame.height
            
            let device = UIDevice.type
            let topConstraint: CGFloat = UIDevice.largeNavbarDevices.contains(device) ? 88 : 64
            
            let height = window.frame.height - topConstraint
            let y = window.frame.height - height
            self.mapViewContainer.frame = CGRect(origin: CGPoint(x: 0, y: window.frame.height), size: CGSize(width: window.frame.width, height: height))
            self.mapViewContainer.layer.cornerRadius = 15
            self.mapViewContainer.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            self.mapOverlay.frame = window.frame
            self.mapOverlay.alpha = 0
            
            self.button.setTitle(text, for: .normal)
            self.button.setLinearGradientBackgroundColor(colorOne: Colors.colorPrimary, colorTwo: Colors.colorPrimaryDark)
            
            let center = GMSCameraPosition.camera(withLatitude: coords.latitude, longitude: coords.longitude, zoom: 16)
            let markerView: CustomMapMarker = {
                let view = CustomMapMarker()
                view.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
                return view
            }()
            markerView.setup(path: "\(URLs.uploadEndPoint)\(self.session!.image)")
            let marker = GMSMarker(position: coords)
            marker.iconView = markerView
            
            self.mapView.addSubview(self.button)
            self.mapView.addSubview(self.searchButton)
            self.mapView.addConstraintsWithFormat(format: "V:[v0(40)]-50-|", views: self.button)
            self.mapView.addConstraintsWithFormat(format: "H:[v0(280)]", views: self.button)
            self.mapView.addConstraintsWithFormat(format: "V:|-10-[v0(30)]", views: self.searchButton)
            self.mapView.addConstraintsWithFormat(format: "H:[v0(30)]-10-|", views: self.searchButton)
            self.mapView.addConstraint(NSLayoutConstraint(item: self.button, attribute: .centerX, relatedBy: .equal, toItem: self.mapView, attribute: .centerX, multiplier: 1, constant: 0))
            
            self.googleMapsView = GMSMapView.map(withFrame: window.frame, camera: center)
            self.googleMapsView.delegate = self
            self.googleMapsView.clear()
            self.googleMapsView.camera = center
            let _ = MKCoordinateRegion(center: coords, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.googleMapsView.center = window.center
            marker.map = self.googleMapsView
            
            self.mapView.insertSubview(self.googleMapsView, belowSubview: self.button)
            
            self.mapViewContainer.addSubview(self.input)
            self.mapViewContainer.addSubview(self.mapView)
            
            self.mapViewContainer.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: self.input)
            self.mapViewContainer.addConstraintsWithFormat(format: "H:|[v0]|", views: self.mapView)
            self.mapViewContainer.addConstraintsWithFormat(format: "V:|-10-[v0(40)]-10-[v1]|", views: self.input, self.mapView)
            
            window.addSubview(self.mapOverlay)
            window.addSubview(self.mapViewContainer)
            
            window.addConstraintsWithFormat(format: "H:|[v0]|", views: self.mapViewContainer)
            window.addConstraintsWithFormat(format: "V:|-\(topConstraint)-[v0]|", views: self.mapViewContainer)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.mapOverlay.alpha = 1
                self.mapViewContainer.frame = CGRect(origin: CGPoint(x: 0, y: y), size: CGSize(width: self.mapViewContainer.frame.width, height: self.mapViewContainer.frame.height))
            }, completion: nil)
        }
    }
    
    @objc func doneEditing(){
        self.input.resignFirstResponder()
    }
    
    @objc func openPlaces(){
        if let window = UIApplication.shared.keyWindow {
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.tintColor = Colors.colorPrimary
            let barButtonAppearance = UIBarButtonItem.appearance()
            barButtonAppearance.setTitleTextAttributes([.foregroundColor : Colors.colorPrimary], for: .normal)
            autocompleteController.delegate = self
            
            let filter = GMSAutocompleteFilter()
            autocompleteController.autocompleteFilter = filter
            self.closeMapsUserLocation()
            window.rootViewController?.present(autocompleteController, animated: true, completion: nil)
        }
    }
    
    private func checkLocationAuthorization(status: CLAuthorizationStatus){
        if let window = UIApplication.shared.keyWindow {
            self.locationManager.delegate = self
            switch status {
            case .authorizedAlways:
                self.locationManager.requestAlwaysAuthorization()
                self.locationManager.startUpdatingLocation()
                self.spinner.show()
                break
            case .authorizedWhenInUse:
                self.locationManager.requestAlwaysAuthorization()
                self.locationManager.startUpdatingLocation()
                self.spinner.show()
                break
            case .denied:
                self.spinner.hide()
                let alert = UIAlertController(title: "Please, Go to settings and allow this app to use your location", message: nil, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                window.rootViewController?.present(alert, animated: true, completion: nil)
                break
            case .notDetermined:
                self.locationManager.requestWhenInUseAuthorization()
                self.locationManager.startUpdatingLocation()
                self.spinner.show()
                break
            case .restricted:
                self.spinner.hide()
                let alert = UIAlertController(title: "Please, Go to settings and allow this app to use your location", message: nil, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                window.rootViewController?.present(alert, animated: true, completion: nil)
                break
            }
        }
    }
    
    @objc func addLocationMap(){
        self.mapTag = 1
        self.inputAddressType.text = StaticData.addressTypes[0]
        self.inputId.text = String(session!.id)
        self.checkLocationAuthorization(status: CLLocationManager.authorizationStatus())
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { spinner.hide(); return }
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(location.coordinate) { (response, error) in
            if let address = response?.firstResult(){
                DispatchQueue.main.async {
                    self.input.text = address.lines?[0]
                    self.inputAddress.text = address.lines?[0]
                    self.inputLatitude.text = String(address.coordinate.latitude)
                    self.inputLongitude.text = String(address.coordinate.longitude)
                    self.spinner.hide()
                    let text = self.mapTag == 0 ? "UPDATE" : "ADD"
                    self.showMap(coords: address.coordinate, text: text)
                }
            } else {
                DispatchQueue.main.async {
                    self.spinner.hide()
                    Toast.makeToast(message: "Couldnt Fetch Location", duration: Toast.MID_LENGTH_DURATION, style: .error)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {}
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.spinner.hide()
        Toast.makeToast(message: error.localizedDescription, duration: Toast.MID_LENGTH_DURATION, style: .error)
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { (response, error) in
            if let address = response?.firstResult(){
                DispatchQueue.main.async {
                    self.input.text = address.lines?[0]
                    self.inputAddress.text = address.lines?[0]
                    let text = self.mapTag == 0 ? "UPDATE" : "ADD"
                    self.button.setTitle(text, for: .normal)
                    
                    let center = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 16)
                
                    let markerView: CustomMapMarker = {
                        let view = CustomMapMarker()
                        view.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
                        return view
                    }()
                    markerView.setup(path: "\(URLs.uploadEndPoint)\(self.session!.image)")
                    let marker = GMSMarker(position: coordinate)
                    marker.iconView = markerView
                    
                    self.googleMapsView = GMSMapView.map(withFrame: self.appWindow!.frame, camera: center)
                    self.googleMapsView.delegate = self
                    self.googleMapsView.clear()
                    self.googleMapsView.camera = center
                    let _ = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                    self.googleMapsView.center = self.appWindow!.center
                    self.mapView.insertSubview(self.googleMapsView, belowSubview: self.button)
                    marker.map = self.googleMapsView
                }
            } else {
                DispatchQueue.main.async {
                    Toast.makeToast(message: "Couldnt Fetch Location", duration: Toast.MID_LENGTH_DURATION, style: .error)
                }
            }
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.input.text = place.formattedAddress
        self.inputAddress.text = place.name
        self.inputLongitude.text = String(place.coordinate.longitude)
        self.inputLatitude.text = String(place.coordinate.latitude)
        appWindow?.rootViewController?.dismiss(animated: true, completion: nil)
        let text = self.mapTag == 0 ? "UPDATE" : "ADD"
        self.showMap(coords: place.coordinate, text: text)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        Toast.makeToast(message: error.localizedDescription, duration: Toast.MID_LENGTH_DURATION, style: .error)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        if let window = UIApplication.shared.keyWindow {
            window.rootViewController?.dismiss(animated: true, completion: nil)
            if let longitude = self.inputLongitude.text, let latitude = self.inputLatitude.text, let address = self.inputAddress.text {
                self.input.text = address
                let coords = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: Double(latitude)!)!, longitude: CLLocationDegrees(exactly: Double(longitude)!)!)
                self.showMap(coords: coords, text: "UPDATE")
            }
        }
    }
    
    @objc func addOrUpdateAddress(){
        if let longitude = self.inputLongitude.text, let latitude = self.inputLatitude.text, let address = self.input.text, let id = self.inputId.text, let type = self.inputAddressType.text {
            
            self.closeMapsUserLocation()
            
            let params: Parameters = ["token": self.session!.token!, "address": address, "latitude": latitude, "longitude": longitude, "type": type, "other_address_type": type]
            
            let urlString = self.mapTag == 0 ? "\(URLs.updateUserAddress)\(id)/" : URLs.addUserAddress
            guard let url = URL(string: urlString) else { return }
            self.spinner.show()
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue(self.session!.token!, forHTTPHeaderField: "AUTHORIZATION")
            request.setValue(self.session!.token!, forHTTPHeaderField: "AUTHORIZATION")
            
            let boundary = Requests().generateBoundary()
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            let httpBody = Requests().createDataBody(withParameters: params, media: nil, boundary: boundary)
            request.httpBody = httpBody
            
            let session = URLSession.shared
            
            session.dataTask(with: request){ (data, response, error) in
                self.spinner.hide()
                if response != nil {}
                if let data = data {
                    do {
                        let serverResponse = try JSONDecoder().decode(ServerResponse.self, from: data)
                        if serverResponse.type == "success" {
                            DispatchQueue.main.async {
                                Toast.makeToast(message: serverResponse.message, duration: Toast.MID_LENGTH_DURATION, style: .success)
                                do {
                                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return }
                                    let _ = json["msgs"] as? NSArray
                                    let user = try JSONEncoder().encode(serverResponse.user!)
                                    UserAuthentication().saveUserData(data: user)
                                    self.session = UserAuthentication().get()
                                    self.addresses = self.session?.addresses
                                    self.height = (self.addresses?.addresses.count)! * 61
                                    self.tableView.reloadData()
                                    self.addConstraintsWithFormat(format: "V:|[v0(\(self.height!))]-15-[v1(43)]-15-|", views: self.tableView, self.addAddressButton)
                                } catch {}
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.appWindow?.rootViewController?.showErrorMessage(message: serverResponse.message)
                            }
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self.appWindow?.rootViewController?.showErrorMessage(message: error.localizedDescription)
                        }
                    }
                }
            }.resume()
        } else { Toast.makeToast(message: "No Location Provided", duration: Toast.MID_LENGTH_DURATION, style: .error) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class UserAddressCell: UITableViewCell {
    
    let icon: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.5
        return view
    }()
    
    let title: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-Regular", size: 14)
        view.textColor = Colors.colorGray
        return view
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.colorVeryLightGray
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func setup(address: Address?){
        addSubview(icon)
        addSubview(title)
        addSubview(separator)
        
        switch address?.type.lowercased() {
        case "home":
            icon.image = UIImage(named: "icon_address_home")
        case "school":
            icon.image = UIImage(named: "icon_address_school")
        case "work":
            icon.image = UIImage(named: "icon_address_work")
        case "other":
            icon.image = UIImage(named: "icon_address_other")
        default:
            icon.image = UIImage(named: "icon_address_other")
        }
        title.text = address?.address
        
        addConstraintsWithFormat(format: "V:|-15-[v0(30)]-15-|", views: icon)
        addConstraintsWithFormat(format: "H:|-0-[v0(30)]-15-[v1]-0-|", views: icon, title)
        addConstraint(NSLayoutConstraint(item: title, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraintsWithFormat(format: "V:[v0(1)]|", views: separator)
        addConstraintsWithFormat(format: "H:|[v0]|", views: separator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
