//
//  UserViewController.swift
//  ting
//
//  Created by Ir Christian Scott on 20/08/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit

class UserViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    let headerId = "headerId"
    var selectedTab: Int?
    
    var user: User? {
        didSet {}
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationBar()
        let session = UserAuthentication().get()!
        
        if session.id == user!.id {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_edit_25_white"), style: .plain, target: self, action: #selector(edit(sender:)))
        }
        
        collectionView.register(UserTabContentViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(UserHeaderViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
    }
    
    func setupNavigationBar(){
        self.navigationController?.navigationBar.barTintColor = Colors.colorPrimaryDark
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = Colors.colorPrimaryDark
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barStyle = .black
        
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "icon_unwind_25_white")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "icon_unwind_25_white")
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.title = ""
        self.navigationItem.largeTitleDisplayMode = .always
        
        let barButtonAppearance = UIBarButtonItem.appearance()
        barButtonAppearance.setTitleTextAttributes([.foregroundColor : UIColor.white], for: .normal)
        
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
            statusBar.backgroundColor = Colors.colorPrimaryDark
            UIApplication.shared.keyWindow?.addSubview(statusBar)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupNavigationBar()
    }
    
    @objc func edit(sender: UIBarButtonItem){
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let editUserViewController = storyboard.instantiateViewController(withIdentifier: "EditUser") as! EditUserCollectionViewController
        self.navigationController?.pushViewController(editUserViewController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserTabContentViewCell
        let index = IndexPath(item: selectedTab!, section: 0)
        cell.userViewPager.selectItem(at: index, animated: false, scrollPosition: .right)
        cell.userViewPager.scrollToItem(at: index, at: .right, animated: false)
        cell.userTabLayout.collectionView.selectItem(at: index, animated: false, scrollPosition: .top)
        cell.userTabLayout.selectorTabViewLeftAnchor?.constant = CGFloat(selectedTab!) * ( view.frame.width / 3 )
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! UserHeaderViewCell
        header.namesLabel.text = user!.name
        header.addressLabel.text = "\(user!.town), \(user!.country)"
        header.profileImageView.kf.setImage(
            with: URL(string: "\(URLs.uploadEndPoint)\(user!.image)")!,
            placeholder: UIImage(named: "default_user"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ]
        )
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 260)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
