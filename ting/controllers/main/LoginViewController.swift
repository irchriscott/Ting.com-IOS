//
//  ViewController.swift
//  ting
//
//  Created by Ir Christian Scott on 30/07/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit
import QuartzCore
import GoogleSignIn

class LoginViewController: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var loginEmailInput: UITextField!
    @IBOutlet weak var loginPasswordInput: UITextField!
    @IBOutlet weak var loginSubmitButton: UIButton!
    @IBOutlet weak var googleAuthButton: UIButton!
    
    @IBOutlet var successOverlayView: UIView!
    @IBOutlet weak var checkSuccessImage: UIImageView!
    @IBOutlet weak var textSuccessLabel: UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signOut()
        
        if UserAuthentication().isUserLoggedIn() {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
            let appDelegate = UIApplication.shared.delegate! as! AppDelegate
            let homeDiscoverViewController = storyBoard.instantiateViewController(withIdentifier: "HomeTabBar")
            appDelegate.window?.rootViewController = homeDiscoverViewController
            appDelegate.window?.makeKeyAndVisible()
        }
        
        self.googleAuthButton.layer.cornerRadius = self.googleAuthButton.frame.size.height / 2
        self.googleAuthButton.layer.masksToBounds = true
        self.googleAuthButton.setLinearGradientBackgroundColor(colorOne: Colors.colorGoogleRedTwo, colorTwo: Colors.colorGoogleRedOne)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShowNotification(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handlekeyboardWillHideNotification(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    @IBAction func next(_ sender: UITextField) {
        self.loginPasswordInput.becomeFirstResponder()
    }
    
    @IBAction func done(_ sender: UITextField) {
        self.loginPasswordInput.resignFirstResponder()
    }
    
    @IBAction func login(_ sender: Any) {
        self.view.endEditing(true)
        if let email = self.loginEmailInput.text, email != "", let password =  self.loginPasswordInput.text, password != "" {
            let params: Parameters = ["email": email, "password": password]
            
            guard let url = URL(string: URLs.authLoginUser) else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let boundary = Requests().generateBoundary()
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            let httpBody = Requests().createDataBody(withParameters: params, media: nil, boundary: boundary)
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
                                self.showSuccessMessage(successOverlayView: self.successOverlayView, image: self.checkSuccessImage, label: self.textSuccessLabel, message: serverResponse.message)

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
                            DispatchQueue.main.async {
                                self.showErrorMessage(message: serverResponse.message)
                            }
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self.showErrorMessage(message: error.localizedDescription)
                        }
                    }
                }
            }.resume()
            
        } else { self.showErrorMessage(message: "Fill All The Fields") }
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){}
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        let segue = UnwindLeftToRightSegue(identifier: unwindSegue.identifier, source: unwindSegue.source, destination: unwindSegue.destination)
        segue.perform()
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
    
    @IBAction func signInWithGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

