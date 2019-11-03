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
    var user: User?
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
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
        collectionView.register(UserHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
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
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! UserHeaderCell
        header.namesLabel.text = user!.name
        header.addressLabel.text = "\(user!.town), \(user!.country)"
        header.profileImageView.load(url: URL(string: "\(URLs.uploadEndPoint)\(user!.image)")!)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 275)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


class UserHeaderCell : UICollectionViewCell {
    
    let coverView: UIView = {
        let view = UIView()
        if let window = UIApplication.shared.keyWindow {
            view.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: 120)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        view.setLinearGradientBackgroundColor(colorOne: Colors.colorPrimaryDark, colorTwo: Colors.colorPrimary)
        return view
    }()
    
    let profileImageView: UIImageView = {
        let view = UIImageView()
        view.frame = CGRect(x: 0, y: 0, width: 180, height: 180)
        view.layer.cornerRadius = view.frame.size.height / 2
        view.layer.masksToBounds = true
        view.layer.borderColor = Colors.colorWhite.cgColor
        view.layer.borderWidth = 4.0
        view.image = UIImage(named: "default_user")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let namesLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .center
        view.font = UIFont(name: "Poppins-SemiBold", size: 24)
        view.textColor = Colors.colorGray
        return view
    }()
    
    let addressLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .center
        view.font = UIFont(name: "Poppins-Regular", size: 15)
        view.textColor = Colors.colorGray
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    func setup(){
        addSubview(coverView)
        addSubview(profileImageView)
        addSubview(namesLabel)
        addSubview(addressLabel)
        
        addConstraintsWithFormat(format: "H:|-0-[v0]-0-|", views: coverView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: coverView)
        
        addConstraintsWithFormat(format: "H:[v0(180)]", views: profileImageView)
        addConstraintsWithFormat(format: "V:|-20-[v0(180)]", views: profileImageView)
        addConstraint(NSLayoutConstraint.init(item: profileImageView, attribute: .centerX, relatedBy: .equal, toItem: coverView, attribute: .centerX, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: namesLabel, attribute: .top, relatedBy: .equal, toItem: profileImageView, attribute: .bottom, multiplier: 1, constant: 10))
        addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: namesLabel)
        addConstraintsWithFormat(format: "V:[v0(25)]", views: namesLabel)
        
        addConstraint(NSLayoutConstraint(item: addressLabel, attribute: .top, relatedBy: .equal, toItem: namesLabel, attribute: .bottom, multiplier: 1, constant: 6))
        addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: addressLabel)
        addConstraintsWithFormat(format: "V:[v0(25)]", views: addressLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class UserTabContentViewCell : UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    let cellId = "cellId"
    
    lazy var userTabLayout : UserTabLayoutView  = {
        let view = UserTabLayoutView()
        view.userTabContentView = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var userViewPager: UICollectionView = {
        let layout =  UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = Colors.colorWhite
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    func setup(){
        addSubview(userTabLayout)
        addSubview(userViewPager)
        
        userViewPager.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        userViewPager.isPagingEnabled = true
        
        if let flowLayout = userViewPager.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: userTabLayout)
        addConstraintsWithFormat(format: "V:|[v0(50)]", views: userTabLayout)
        
        addConstraintsWithFormat(format: "V:|-50-[v0]|", views: userViewPager)
        addConstraintsWithFormat(format: "H:|[v0]|", views: userViewPager)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        userTabLayout.selectorTabViewLeftAnchor?.constant = scrollView.contentOffset.x / 3
    }
    
    func scrollToMenuAtIndex(menuIndex: Int){
        let indexPath = IndexPath(item: menuIndex, section: 0)
        userViewPager.scrollToItem(at: indexPath, at: .left, animated: true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        userTabLayout.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
