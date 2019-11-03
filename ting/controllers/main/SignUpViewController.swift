//
//  SignUpViewController.swift
//  ting
//
//  Created by Ir Christian Scott on 02/08/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps

class SignUpViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate,  CLLocationManagerDelegate, GMSMapViewDelegate{
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet weak var signUpNamesInput: UITextField!
    @IBOutlet weak var signUpUsernameInput: UITextField!
    @IBOutlet weak var signUpEmailAddressInput: UITextField!
    @IBOutlet weak var nextIdentityButton: UIButton!
    @IBOutlet weak var signUpIdentityFormView: UIView!
    
    @IBOutlet weak var signUpAboutFormView: UIView!
    @IBOutlet weak var signUpGenderInput: UITextField!
    @IBOutlet weak var signUpDobInput: UITextField!
    
    @IBOutlet weak var signUpAddressFormView: UIView!
    @IBOutlet weak var signUpAddressInput: UITextField!
    @IBOutlet weak var signUpAddressTypeInput: UITextField!
    
    @IBOutlet var successOverlayView: UIView!
    @IBOutlet weak var successOverlayImage: UIImageView!
    @IBOutlet weak var successOverlayLabel: UILabel!
    
    @IBOutlet weak var mapViewContainer: UIView!
    @IBOutlet weak var addressSearchInput: UITextField!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var useThisLocationButton: UIButton!
    
    @IBOutlet weak var signUpPasswordView: UIView!
    @IBOutlet weak var signUpPasswordInput: UITextField!
    @IBOutlet weak var signUpConfirmPasswordInput: UITextField!
    
    var otherAddressType: String?
    
    let mapOverlay = UIView()
    var locationManager = CLLocationManager()
    var googleMapsView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.signUpIdentityFormView.frame.size.width = self.view.frame.width - 50
        self.signUpIdentityFormView.center = self.view.center
        self.scrollView.addSubview(self.signUpIdentityFormView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShowNotification(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handlekeyboardWillHideNotification(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.signUpGenderInput.text = StaticData.genders[0]
        let genderPickerView = UIPickerView()
        genderPickerView.tag = 0
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        
        let toolbarGender = UIToolbar()
        toolbarGender.barStyle = UIBarStyle.default
        toolbarGender.isTranslucent = true
        toolbarGender.tintColor = .darkGray
        toolbarGender.backgroundColor = Colors.colorPrimary
        toolbarGender.alpha = 1.0
        toolbarGender.sizeToFit()
        
        let doneButtonGender = UIBarButtonItem(title: "DONE", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneGender))
        doneButtonGender.tintColor = .darkGray
        toolbarGender.setItems([doneButtonGender], animated: false)
        toolbarGender.isUserInteractionEnabled = true
        
        self.signUpGenderInput.inputView = genderPickerView
        self.signUpGenderInput.inputAccessoryView = toolbarGender
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        self.signUpDobInput.inputView = datePicker
        self.signUpDobInput.text = "1999-01-01"
        
        let toolbarDob = UIToolbar()
        toolbarDob.barStyle = UIBarStyle.default
        toolbarDob.isTranslucent = true
        toolbarDob.tintColor = .darkGray
        toolbarDob.backgroundColor = Colors.colorPrimary
        toolbarDob.alpha = 1.0
        toolbarDob.sizeToFit()
        
        let doneButtonDob = UIBarButtonItem(title: "DONE", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneDob))
        doneButtonDob.tintColor = .darkGray
        toolbarDob.setItems([doneButtonDob], animated: false)
        toolbarDob.isUserInteractionEnabled = true
        self.signUpDobInput.inputAccessoryView = toolbarDob
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        self.view.addGestureRecognizer(tapGesture)
        
        self.signUpAddressTypeInput.text = StaticData.addressTypes[0]
        self.otherAddressType = StaticData.addressTypes[0]
        let addressTypePickerView = UIPickerView()
        addressTypePickerView.tag = 1
        addressTypePickerView.delegate = self
        addressTypePickerView.dataSource = self
        
        let toolbarAddressType = UIToolbar()
        toolbarAddressType.barStyle = UIBarStyle.default
        toolbarAddressType.isTranslucent = true
        toolbarAddressType.tintColor = .darkGray
        toolbarAddressType.backgroundColor = Colors.colorPrimary
        toolbarAddressType.alpha = 1.0
        toolbarAddressType.sizeToFit()
        
        let doneButtonAddressType = UIBarButtonItem(title: "DONE", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneAddressType))
        toolbarAddressType.tintColor = .darkGray
        toolbarAddressType.setItems([doneButtonAddressType], animated: false)
        toolbarAddressType.isUserInteractionEnabled = true
        
