//
//  EditUserCollectionViewCell.swift
//  ting
//
//  Created by Christian Scott on 25/08/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit

class EditUserCollectionViewCell: UICollectionViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var editUserController: EditUserCollectionViewController?
    var navbarHeight: CGFloat?
    let session = UserAuthentication().get()
    
    let separator_1: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.colorVeryLightGray
        return view
    }()
    
    let separator_2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.colorVeryLightGray
        return view
    }()
    
    let separator_3: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.colorVeryLightGray
        return view
    }()
    
    let labelLoginEditView: BigTitleTextLabel = {
        let view = BigTitleTextLabel()
        view.text = "Log In"
        return view
    }()
    
    let labelPrivateEditView: BigTitleTextLabel = {
        let view = BigTitleTextLabel()
        view.text = "Private Information"
        return view
    }()
    
    let labelPublicEditView: BigTitleTextLabel = {
        let view = BigTitleTextLabel()
        view.text = "Public Information"
        return view
    }()
    
    let labelAddressesEditView: BigTitleTextLabel = {
        let view = BigTitleTextLabel()
        view.text = "Addresses"
        return view
    }()
    
    let emailEditView: UIEditUserRowView = {
        let view = UIEditUserRowView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordEditView: UIEditUserRowView = {
        let view = UIEditUserRowView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let dobEditView: UIEditUserRowView = {
        let view =  UIEditUserRowView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let phoneEditView: UIEditUserRowView = {
        let view =  UIEditUserRowView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameEditView: UIEditUserRowView = {
        let view =  UIEditUserRowView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let usernameEditView: UIEditUserRowView = {
        let view =  UIEditUserRowView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let genderEditView: UIEditUserRowView = {
        let view =  UIEditUserRowView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let userAddresses: UserAddressesView = {
        let view = UserAddressesView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    private func setup(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShowNotification(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handlekeyboardWillHideNotification(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        emailEditView.setup(hasButton: true, isEditable: false, title: "Email Address", value: session!.email, controller: self.editUserController, type: .text, data: [])
        passwordEditView.setup(hasButton: true, isEditable: false, title: "Password", value: "12345678", controller: self.editUserController, type: .password, data: [])
        dobEditView.setup(hasButton: false, isEditable: true, title: "Date Of Birth", value: session!.dob ?? "", controller: self.editUserController, type: .date, data: [])
        phoneEditView.setup(hasButton: false, isEditable: true, title: "Phone Number", value: session!.phone, controller: self.editUserController, type: .text, data: [])
        nameEditView.setup(hasButton: false, isEditable: true, title: "Full Name", value: session!.name, controller: self.editUserController, type: .text, data: [])
        usernameEditView.setup(hasButton: false, isEditable: true, title: "Username", value: session!.username, controller: self.editUserController, type: .text, data: [])
        genderEditView.setup(hasButton: false, isEditable: true, title: "Gender", value: session!.gender ?? "Other", controller: self.editUserController, type: .dropdown, data: StaticData.genders)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        datePicker.date = dateFormatter.date(from: session!.dob ?? "1999-01-01")!
        self.dobEditView.input.inputView = datePicker
        self.dobEditView.input.text = session!.dob
        
        let toolbarDob = UIToolbar()
        toolbarDob.barStyle = UIBarStyle.default
        toolbarDob.isTranslucent = true
        toolbarDob.tintColor = .darkGray
        toolbarDob.backgroundColor = Colors.colorPrimaryDark
        toolbarDob.alpha = 1.0
        toolbarDob.sizeToFit()
        
        let doneButtonDob = UIBarButtonItem(title: "DONE", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneEditing))
        doneButtonDob.setTitleTextAttributes([.foregroundColor: Colors.colorDarkGray], for: .normal)
        doneButtonDob.tintColor = .darkGray
        toolbarDob.setItems([doneButtonDob], animated: false)
        toolbarDob.isUserInteractionEnabled = true
        self.dobEditView.input.inputAccessoryView = toolbarDob
        
        self.genderEditView.input.text = session!.gender
        let genderPickerView = UIPickerView()
        genderPickerView.selectedRow(inComponent: StaticData.genders.index(of: session!.gender!) ?? 0)
        genderPickerView.tag = 0
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        
        let toolbarGender = UIToolbar()
        toolbarGender.barStyle = UIBarStyle.default
        toolbarGender.isTranslucent = true
        toolbarGender.tintColor = .darkGray
        toolbarGender.backgroundColor = Colors.colorPrimaryDark
        toolbarGender.alpha = 1.0
        toolbarGender.sizeToFit()
        
        let doneButtonGender = UIBarButtonItem(title: "DONE", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneEditing))
        doneButtonGender.setTitleTextAttributes([.foregroundColor: Colors.colorDarkGray], for: .normal)
        doneButtonGender.tintColor = .darkGray
        toolbarGender.setItems([doneButtonGender], animated: false)
        toolbarGender.isUserInteractionEnabled = true
        self.genderEditView.input.inputView = genderPickerView
        self.genderEditView.input.inputAccessoryView = toolbarGender
        
        phoneEditView.input.addTarget(self, action: #selector(doneEditing), for: .primaryActionTriggered)
        nameEditView.input.addTarget(self, action: #selector(doneEditing), for: .primaryActionTriggered)
        usernameEditView.input.addTarget(self, action: #selector(doneEditing), for: .primaryActionTriggered)
        
        addSubview(labelLoginEditView)
        addSubview(emailEditView)
        addSubview(passwordEditView)
        addSubview(separator_1)
        addSubview(labelPrivateEditView)
        addSubview(dobEditView)
        addSubview(phoneEditView)
        addSubview(separator_2)
        addSubview(labelPublicEditView)
        addSubview(nameEditView)
        addSubview(usernameEditView)
        addSubview(genderEditView)
        addSubview(separator_3)
        addSubview(labelAddressesEditView)
        addSubview(userAddresses)
        
        self.userAddresses.editUserController = self.editUserController
        self.userAddresses.navbarHeight = self.navbarHeight
        
        addConstraintsWithFormat(format: "H:|-15-[v0]", views: labelLoginEditView)
        addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: emailEditView)
        addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: passwordEditView)
        addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: separator_1)
        addConstraintsWithFormat(format: "H:|-15-[v0]", views: labelPrivateEditView)
        addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: dobEditView)
        addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: phoneEditView)
        addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: separator_2)
        addConstraintsWithFormat(format: "H:|-15-[v0]", views: labelPublicEditView)
        addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: nameEditView)
        addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: usernameEditView)
        addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: genderEditView)
        addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: separator_3)
        addConstraintsWithFormat(format: "H:|-15-[v0]", views: labelAddressesEditView)
        addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: userAddresses)
        addConstraintsWithFormat(format: "V:|-15-[v0]-15-[v1(50)]-0-[v2(50)]-15-[v3(1)]-15-[v4]-15-[v5(50)]-0-[v6(50)]-15-[v7(1)]-15-[v8]-15-[v9(50)]-0-[v10(50)]-0-[v11(50)]-15-[v12(1)]-15-[v13]-15-[v14]", views: labelLoginEditView, emailEditView, passwordEditView, separator_1, labelPrivateEditView, dobEditView, phoneEditView, separator_2, labelPublicEditView, nameEditView, usernameEditView, genderEditView, separator_3, labelAddressesEditView, userAddresses)
        
        let openEditEmailDialog = UITapGestureRecognizer(target: self, action: #selector(openEditEmail(gestureRecognizer:)))
        emailEditView.button.addGestureRecognizer(openEditEmailDialog)
        
        let openEditPasswordDialog = UITapGestureRecognizer(target: self, action: #selector(openEditPassword(gestureRecognizer:)))
        passwordEditView.button.addGestureRecognizer(openEditPasswordDialog)
    }
    
    @objc func openEditEmail(gestureRecognizer: UITapGestureRecognizer){
        let alert = UIAlertController(title: "Edit Email Address", message: nil, preferredStyle: UIAlertController.Style.alert)
        let action =  UIAlertAction(title: "OK", style: .default) { (alertAction) in
            let oldEmail = alert.textFields![0] as UITextField
            let newEmail = alert.textFields![1] as UITextField
            let password = alert.textFields![2] as UITextField
            
            if oldEmail.text == nil || newEmail.text == nil || password.text == nil {
                Toast.makeToast(message: "Fill All Fields", duration: Toast.LONG_LENGTH_DURATION, style: .error)
                return
            }
            
            let spinner = Spinner()
            spinner.show()
            
            let params: Parameters = ["token": self.session!.token!, "old_email": oldEmail.text!, "new_email": newEmail.text!, "password": password.text!, "os": "Apple IOS", "tz": TimeZone.current.description, "time": Date().description]
            
            guard let url = URL(string: URLs.updateProfileEmail) else { return }
            
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
                spinner.hide()
                if response != nil {}
                if let data = data {
                    do {
                        let serverResponse = try JSONDecoder().decode(ServerResponse.self, from: data)
                        if serverResponse.type == "success" {
                            DispatchQueue.main.async {
                                alert.dismiss(animated: true, completion: nil)
                                Toast.makeToast(message: serverResponse.message, duration: Toast.MID_LENGTH_DURATION, style: .success)
                                do {
                                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return }
                                    let _ = json["msgs"] as? NSArray
                                    let user = try JSONEncoder().encode(serverResponse.user!)
                                    UserAuthentication().saveUserData(data: user)
                                } catch {}
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.editUserController!.showErrorMessage(message: serverResponse.message)
                            }
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self.editUserController!.showErrorMessage(message: error.localizedDescription)
                        }
                    }
                }
            }.resume()
        }
        
        let cancel = UIAlertAction(title: "CANCEL", style: .destructive) { (alertAction) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Old Email Address"
            textField.keyboardType = .emailAddress
            textField.returnKeyType = .next
            textField.addTarget(self, action: #selector(self.doneEditing), for: UIControl.Event.primaryActionTriggered)
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "New Email Address"
            textField.keyboardType = .emailAddress
            textField.returnKeyType = .next
            textField.addTarget(self, action: #selector(self.doneEditing), for: UIControl.Event.primaryActionTriggered)
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
            textField.keyboardType = .default
            textField.returnKeyType = .done
            
            textField.addTarget(self, action: #selector(self.doneEditing), for: UIControl.Event.primaryActionTriggered)
        }
        alert.addAction(action)
        alert.addAction(cancel)
        editUserController?.present(alert, animated: true, completion: nil)
    }
    
    @objc func openEditPassword(gestureRecognizer: UITapGestureRecognizer){
        let alert = UIAlertController(title: "Edit Password", message: nil, preferredStyle: UIAlertController.Style.alert)
        let action =  UIAlertAction(title: "OK", style: .default) { (alertAction) in
            let oldPassword = alert.textFields![0] as UITextField
            let newPassword = alert.textFields![1] as UITextField
            let confirmPassword = alert.textFields![2] as UITextField
            
            if oldPassword.text == nil || newPassword.text == nil || confirmPassword.text == nil {
                Toast.makeToast(message: "Fill All Fields", duration: Toast.LONG_LENGTH_DURATION, style: .error)
                return
            }
            
            let spinner = Spinner()
            spinner.show()
            
            let params: Parameters = ["token": self.session!.token!, "old_password": oldPassword.text!, "new_password": newPassword.text!, "confirm_password": confirmPassword.text!, "os": "Apple IOS", "tz": TimeZone.current.description, "time": Date().description]
            
            guard let url = URL(string: URLs.updateProfilePassword) else { return }
            
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
                spinner.hide()
                if response != nil {}
                if let data = data {
                    do {
                        let serverResponse = try JSONDecoder().decode(ServerResponse.self, from: data)
                        if serverResponse.type == "success" {
                            DispatchQueue.main.async {
                                alert.dismiss(animated: true, completion: nil)
                                Toast.makeToast(message: serverResponse.message, duration: Toast.MID_LENGTH_DURATION, style: .success)
                                do {
                                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return }
                                    let _ = json["msgs"] as? NSArray
                                    let user = try JSONEncoder().encode(serverResponse.user!)
                                    UserAuthentication().saveUserData(data: user)
                                } catch {}
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.editUserController!.showErrorMessage(message: serverResponse.message)
                            }
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self.editUserController!.showErrorMessage(message: error.localizedDescription)
                        }
                    }
                }
            }.resume()
        }
        
        let cancel = UIAlertAction(title: "CANCEL", style: .destructive) { (alertAction) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Old Password"
            textField.isSecureTextEntry = true
            textField.keyboardType = .default
            textField.returnKeyType = .next
            textField.addTarget(self, action: #selector(self.doneEditing), for: UIControl.Event.primaryActionTriggered)
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "New Password"
            textField.isSecureTextEntry = true
            textField.keyboardType = .default
            textField.returnKeyType = .next
            textField.addTarget(self, action: #selector(self.doneEditing), for: UIControl.Event.primaryActionTriggered)
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Confirm Password"
            textField.isSecureTextEntry = true
            textField.keyboardType = .default
            textField.returnKeyType = .done
            
            textField.addTarget(self, action: #selector(self.doneEditing), for: UIControl.Event.primaryActionTriggered)
        }
        alert.addAction(action)
        alert.addAction(cancel)
        editUserController?.present(alert, animated: true, completion: nil)
    }
    
    public func updateUser(){
        self.doneEditing()
        if let dob = dobEditView.input.text, let phone = phoneEditView.input.text, let name = nameEditView.input.text, let username = usernameEditView.input.text, let gender = genderEditView.input.text {
            
            let spinner = Spinner()
            spinner.show()
            
            let params: Parameters = ["token": self.session!.token!, "date_of_birth": dob, "phone": phone, "gender": gender, "name": name, "username": username, "os": "Apple IOS", "tz": TimeZone.current.description, "time": Date().description]
            
            guard let url = URL(string: URLs.updateProfileIdentity) else { return }
            
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
                spinner.hide()
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
                                } catch {}
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.editUserController!.showErrorMessage(message: serverResponse.message)
                            }
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self.editUserController!.showErrorMessage(message: error.localizedDescription)
                        }
                    }
                }
            }.resume()
        } else { Toast.makeToast(message: "Fill All Fields", duration: Toast.LONG_LENGTH_DURATION, style: .error) }
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.dobEditView.input.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc func handleKeyboardWillShowNotification(notification: NSNotification){
        if let userinfo = notification.userInfo{
            let keyboardFrame = (userinfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
            self.editUserController?.collectionView.contentInset.bottom = (self.editUserController?.view.convert(keyboardFrame!, from: nil).size.height)!
        }
    }
    
    @objc func handlekeyboardWillHideNotification(notification: NSNotification){
        self.editUserController?.collectionView.contentInset.bottom = 0
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return StaticData.genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.genderEditView.input.text = StaticData.genders[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return StaticData.genders[row]
    }
    
    @objc func doneEditing(){
        editUserController?.view.endEditing(true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
