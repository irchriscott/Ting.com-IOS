//
//  TableScannerViewController.swift
//  ting
//
//  Created by Christian Scott on 21/08/2020.
//  Copyright © 2020 Ir Christian Scott. All rights reserved.
//

import UIKit
import PubNub
import MapKit
import MercariQRScanner

class TableScannerViewController: UIViewController, QRScannerViewDelegate, CLLocationManagerDelegate {
    
    var controller: UINavigationController? {
        didSet { }
    }
    private var qrScannerView: QRScannerView!
    
    var pubnub: PubNub!
    let listener = SubscriptionListener(queue: .main)
    
    let session = UserAuthentication().get()!
    
    var locationManager = CLLocationManager()
    var userLocation: CLLocation?
    
    var flashButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let defaultTable = "CXLJAIAS6YJBOC7POTOIPLV1NA4HACMQOEHN3SVOO20DIC6W3ID4SIPCMFSR2AWAUVR9WGLHDSJNLOLDYQCPE05XXIWXS9FO5EHN"
    
    let closeButtonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        view.backgroundColor = UIColor(red: 0.56, green: 0.55, blue: 0.93, alpha: 0.5)
        return view
    }()
    
    let closeImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        view.image = UIImage(named: "icon_close_bold_25_white")
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.checkLocationAuthorization(status: CLLocationManager.authorizationStatus())
        
        self.closeButtonView.layer.cornerRadius = self.closeButtonView.frame.width / 2
        self.closeButtonView.layer.masksToBounds = true
        
        self.view.addSubview(closeButtonView)
        
        self.view.addConstraintsWithFormat(format: "V:|-40-[v0(30)]", views: closeButtonView)
        self.view.addConstraintsWithFormat(format: "H:|-12-[v0(30)]", views: closeButtonView)
        
        self.closeImageView.image = UIImage(named: "icon_close_bold_25_white")
        self.closeButtonView.addSubview(closeImageView)
        
        self.closeButtonView.addConstraintsWithFormat(format: "H:[v0(20)]", views: closeImageView)
        self.closeButtonView.addConstraintsWithFormat(format: "V:[v0(20)]", views: closeImageView)
        
        self.closeButtonView.addConstraint(NSLayoutConstraint(item: closeImageView, attribute: .centerX, relatedBy: .equal, toItem: closeButtonView, attribute: .centerX, multiplier: 1, constant: 0))
        self.closeButtonView.addConstraint(NSLayoutConstraint(item: closeImageView, attribute: .centerY, relatedBy: .equal, toItem: closeButtonView, attribute: .centerY, multiplier: 1, constant: 0))
        
        flashButton.setImage(UIImage(named: "icon_flash_on_25_white"), for: .selected)
        flashButton.setImage(UIImage(named: "icon_flash_off_25_white"), for: .normal)
        
        qrScannerView = QRScannerView(frame: self.view.bounds)
        self.view.addSubview(qrScannerView)
        qrScannerView.configure(delegate: self, input: .init(isBlurEffectEnabled: true))
        qrScannerView.startRunning()
        
        self.view.addSubview(flashButton)
        
        self.view.addConstraintsWithFormat(format: "V:|-40-[v0(30)]", views: flashButton)
        self.view.addConstraintsWithFormat(format: "H:[v0(30)]-12-|", views: flashButton)
        
        flashButton.addTarget(self, action: #selector(tapFlashButton(_:)), for: .touchUpInside)
        closeButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeScanner)))
        
        self.view.bringSubviewToFront(closeButtonView)
        self.view.bringSubviewToFront(flashButton)
        
        PubNub.log.levels = [.all]
        PubNub.log.writers = [ConsoleLogWriter(), FileLogWriter()]

        let config = PubNubConfiguration(publishKey: "pub-c-62f722d6-c307-4dd9-89dc-e598a9164424", subscribeKey: "sub-c-6597d23e-1b1d-11ea-b79a-866798696d74")
        pubnub = PubNub(configuration: config)
        
        let channels = [session.channel]
        
        listener.didReceiveMessage = { message in
            do {
                let response = try JSONDecoder().decode(SocketResponseMessage.self, from: message.payload.jsonStringify!.data(using: .utf8)!)
                self.removeSpinner()
                switch response.type {
                case Socket.SOCKET_RESPONSE_RESTO_TABLE:
                    if let data = response.data {
                        PlacementProvider().setToken(data: data["token"]!)
                        let storyboard = UIStoryboard(name: "Home", bundle: nil)
                        let placementViewController = storyboard.instantiateViewController(withIdentifier: "PlacementView") as! PlacementViewController
                        self.dismiss(animated: true) {
                            self.controller?.pushViewController(placementViewController, animated: true)
                        }
                    } else {
                        self.qrScannerView.startRunning()
                        self.showErrorMessage(message: "An error has occurred. Try again", title: "Ouch")
                    }
                case Socket.SOCKET_RESPONSE_ERROR:
                    self.qrScannerView.startRunning()
                    if let m = response.message {
                        self.showErrorMessage(message: m, title: "Sorry")
                    } else { self.showErrorMessage(message: "An error has occurred. Try again", title: "Sorry") }
                case Socket.SOCKET_RESPONSE_PLACEMENT_DONE:
                    self.qrScannerView.startRunning()
                    PlacementProvider().placeOut()
                    self.showErrorMessage(message: "Your placement is done. Try again", title: "Message")
                default:
                    self.qrScannerView.startRunning()
                    self.showErrorMessage(message: "No Response. Try again", title: "Humm ?")
                }
            } catch {
                self.removeSpinner()
                self.qrScannerView.startRunning()
                self.showErrorMessage(message: "An error has occurred. Try again", title: "Ouch")
            }
        }
        
        listener.didReceiveStatus = { status in
            switch status {
            case .success(let connection):
                if connection == .connected {}
            case .failure(let error):
                self.showErrorMessage(message: error.localizedDescription)
            }
        }
        
        pubnub.add(listener)
        pubnub.subscribe(to: channels, withPresence: true)
        
        requestTable(table: defaultTable)
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
            let alert = UIAlertController(title: "Please, Go to settings and allow this app to use your location", message: nil, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            break
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
            break
        case .restricted:
            let alert = UIAlertController(title: "Please, Go to settings and allow this app to use your location", message: nil, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            break
        }
    }
    
    private func requestTable(table: String) {
        self.showSpinner(onView: self.view)
        APIDataProvider.instance.requestRestaurantTable(table: table) { (data) in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        self.removeSpinner()
                        let placement = try JSONDecoder().decode(Placement.self, from: data)
                        PlacementProvider().set(data: data)
                        PlacementProvider().setToken(data: placement.token)
                        let storyboard = UIStoryboard(name: "Home", bundle: nil)
                        let placementViewController = storyboard.instantiateViewController(withIdentifier: "PlacementView") as! PlacementViewController
                        self.dismiss(animated: true) {
                            self.controller?.pushViewController(placementViewController, animated: true)
                        }
                    } catch {
                        do {
                            let table = try JSONDecoder().decode(RestaurantTable.self, from: data)
                            if let location = self.userLocation {
                                let branchLocation = CLLocation(latitude: CLLocationDegrees(exactly: Double(table.branch!.latitude)!)!, longitude: CLLocationDegrees(exactly: Double(table.branch!.longitude)!)!)
                                
                                let timeStatus = Functions.statusWorkTime(open: (table.branch?.restaurant!.opening)!, close: (table.branch?.restaurant!.closing)!)
                                
                                if timeStatus!["st"] == "opened" {
                                    let distance = Double(branchLocation.distance(from: location) / 1000).rounded(toPlaces: 2)
                                    if distance <= 5000 {
                                        
                                        if PlacementProvider().getTempToken() == nil {
                                            PlacementProvider().setTempToken(data: Functions.randomString(length: Int.random(in: 100...200)))
                                        }
                                        
                                        let receiver = SocketUser(id: table.branch?.id, type: 1, name: "\(table.branch?.restaurant?.name ?? ""), \(table.branch?.name ?? "")", email: table.branch?.email, image: table.branch?.restaurant?.logo, channel: (table.branch?.channel)!)
                                        
                                        let args:[String:String] = ["table": "\(table.id)", "token": PlacementProvider().getTempToken()!]
                                        let data:[String:String] = ["table": table.number]
                                        
                                        let message = SocketResponseMessage(uuid: UUID().uuidString, type: Socket.SOCKET_REQUEST_RESTO_TABLE, sender: UserAuthentication().socketUser(), receiver: receiver, status: 200, message: "", args: args, data: data)
                                        
                                        let messageJSON = try! JSONEncoder().encodeJSONObject(message)
                                        
                                        let jsonData = try! JSONSerialization.data(withJSONObject: messageJSON, options: [])
                                        let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)!.replacingOccurrences(of: "\"", with: "'")
                                        
                                        self.pubnub.publish(channel: table.branch!.channel, message: jsonString) { (result) in
                                            switch result {
                                            case .success(_):
                                                break
                                            case let .failure(error):
                                                self.removeSpinner()
                                                self.qrScannerView.startRunning()
                                                self.showErrorMessage(message: "An error has occured : \(error.localizedDescription). Try again", title: "Sorry")
                                            }
                                        }
                                    } else {
                                        self.removeSpinner()
                                        self.qrScannerView.startRunning()
                                        self.showErrorMessage(message: "Are you sure you are at the restaurant ?", title: "Humm")
                                    }
                                } else {
                                    self.removeSpinner()
                                    self.qrScannerView.startRunning()
                                    self.showErrorMessage(message: "The restaurant is currenly Closed", title: "Oops")
                                }
                            } else {
                                self.removeSpinner()
                                self.qrScannerView.startRunning()
                                self.showErrorMessage(message: "Couldn't get your location. Try again")
                            }
                        } catch {
                            self.removeSpinner()
                            self.qrScannerView.startRunning()
                            self.showErrorMessage(message: "Sorry, an error occured. Try again")
                        }
                    }
                } else {
                    self.removeSpinner()
                    self.qrScannerView.startRunning()
                    self.showErrorMessage(message: "Sorry, an error occured. Try again")
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.checkLocationAuthorization(status: CLLocationManager.authorizationStatus())
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Toast.makeToast(message: error.localizedDescription, duration: Toast.LONG_LENGTH_DURATION, style: .error)
    }
    
    func qrScannerView(_ qrScannerView: QRScannerView, didFailure error: QRScannerError) {
        self.showErrorMessage(message: error.localizedDescription)
    }

    func qrScannerView(_ qrScannerView: QRScannerView, didSuccess code: String) {
        requestTable(table: code)
    }
    
    func qrScannerView(_ qrScannerView: QRScannerView, didChangeTorchActive isOn: Bool) {
        flashButton.isSelected = isOn
    }
    
    @IBAction func tapFlashButton(_ sender: UIButton) {
        qrScannerView.setTorchActive(isOn: !sender.isSelected)
    }
    
    @objc private func closeScanner() {
        qrScannerView.stopRunning()
        self.dismiss(animated: true, completion: nil)
    }
}
