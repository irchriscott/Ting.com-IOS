//
//  EditUserCollectionViewController.swift
//  ting
//
//  Created by Ir Christian Scott on 22/08/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit

class EditUserCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let reuseIdentifier = "Cell"
    private let headerId = "Header"
    private let session = UserAuthentication().get()
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SAVE", style: .plain, target: self, action: #selector(save(sender:)))
        self.collectionView.register(EditUserProfileImageViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        self.collectionView.register(EditUserCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    @objc func save(sender: UIBarButtonItem){
        let editUserForm = EditUserCollectionViewCell()
        editUserForm.updateUser()
    }
    
    func setupNavigationBar(){
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationItem.title = session!.username
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationItem.largeTitleDisplayMode = .never
        
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
        
        let barButtonAppearance = UIBarButtonItem.appearance()
        barButtonAppearance.setTitleTextAttributes([.foregroundColor : Colors.colorWhite], for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupNavigationBar()
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! EditUserProfileImageViewCell
        cell.editUserController = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 74)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = CGFloat(618 + (session!.addresses!.count * 61) + 78)
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! EditUserCollectionViewCell
        cell.editUserController = self
        cell.navbarHeight = self.navigationController?.navigationBar.frame.height
        return cell
    }
}

class EditUserProfileImageViewCell : UICollectionViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let session = UserAuthentication().get()
    var editUserController: EditUserCollectionViewController?
    
    let imagePicker = UIImagePickerController()
    
    let userImageView: UIImageView = {
        let view = UIImageView()
        view.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "default_user")
        view.layer.borderColor = Colors.colorVeryLightGray.cgColor
        view.layer.cornerRadius = view.frame.height / 2
        view.layer.masksToBounds = true
        view.layer.borderWidth = 2
        return view
    }()
    
    let delimiterView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.colorVeryLightGray
        return view
    }()
    
    let updateImageLabel: UILabel = {
        let view = UILabel()
        view.textColor = Colors.colorLightGray
        view.text = "Change Profile Image"
        view.font = UIFont(name: "Poppins-Regular", size: 15)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let chooseImageView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.colorDarkTransparent
        view.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        view.layer.cornerRadius = view.frame.height / 2
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let addImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "icon_add_image")
        view.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        view.alpha = 0.5
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    private func setup(){
        addSubview(userImageView)
        addSubview(updateImageLabel)
        addSubview(chooseImageView)
        addSubview(delimiterView)
        
        userImageView.kf.setImage(
            with: URL(string: "\(URLs.uploadEndPoint)\(session!.image)")!,
            placeholder: UIImage(named: "default_user"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ]
        )
        
        let openImageGaleryTapGesture = UITapGestureRecognizer(target: self, action: #selector(openImageGalery(getsureRecognizer:)))
        chooseImageView.addGestureRecognizer(openImageGaleryTapGesture)
        
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = false

        let barButtonAppearance = UIBarButtonItem.appearance()
        barButtonAppearance.setTitleTextAttributes([.foregroundColor : Colors.colorPrimary], for: .normal)
        
        addImage.center = chooseImageView.center
        chooseImageView.addSubview(addImage)
        
        addConstraintsWithFormat(format: "V:|-10-[v0(50)]", views: userImageView)
        addConstraintsWithFormat(format: "H:|-15-[v0(50)]-15-[v1]-15-[v2(35)]-15-|", views: userImageView, updateImageLabel, chooseImageView)
        
        addConstraintsWithFormat(format: "V:[v0]", views: updateImageLabel)
        addConstraint(NSLayoutConstraint(item: updateImageLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        addConstraintsWithFormat(format: "V:[v0(35)]", views: chooseImageView)
        addConstraint(NSLayoutConstraint(item: chooseImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        addConstraintsWithFormat(format: "V:[v0(1)]|", views: delimiterView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: delimiterView)
    }
    
    @objc func openImageGalery(getsureRecognizer: UITapGestureRecognizer){
        let barButtonAppearance = UIBarButtonItem.appearance()
        barButtonAppearance.setTitleTextAttributes([.foregroundColor : UIColor.systemBlue], for: .normal)
        imagePicker.navigationBar.backIndicatorImage = UIImage(named: "icon_unwind_25_primary")
        imagePicker.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "icon_unwind_25_primary")
        imagePicker.navigationBar.tintColor = .systemBlue
        editUserController?.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            userImageView.image = image
            let spinner = Spinner()
            spinner.show()
            
            let params: Parameters = ["token": session!.token!]
            guard let url = URL(string: URLs.updateProfileImage) else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue(session!.token!, forHTTPHeaderField: "AUTHORIZATION")
            request.setValue(session!.token!, forHTTPHeaderField: "AUTHORIZATION")
            
            let boundary = Requests().generateBoundary()
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            guard let profileImage = Media.init(withImage: image, forKey: "image") else { return }
            
            let httpBody = Requests().createDataBody(withParameters: params, media: [profileImage], boundary: boundary)
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
                                self.userImageView.load(url: URL(string: "\(URLs.uploadEndPoint)\(self.session!.image)")!)
                                self.editUserController!.showErrorMessage(message: serverResponse.message)
                            }
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self.userImageView.load(url: URL(string: "\(URLs.uploadEndPoint)\(self.session!.image)")!)
                            self.editUserController!.showErrorMessage(message: error.localizedDescription)
                        }
                    }
                }
            }.resume()
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
