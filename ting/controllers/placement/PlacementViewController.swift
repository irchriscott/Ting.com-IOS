//
//  PlacementViewController.swift
//  ting
//
//  Created by Christian Scott on 29/09/2020.
//  Copyright © 2020 Ir Christian Scott. All rights reserved.
//

import UIKit

class PlacementViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let headerId = "headerId"
    let footerId = "footerId"
    let cellId = "cellId"
    
    var placement: Placement? {
        didSet {
            if let _ = self.placement {
                self.collectionView.reloadData()
            }
        }
    }
    
    let colors: [UIColor] = [Colors.colorPlacementMenuOne, Colors.colorPlacementMenuTwo, Colors.colorPlacementMenuThree, Colors.colorPlacementMenuFour, Colors.colorPlacementMenuFive, Colors.colorPlacementMenuSix]
    
    let menus:[[String]] = [
        ["Foods", "icon_p_menu_foods"],
        ["Drinks", "icon_p_menu_drinks"],
        ["Dishes", "icon_p_menu_dishes"],
        ["Orders", "icon_p_menu_orders"],
        ["Bill", "icon_p_menu_bill"],
        ["Request Waiter", "icon_p_menu_request"]
    ].reversed()
    
    var loadedData:[Bool] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        
        self.loadedData = [Bool](repeating: false, count: 6)
        
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.cellId)
        self.collectionView.register(PlacementHeaderViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: self.headerId)
        self.collectionView.register(PlacementFooterViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: self.footerId)
        
        if let place = PlacementProvider().get() {
            self.placement = place
        }
        
        self.getPlacement()
    }
    
    private func getPlacement() {
        if let token = PlacementProvider().getToken() {
            APIDataProvider.instance.getCurrentPlacement(token: token) { (place) in
                DispatchQueue.main.async {
                    if let placement = place {
                        PlacementProvider().setToken(data: placement.token)
                        let placeData = try! JSONEncoder().encode(placement)
                        PlacementProvider().set(data: placeData)
                        self.placement = placement
                    }
                }
            }
        }
    }
    
    private func setupNavigationBar(){
        self.navigationController?.navigationBar.barTintColor = Colors.colorPrimaryDark
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = Colors.colorPrimaryDark
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barStyle = .black
        
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "icon_unwind_25_white")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "icon_unwind_25_white")
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.title = ""
        self.navigationItem.largeTitleDisplayMode = .never
        
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
        
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

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath)
        cell.backgroundColor = colors[indexPath.row]
        cell.layer.cornerRadius = 4
        
        let menu = self.menus[indexPath.row]
        
        let menuView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let iconView: UIImageView = {
            let view = UIImageView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let nameView: UILabel = {
            let view = UILabel()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.font = UIFont(name: "Poppins-SemiBold", size: 16)
            view.textColor = Colors.colorWhite
            view.textAlignment = .center
            return view
        }()
        
        if !self.loadedData[indexPath.row] {
            iconView.image = UIImage(named: menu[1])
            nameView.text = menu[0].uppercased()
            
            menuView.addSubview(iconView)
            menuView.addSubview(nameView)
            
            menuView.addConstraintsWithFormat(format: "H:[v0(40)]", views: iconView)
            menuView.addConstraintsWithFormat(format: "H:|[v0]|", views: nameView)
            menuView.addConstraintsWithFormat(format: "V:|[v0(40)]-10-[v1(30)]|", views: iconView, nameView)
            
            menuView.addConstraint(NSLayoutConstraint(item: iconView, attribute: .centerX, relatedBy: .equal, toItem: menuView, attribute: .centerX, multiplier: 1, constant: 0))
            
            cell.addSubview(menuView)
            cell.addConstraintsWithFormat(format: "H:[v0]", views: menuView)
            cell.addConstraintsWithFormat(format: "V:[v0(80)]", views: menuView)
            
            cell.addConstraint(NSLayoutConstraint(item: menuView, attribute: .centerX, relatedBy: .equal, toItem: cell, attribute: .centerX, multiplier: 1, constant: 0))
            cell.addConstraint(NSLayoutConstraint(item: menuView, attribute: .centerY, relatedBy: .equal, toItem: cell, attribute: .centerY, multiplier: 1, constant: 0))
        }
        
        self.loadedData[indexPath.row] = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headerId, for: indexPath) as! PlacementHeaderViewCell
            cell.placement = self.placement
            return cell
        default:
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.footerId, for: indexPath) as! PlacementFooterViewCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((self.view.frame.width - 24) / 2) - 6, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 146)
    }
}


class PlacementHeaderViewCell : UICollectionViewCell {
    
