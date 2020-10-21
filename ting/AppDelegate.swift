//
//  AppDelegate.swift
//  ting
//
//  Created by Ir Christian Scott on 30/07/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GoogleSignIn
import PushNotifications
import PusherSwift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate, PusherDelegate  {

    var window: UIWindow?
    var locationManager = CLLocationManager()
    var controller: UIViewController?
    
    var signedInUser: GIDGoogleUser?
    var auth = UserAuthentication()
    
    var pusherBeam = PushNotifications.shared
    var pusher: Pusher!
    
    private var didLoadLocation: Bool = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey("AIzaSyD2mLGusTJZqu7zesBgobnoVIzN6hIayvk")
        GMSPlacesClient.provideAPIKey("AIzaSyD2mLGusTJZqu7zesBgobnoVIzN6hIayvk")
        
        GIDSignIn.sharedInstance()?.clientID = StaticData.googleClientID
        GIDSignIn.sharedInstance()?.delegate = self
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.controller = self.window?.rootViewController?.topMostViewController()
        
        self.initializePusherNotification()
        
        let notificationCenter = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                notificationCenter.requestAuthorization(options: options) {
                    (didAllow, error) in
                    if !didAllow {
                        self.controller?.showErrorMessage(message: "Request", title: "Please, Allow this App to send you notifications")
                    }
                }
            }
        }
        
        self.pusherBeam.start(instanceId: StaticData.PUSH_NOTIFICATION_KEY)
        self.pusherBeam.registerForRemoteNotifications()
        
        if auth.isUserLoggedIn() {
            try? self.pusherBeam.addDeviceInterest(interest: auth.get()!.channel)
        }
        
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(UNNotificationPresentationOptions.init(arrayLiteral: [.alert, .sound]))
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        UIApplication.shared.applicationIconBadgeNumber += 1
        if let _ = response.notification.request.content.userInfo["data"] as? String {
            // Navigate to a controller wuth data
            //let homeVC = window?.rootViewController?.children[0]
            //homeVC?.notificationTappedWith(customData: customData)
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.pusherBeam.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(userInfo)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        self.initializePusherNotification()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        self.initializePusherNotification()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        self.initializePusherNotification()
    }
    
    private func initializePusherNotification() {
        if auth.isUserLoggedIn() {
            let options = PusherClientOptions(
                authMethod: .inline(secret: "6528a9e8016a7355e41c"),
                autoReconnect: true,
                host: .cluster("mt1")
            )

            pusher = Pusher(key: "299875b04b5fe1dc527a", options: options)
            pusher.delegate = self
            pusher.connect()
            
            let channel = pusher.subscribe(auth.get()!.channel)
            
            channel.bind(eventName: auth.get()!.channel, callback: { (data: Any?) -> Void in
                
                if let data = data as? [String : AnyObject] {
                    
                    let title = data["title"] as? String
                    let body = data["body"] as? String
                    
                    let content = UNMutableNotificationContent()
                    
                    content.title = title!
                    if data.contains(where: { (key, value) -> Bool in
                        return key == "text"
                    }) {
                        if let text = data["text"] as? String {
                            if text != "" && !text.isEmpty {
                                content.body = "\(body!). \(text)"
                            } else { content.body = body! }
                        } else { content.body = body! }
                    } else { content.body = body! }
                    content.sound = UNNotificationSound.default
                    content.badge = 1
                    content.categoryIdentifier = "Ting.com"
                    content.threadIdentifier = data["identifier"] as? String ?? "Ting.com"
                    content.summaryArgument = data["sender"] as? String ?? "Ting.com"
                    content.summaryArgumentCount = 1
                    
                    UIApplication.shared.applicationIconBadgeNumber += 1
                    
                    if data.contains(where: { (key, value) -> Bool in
                        return key == "image"
                    }) {
                        if let image = data["image"] as? String {
                            if image != "" && !image.isEmpty {
                                let imageIdentifier = Functions.randomString(length: 18)
                                if let notificationImage = UNNotificationAttachment.create(identifier: imageIdentifier, url: URL(string: data["image"] as! String)!, options: nil) {
                                    content.attachments = [notificationImage]
                                }
                            }
                        }
                    }
                    
                    let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 2, repeats: false)
                    let request = UNNotificationRequest.init(identifier: Functions.randomString(length: 30), content: content, trigger: trigger)

                    let center = UNUserNotificationCenter.current()
                    center.delegate = self
                    center.add(request)
                }
            })
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if window != nil {
                Toast.makeToast(message: error.localizedDescription, duration: Toast.MID_LENGTH_DURATION, style: .error)
            }
            return
        }
        
        self.signedInUser = user
        self.didLoadLocation = false
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.startUpdatingLocation()
            break
        case .authorizedWhenInUse:
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.startUpdatingLocation()
        case .denied:
            let alert = UIAlertController(title: "Please, Go to settings and allow this app to use your location", message: nil, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            controller?.present(alert, animated: true, completion: nil)
            break
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
            break
        case .restricted:
            let alert = UIAlertController(title: "Please, Go to settings and allow this app to use your location", message: nil, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            controller?.present(alert, animated: true, completion: nil)
            break
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        self.didLoadLocation = false
        Toast.makeToast(message: error.localizedDescription, duration: Toast.MID_LENGTH_DURATION, style: .error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        if !self.didLoadLocation {
            self.didLoadLocation = true
            self.googleSignIn(location: location.coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {}
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.controller?.removeSpinner()
        Toast.makeToast(message: error.localizedDescription, duration: Toast.MID_LENGTH_DURATION, style: .error)
    }
    
    private func googleSignIn(location: CLLocationCoordinate2D){
        if let user = self.signedInUser {
            controller?.showSpinner(onView: (controller?.view)!)
            let geocoder = GMSGeocoder()
            geocoder.reverseGeocodeCoordinate(location) { (response, error) in
                if let address = response?.firstResult(){
                    DispatchQueue.main.async {
                               
                        let token = "\(user.userID ?? "")-\(user.authentication.idToken ?? Functions.randomString(length: 512))"
                            
                        let formData: Parameters = ["token": token, "name": user.profile.name, "email": user.profile.email, "country": address.country!, "town": address.administrativeArea!, "address": address.lines![0], "longitude": String(address.coordinate.longitude), "latitude": String(address.coordinate.latitude), "type": "Home", "other_address_type": "Home"]
                               
                        guard let url = URL(string: URLs.googleSignup) else { return }
                               
                        var request = URLRequest(url: url)
                        request.httpMethod = "POST"
                               
                        let boundary = Requests().generateBoundary()
                        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                               
                        let httpBody = Requests().createDataBody(withParameters: formData, media: nil, boundary: boundary)
                        request.httpBody = httpBody
                               
                        let session = URLSession.shared
                        session.dataTask(with: request){ (data, response, error) in
                            self.controller?.removeSpinner()
                            if response != nil {}
                            if let data = data {
                                do {
                                    let serverResponse = try JSONDecoder().decode(ServerResponse.self, from: data)
                                    if serverResponse.type == "success" {
                                        DispatchQueue.main.async {
                                                   
                                            Toast.makeToast(message: serverResponse.message, duration: Toast.MID_LENGTH_DURATION, style: .success)
                                            self.controller?.removeSpinner()
                                                   
                                            do {
                                                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return }
                                                let _ = json["msgs"] as? NSArray
                                                let user = try JSONEncoder().encode(serverResponse.user!)
                                                UserAuthentication().saveUserData(data: user)
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                                                    self.locationManager.stopUpdatingLocation()
                                                    let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
                                                    let appDelegate = UIApplication.shared.delegate! as! AppDelegate
                                                    let homeDiscoverViewController = storyBoard.instantiateViewController(withIdentifier: "HomeTabBar")
                                                    appDelegate.window?.rootViewController = homeDiscoverViewController
                                                    appDelegate.window?.makeKeyAndVisible()
                                                })
                                            } catch {}
                                        }
                                    
                                    } else {
                                        self.controller?.showErrorMessage(message: serverResponse.message)
                                    }

                                } catch {
                                    self.controller?.showErrorMessage(message: error.localizedDescription)
                                }
                            }
                        }.resume()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.controller?.removeSpinner()
                        self.controller?.showErrorMessage(message: "Couldnt Fetch Location")
                    }
                }
                if let err = error {
                    DispatchQueue.main.async {
                        self.controller?.removeSpinner()
                        self.controller?.showErrorMessage(message: err.localizedDescription)
                    }
                }
            }
        }
    }
}