        self.signUpAddressTypeInput.inputView = addressTypePickerView
        self.signUpAddressTypeInput.inputAccessoryView = toolbarAddressType
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.checkLocationAuthorizationStatus(status: CLLocationManager.authorizationStatus())
        
        if let name = UserAuthentication().getSignUpData(key: "sign_up_name"), let username = UserAuthentication().getSignUpData(key: "sign_up_username"), let email = UserAuthentication().getSignUpData(key: "sign_up_email"){
            self.signUpNamesInput.text = name
            self.signUpUsernameInput.text = username
            self.signUpEmailAddressInput.text = email
        }
        
        if let gender = UserAuthentication().getSignUpData(key: "sign_up_gender"), let dob = UserAuthentication().getSignUpData(key: "sign_up_dob"){
            self.signUpGenderInput.text = gender
            self.signUpDobInput.text = dob
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            datePicker.date = dateFormatter.date(from: dob)!
        }
        
        if let address = UserAuthentication().getSignUpData(key: "sign_up_address"), let type = UserAuthentication().getSignUpData(key: "sign_up_address_type"), let other_type = UserAuthentication().getSignUpData(key: "sign_up_other_address_type"){
            self.addressSearchInput.text = address
            self.signUpAddressInput.text = address
            self.signUpAddressTypeInput.text = type
            self.otherAddressType = other_type
        }
    }
    
    private func checkLocationAuthorizationStatus(status: CLAuthorizationStatus){
        switch status {
        case .authorizedAlways:
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.startUpdatingLocation()
            self.showSpinner(onView: self.view)
            break
        case .authorizedWhenInUse:
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.startUpdatingLocation()
            self.showSpinner(onView: self.view)
            break
        case .denied:
            self.removeSpinner()
            let alert = UIAlertController(title: "Please, Go to settings and allow this app to use your location", message: nil, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            break
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
            self.showSpinner(onView: self.view)
            break
        case .restricted:
            self.removeSpinner()
            let alert = UIAlertController(title: "Please, Go to settings and allow this app to use your location", message: nil, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            break
        }
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    @IBAction func usernameNext(_ sender: UITextField) {
        self.signUpUsernameInput.becomeFirstResponder()
    }
    
    @IBAction func emailNext(_ sender: UITextField) {
        self.signUpEmailAddressInput.becomeFirstResponder()
    }
    
    @IBAction func emailDone(_ sender: UITextField) {
        self.signUpEmailAddressInput.resignFirstResponder()
        self.signUpEmailAddressInput.endEditing(true)
    }
    
    @IBAction func navigateToAboutSignUp(_ sender: UIButton) {
        let parameters: [String: String] = ["name": self.signUpNamesInput.text!, "email": self.signUpEmailAddressInput.text!, "username": self.signUpUsernameInput.text!]
        
        guard let url = URL(string: URLs.checkEmail) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = Requests().generateBoundary()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let httpBody = Requests().createDataBody(withParameters: parameters, media: nil, boundary: boundary)
        request.httpBody = httpBody
        
        self.showSpinner(onView: self.view)
        
        let session = URLSession.shared
        session.dataTask(with: request){ (data, response, error) in
            self.removeSpinner()
            if response != nil {}
            if let data = data {
                do {
                    let serverResponse = try JSONDecoder().decode(ServerResponse.self, from: data)
                    if serverResponse.type == "success"{
                        DispatchQueue.main.async {
                            UserAuthentication().saveSignUpData(key: "sign_up_name", data: self.signUpNamesInput.text!)
                            UserAuthentication().saveSignUpData(key: "sign_up_username", data: self.signUpUsernameInput.text!)
                            UserAuthentication().saveSignUpData(key: "sign_up_email", data: self.signUpEmailAddressInput.text!)
                            self.showViewAnimateLeftToRight(fromView: self.signUpIdentityFormView, toView: self.signUpAboutFormView, scrollView: self.scrollView)
                        }
                    } else {
                        self.showErrorMessage(message: serverResponse.message)
                    }
                } catch {
                    self.showErrorMessage(message: error.localizedDescription)
                }
            }
        }.resume()
    }
    
    @objc func handleKeyboardWillShowNotification(notification: NSNotification){
        if let userinfo = notification.userInfo{
            let keyboardFrame = (userinfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
            self.scrollView.contentInset.bottom = self.view.convert(keyboardFrame!, from: nil).size.height
        }
    }
    
    @objc func handlekeyboardWillHideNotification(notification: NSNotification){
        self.scrollView.contentInset.bottom = 0
    }
    
    @objc func doneGender(){
        self.signUpDobInput.becomeFirstResponder()
    }
    
    @objc func doneDob(){
        self.signUpDobInput.resignFirstResponder()
    }
    
    @objc func doneAddressType(){
        self.signUpAddressTypeInput.resignFirstResponder()
        if self.signUpAddressTypeInput.text?.lowercased() == StaticData.addressTypes[StaticData.addressTypes.count - 1].lowercased(){
            let alert = UIAlertController(title: "Enter Address Type", message: nil, preferredStyle: UIAlertController.Style.alert)
            let action =  UIAlertAction(title: "OK", style: .default) { (alertAction) in
                let textField = alert.textFields![0] as UITextField
                self.otherAddressType = textField.text
            }
            alert.addTextField { (textField) in
                let padding = UIEdgeInsets(top: 0.0, left: 12.0, bottom: 0.0, right: 12.0)
                textField.placeholder = "Address Type"
                textField.textRect(forBounds: textField.bounds.inset(by: padding))
                textField.editingRect(forBounds: textField.bounds.inset(by: padding))
                textField.placeholderRect(forBounds: textField.bounds.inset(by: padding))
                textField.layer.cornerRadius = 15
                textField.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
                textField.layer.borderColor = Colors.colorVeryLightGray.cgColor
                textField.keyboardType = .default
                textField.returnKeyType = .done
                textField.addTarget(self, action: #selector(self.doneOtherAddressType), for: UIControl.Event.primaryActionTriggered)
                if let type = self.otherAddressType{
                    textField.text = type
                }
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        } else {
            self.otherAddressType = self.signUpAddressTypeInput.text
        }
    }
    
    @objc func doneOtherAddressType(){
        self.view.endEditing(true)
    }
    
    @IBAction func dobNext(_ sender: UITextField) {
        self.signUpDobInput.becomeFirstResponder()
    }
    
    @IBAction func dboDone(_ sender: UITextField) {
        self.signUpDobInput.resignFirstResponder()
    }
    
    @IBAction func navigateToAddressSignUp(_ sender: UIButton) {
        if let gender = self.signUpGenderInput.text, self.signUpGenderInput.text != nil, let dob = self.signUpDobInput.text, self.signUpDobInput.text != nil {
            UserAuthentication().saveSignUpData(key: "sign_up_gender", data: gender)
            UserAuthentication().saveSignUpData(key: "sign_up_dob", data: dob)
            self.showViewAnimateLeftToRight(fromView: self.signUpAboutFormView, toView: self.signUpAddressFormView, scrollView: self.scrollView)
        } else {
            self.showErrorMessage(message: "Fill All The Fields")
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView.tag == 0 ? StaticData.genders.count : StaticData.addressTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            self.signUpGenderInput.text = StaticData.genders[row]
        } else {
            self.signUpAddressTypeInput.text = StaticData.addressTypes[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView.tag == 0 ? StaticData.genders[row] : StaticData.addressTypes[row]
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.signUpDobInput.text = dateFormatter.string(from: datePicker.date)
    }
    
    @IBAction func openMapsUserLocation(_ sender: UITextField) {
        self.signUpAddressInput.resignFirstResponder()
        self.signUpAddressInput.endEditing(true)
        
        if let window = UIApplication.shared.keyWindow {
            self.mapOverlay.backgroundColor =  Colors.colorTransparent
            self.mapOverlay.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeMapsUserLocation)))
            window.addSubview(mapOverlay)
            window.addSubview(self.mapViewContainer)
            let height = window.frame.height - 80
            let y = window.frame.height - height
            self.mapViewContainer.frame = CGRect(origin: CGPoint(x: 0, y: window.frame.height), size: CGSize(width: window.frame.width, height: height))
            self.mapViewContainer.layer.cornerRadius = 15
            self.mapViewContainer.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            self.mapOverlay.frame = window.frame
            self.mapOverlay.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.mapOverlay.alpha = 1
                self.mapViewContainer.frame = CGRect(origin: CGPoint(x: 0, y: y), size: CGSize(width: self.mapViewContainer.frame.width, height: self.mapViewContainer.frame.height))
            }, completion: nil)
        }
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.loadUserLocationOnMap(coordinates: location.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {}
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.removeSpinner()
        Toast.makeToast(message: error.localizedDescription, duration: Toast.MID_LENGTH_DURATION, style: .error)
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.loadUserLocationOnMap(coordinates: coordinate)
    }
    
    private func loadUserLocationOnMap(coordinates: CLLocationCoordinate2D){
        let coords = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
        let center = GMSCameraPosition.camera(withLatitude: coords.latitude, longitude: coords.longitude, zoom: 16)
        self.googleMapsView = GMSMapView.map(withFrame: self.view.frame, camera: center)
        self.googleMapsView.delegate = self
        self.googleMapsView.clear()
        self.googleMapsView.camera = center
        let _ = MKCoordinateRegion(center: coords, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.googleMapsView.center = self.view.center
        self.mapView.insertSubview(self.googleMapsView, belowSubview: self.useThisLocationButton)
        
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coords) { (response, error) in
            if let address = response?.firstResult(){
                DispatchQueue.main.async {
                    self.signUpAddressInput.text = address.lines?[0]
                    self.addressSearchInput.text = address.lines?[0]
                    
                    self.removeSpinner()
                    
                    let marker = GMSMarker()
                    marker.position = coords
                    marker.title = address.lines?[0]
                    marker.map = self.googleMapsView
                    
                    UserAuthentication().saveSignUpData(key: "sign_up_longitude", data: String(address.coordinate.longitude))
                    UserAuthentication().saveSignUpData(key: "sign_up_latitude", data: String(address.coordinate.latitude))
                    UserAuthentication().saveSignUpData(key: "sign_up_town", data: address.administrativeArea!)
                    UserAuthentication().saveSignUpData(key: "sign_up_country", data: address.country!)
                }
            } else {
                DispatchQueue.main.async {
                    self.removeSpinner()
                    self.showErrorMessage(message: "Couldnt Fetch Location")
                }
            }
            if let err = error {
                DispatchQueue.main.async {
                    self.removeSpinner()
                    self.showErrorMessage(message: err.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func doneAddressSearch(_ sender: UITextField) {
        self.addressSearchInput.resignFirstResponder()
    }
    
    @IBAction func useSelectedLocation(_ sender: UIButton) {
        if let address = self.addressSearchInput.text{
            self.signUpAddressInput.text = address
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.mapOverlay.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.mapViewContainer.frame = CGRect(origin: CGPoint(x: 0, y: window.frame.height), size: CGSize(width: self.mapViewContainer.frame.width, height: self.mapViewContainer.frame.height))
            }
        })
    }
    
    @IBAction func navigateToPasswordSignUp(_ sender: UIButton) {
        if self.signUpAddressInput.text != nil, self.signUpAddressTypeInput.text != nil, self.otherAddressType != nil{
            UserAuthentication().saveSignUpData(key: "sign_up_address", data: self.signUpAddressInput.text!)
            UserAuthentication().saveSignUpData(key: "sign_up_address_type", data: self.signUpAddressTypeInput.text!)
            UserAuthentication().saveSignUpData(key: "sign_up_other_address_type", data: self.otherAddressType!)
            self.showViewAnimateLeftToRight(fromView: self.signUpAddressFormView, toView: self.signUpPasswordView, scrollView: self.scrollView)
        } else {
            self.showErrorMessage(message: "Fill All The Fields")
        }
    }
    
    @IBAction func submitSignUp(_ sender: UIButton) {
        if let password = self.signUpPasswordInput.text, let confirm = self.signUpConfirmPasswordInput.text {
            if password == confirm, password != "" {
                let formData: Parameters = ["name": UserAuthentication().getSignUpData(key: "sign_up_name")!, "username": UserAuthentication().getSignUpData(key: "sign_up_username")!, "email": UserAuthentication().getSignUpData(key: "sign_up_email")!, "gender": UserAuthentication().getSignUpData(key: "sign_up_gender")!, "date_of_birth": UserAuthentication().getSignUpData(key: "sign_up_dob")!, "country": UserAuthentication().getSignUpData(key: "sign_up_country")!, "town": UserAuthentication().getSignUpData(key: "sign_up_town")!, "address": UserAuthentication().getSignUpData(key: "sign_up_address")!, "longitude": UserAuthentication().getSignUpData(key: "sign_up_longitude")!, "latitude": UserAuthentication().getSignUpData(key: "sign_up_latitude")!, "type": UserAuthentication().getSignUpData(key: "sign_up_address_type")!, "other_address_type": UserAuthentication().getSignUpData(key: "sign_up_other_address_type")!, "password": password]
                
                guard let url = URL(string: URLs.emailSignup) else { return }
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                
                let boundary = Requests().generateBoundary()
                request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                
                let httpBody = Requests().createDataBody(withParameters: formData, media: nil, boundary: boundary)
                request.httpBody = httpBody
                
                self.showSpinner(onView: self.view)
                
                let session = URLSession.shared
                session.dataTask(with: request){ (data, response, error) in
                    self.removeSpinner()
                    if response != nil {}
                    if let data = data {
                        do {
                            let serverResponse = try JSONDecoder().decode(ServerResponse.self, from: data)
                            if serverResponse.type == "success" {
                                DispatchQueue.main.async {
                                    self.showSuccessMessage(successOverlayView: self.successOverlayView, image: self.successOverlayImage, label: self.successOverlayLabel, message: serverResponse.message)
                                    
                                    do {
                                        guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return }
                                        let _ = json["msgs"] as? NSArray
                                        let user = try JSONEncoder().encode(serverResponse.user!)
                                        UserAuthentication().saveUserData(data: user)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                                            let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
                                            let appDelegate = UIApplication.shared.delegate! as! AppDelegate
                                            let homeDiscoverViewController = storyBoard.instantiateViewController(withIdentifier: "HomeTabBar")
                                            appDelegate.window?.rootViewController = homeDiscoverViewController
                                            appDelegate.window?.makeKeyAndVisible()
                                        })
                                    } catch {}
                                }
                            } else {
                                self.showErrorMessage(message: serverResponse.message)
                            }
                        } catch {
                            self.showErrorMessage(message: error.localizedDescription)
                        }
                    }
                }.resume()
            } else {
                self.showErrorMessage(message: "Passwords Didnt Match")
            }
        } else {
            self.showErrorMessage(message: "Please Fill All The Fields")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
