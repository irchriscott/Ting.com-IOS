//
//  ResetPasswordViewController.swift
//  ting
//
//  Created by Ir Christian Scott on 06/08/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var resetPasswordEmailInput: UITextField!
    
    @IBOutlet var successOverlayView: UIView!
    @IBOutlet weak var checkSuccessImage: UIImageView!
    @IBOutlet weak var textSuccessLabel: UILabel!
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet weak var cancelLabel: UIButton!
    
    let cancelText: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Cancel".uppercased()
        view.textColor = Colors.colorPrimary
        view.font = UIFont(name: "Poppins-Regular", size: 16)!
        view.isUserInteractionEnabled = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShowNotification(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handlekeyboardWillHideNotification(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.view.addSubview(cancelText)
        self.view.addConstraintsWithFormat(format: "V:|-16-[v0]", views: cancelText)
        self.view.addConstraintsWithFormat(format: "H:[v0]-20-|", views: cancelText)
    }
    
    @IBAction func done(_ sender: UITextField) {
        self.resetPasswordEmailInput.resignFirstResponder()
    }

    @IBAction func submitResetPassword(_ sender: UIButton) {
        if let email = self.resetPasswordEmailInput.text, email != "" {
            let params: Parameters = ["email": email]
            
            guard let url = URL(string: URLs.userResetPassword) else { return }
            
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
            self.showErrorMessage(message: "Enter Your Email Address")
        }
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func onCancel(_ sender: UIButton){
        self.resignFirstResponder()
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
}