    let restaurantImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "default_restaurant")
        view.layer.cornerRadius = 50
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let restaurantName: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-SemiBold", size: 15.0)
        view.textColor = Colors.colorVeryLightGray
        view.text = "Christian Scott"
        view.backgroundColor = Colors.colorVeryLightGray
        view.textAlignment = .center
        return view
    }()
    
    let billNumber: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-Regular", size: 25.0)
        view.textColor = Colors.colorVeryLightGray
        view.text = "0012"
        view.backgroundColor = Colors.colorVeryLightGray
        view.textAlignment = .center
        return view
    }()
    
    let dataView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let waiterView: ImageTextView = {
        let view = ImageTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Christian Scott"
        view.textColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 0.7)
        return view
    }()
    
    let peopleView: IconTextView = {
        let view = IconTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "123"
        view.textColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 0.7)
        view.icon = UIImage(named: "icon_people_25_gray")!
        return view
    }()
    
    var placement: Placement? {
        didSet {
            if let placement = self.placement {
                restaurantName.textColor  = Colors.colorGray
                restaurantName.backgroundColor = .white
                
                billNumber.textColor = Colors.colorGray
                billNumber.backgroundColor = .white
                
                waiterView.textColor = Colors.colorGray
                peopleView.textColor = Colors.colorGray
                
                restaurantName.text = "\((placement.table.branch?.restaurant?.name)!), \((placement.table.branch?.name)!)"
                restaurantImage.kf.setImage(
                    with: URL(string: "\(URLs.hostEndPoint)\((placement.table.branch?.restaurant?.logo)!)")!,
                    placeholder: UIImage(named: "default_restaurant"),
                    options: [
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(1)),
                        .cacheOriginalImage
                    ]
                )
                
                if let bill = placement.bill {
                    billNumber.text = "Bill No \(bill.number)"
                } else { billNumber.text = "Bill No -" }
                
                if let waiter = placement.waiter {
                    waiterView.text = waiter.name
                    waiterView.imageURL = "\(URLs.hostEndPoint)\(waiter.image)"
                } else { waiterView.text = "-" }
                
                peopleView.text = String(placement.people)
            }
            self.setup()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    private func setup() {
        dataView.addSubview(waiterView)
        dataView.addSubview(peopleView)
        
        dataView.addConstraintsWithFormat(format: "V:|[v0(26)]|", views: waiterView)
        dataView.addConstraintsWithFormat(format: "V:|[v0(26)]|", views: peopleView)
        
        dataView.addConstraintsWithFormat(format: "H:|[v0]-8-[v1]|", views: waiterView, peopleView)
        
        addSubview(restaurantImage)
        addSubview(restaurantName)
        addSubview(billNumber)
        addSubview(dataView)
        
        addConstraintsWithFormat(format: "H:[v0(100)]", views: restaurantImage)
        addConstraintsWithFormat(format: "H:|[v0]|", views: restaurantName)
        addConstraintsWithFormat(format: "H:|[v0]|", views: billNumber)
        addConstraintsWithFormat(format: "H:[v0]", views: dataView)
        
        addConstraintsWithFormat(format: "V:|-16-[v0(100)]-8-[v1(24)]-[v2(30)]-12-[v3(26)]", views: restaurantImage, restaurantName, billNumber, dataView)
        
        addConstraint(NSLayoutConstraint.init(item: restaurantImage, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint.init(item: restaurantName, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint.init(item: billNumber, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint.init(item: dataView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PlacementFooterViewCell : UICollectionViewCell {
    
    let captureMomentButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleLabel?.text = "Capture & Share Moment".uppercased()
        view.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 16)!
        view.titleLabel?.textColor = Colors.colorWhite
        view.titleLabel?.textAlignment = .center
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()
    
    let endPlacementButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleLabel?.text = "End Placement".uppercased()
        view.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 16)!
        view.titleLabel?.textColor = Colors.colorWhite
        view.titleLabel?.textAlignment = .center
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    private func setup() {
        
        captureMomentButton.setTitle("Capture & Share Moment".uppercased(), for: .normal)
        captureMomentButton.setTitleColor(Colors.colorWhite, for: .normal)
        captureMomentButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 16)!
        
        endPlacementButton.setTitle("End Placement".uppercased(), for: .normal)
        endPlacementButton.setTitleColor(Colors.colorWhite, for: .normal)
        endPlacementButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 16)!
        
        addSubview(captureMomentButton)
        addSubview(endPlacementButton)
        
        addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: captureMomentButton)
        addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: endPlacementButton)
        addConstraintsWithFormat(format: "V:|-12-[v0(55)]-12-[v1(55)]-12-|", views: captureMomentButton, endPlacementButton)
        
        captureMomentButton.setLinearGradientBackgroundColorElse(colorOne: Colors.colorPrimary, colorTwo: Colors.colorPrimaryDark, frame: CGRect(x: 0, y: 0, width: bounds.width, height: 55))
        endPlacementButton.setLinearGradientBackgroundColorElse(colorOne: Colors.colorGoogleRedTwo, colorTwo: Colors.colorGoogleRedOne, frame: CGRect(x: 0, y: 0, width: bounds.width, height: 55))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

