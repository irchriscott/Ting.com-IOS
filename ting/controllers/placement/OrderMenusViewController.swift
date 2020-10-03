//
//  OrderMenusViewController.swift
//  ting
//
//  Created by Christian Scott on 03/10/2020.
//  Copyright © 2020 Ir Christian Scott. All rights reserved.
//

import UIKit
import ShimmerSwift
import FittedSheets

class OrderMenusViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    private let cellId = "cellId"
    private let headerId = "headerId"
    private let footerId = "footerId"
    
    private let shimmerCellId = "shimmerCellId"
    private let emptyCellId = "emptyCellId"
    
    var spinnerViewHeight: CGFloat = 0
    var menus: [RestaurantMenu] = []
    
    let placement = PlacementProvider().get()!
    
    var type: Int? {
        didSet {}
    }
    
    var onClose: (() -> Void)!
    var onOrder: ((RestaurantMenu) -> Void)!
    
    let titles = ["Foods", "Drinks", "Dishes"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(RestaurantMenuOrderViewCell.self, forCellWithReuseIdentifier: self.cellId)
        
        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: self.headerId)
        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: self.footerId)
        
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.shimmerCellId)
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.emptyCellId)
        
        self.getOrderRestaurantMenus(index: pageIndex, q: query)
    }
    
    var pageIndex = 1
    var shouldLoad = true
    var hasLoaded = false
    
    var query = ""
        
    private func getOrderRestaurantMenus(index: Int, q: String){
        APIDataProvider.instance.getRestaurantOrderMenus(branch: self.placement.table.branch!.id, type: self.type!, page: index, query: q, completion: { (ms) in
            DispatchQueue.main.async {
                self.hasLoaded = true
                if !ms.isEmpty {
                    self.menus.append(contentsOf: ms)
                    self.spinnerViewHeight = 0
                    self.collectionView.reloadData()
                } else {
                    self.spinnerViewHeight = 0
                    self.shouldLoad = false
                }
                
                if self.menus.isEmpty {
                    self.collectionView.reloadData()
                }
            }
        })
    }
    
    var loadedMenus:[Int] = []
    
    lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.placeholder = "Filter \(self.titles[self.type! - 1])"
        view.searchTextPositionAdjustment = UIOffset(horizontal: 8, vertical: 0)
        view.setPositionAdjustment(UIOffset(horizontal: 8, vertical: 0), for: .search)
        view.barStyle = .blackTranslucent
        view.isTranslucent = false
        view.searchBarStyle = .minimal
        view.layer.cornerRadius = 4
        if #available(iOS 13.0, *) {
            view.searchTextField.font = UIFont(name: "Poppins-Light", size: 14)
        } else {
            let searchTextField = view.value(forKey: "searchField") as? UITextField
            searchTextField?.font = UIFont(name: "Poppins-Light", size: 14)
        }
        view.delegate = self
        return view
    }()

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.hasLoaded {
            return !self.menus.isEmpty ? self.menus.count : 1
        } else { return 3 }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.pageIndex = 1
        self.loadedMenus = []
        self.menus = []
        if searchText == "" {
            self.getOrderRestaurantMenus(index: pageIndex, q: searchText)
        }
     }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.getOrderRestaurantMenus(index: pageIndex, q: searchBar.text ?? "")
        self.view.endEditing(true)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if self.hasLoaded {
            if !self.menus.isEmpty {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! RestaurantMenuOrderViewCell
                if !self.loadedMenus.contains(indexPath.row) {
                    cell.restaurantMenu = self.menus[indexPath.row]
                    self.loadedMenus.append(indexPath.row)
                }
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.emptyCellId, for: indexPath)
                
                let cellView: UIView = {
                    let view = UIView()
                    view.translatesAutoresizingMaskIntoConstraints = false
                    return view
                }()
                
                let emptyImageView: UIImageView = {
                    let view = UIImageView()
                    view.translatesAutoresizingMaskIntoConstraints = false
                    view.image = UIImage(named: "icon_spoon_100_gray")!
                    view.contentMode = .scaleAspectFill
                    view.clipsToBounds = true
                    view.alpha = 0.2
                    return view
                }()
                
                let emptyTextView: UILabel = {
                    let view = UILabel()
                    view.translatesAutoresizingMaskIntoConstraints = false
                    view.text = "No Menu To Show"
                    view.font = UIFont(name: "Poppins-SemiBold", size: 23)
                    view.textColor = Colors.colorVeryLightGray
                    view.textAlignment = .center
                    return view
                }()
                
                let emptyTextRect = NSString(string: "No Menu To Show").boundingRect(with: CGSize(width: cell.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: 23)!], context: nil)
                
                cellView.addSubview(emptyImageView)
                cellView.addSubview(emptyTextView)
                
                cellView.addConstraintsWithFormat(format: "H:[v0(90)]", views: emptyImageView)
                cellView.addConstraintsWithFormat(format: "H:|[v0]|", views: emptyTextView)
                cellView.addConstraintsWithFormat(format: "V:|[v0(90)]-6-[v1(\(emptyTextRect.height))]|", views: emptyImageView, emptyTextView)
                
                cellView.addConstraint(NSLayoutConstraint(item: cellView, attribute: .centerX, relatedBy: .equal, toItem: emptyImageView, attribute: .centerX, multiplier: 1, constant: 0))
                cellView.addConstraint(NSLayoutConstraint(item: cellView, attribute: .centerX, relatedBy: .equal, toItem: emptyTextView, attribute: .centerX, multiplier: 1, constant: 0))
                
                cell.addSubview(cellView)
                cell.addConstraintsWithFormat(format: "H:[v0]", views: cellView)
                cell.addConstraintsWithFormat(format: "V:|-30-[v0(\(90 + 12 + emptyTextRect.height))]-30-|", views: cellView)
                
                cell.addConstraint(NSLayoutConstraint(item: cell, attribute: .centerX, relatedBy: .equal, toItem: cellView, attribute: .centerX, multiplier: 1, constant: 0))
                cell.addConstraint(NSLayoutConstraint(item: cell, attribute: .centerY, relatedBy: .equal, toItem: cellView, attribute: .centerY, multiplier: 1, constant: 0))
                
                return cell
            }
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.shimmerCellId, for: indexPath)
            
            let view: RowShimmerView = {
                let view = RowShimmerView()
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            
            cell.addSubview(view)
            cell.addConstraintsWithFormat(format: "V:|[v0]-12-|", views: view)
            cell.addConstraintsWithFormat(format: "H:|[v0]|", views: view)
            
            let shimmerView = ShimmeringView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 94))
            cell.addSubview(shimmerView)
            
            shimmerView.contentView = view
            shimmerView.shimmerAnimationOpacity = 0.4
            shimmerView.shimmerSpeed = 250
            shimmerView.isShimmering = true
            
            return cell
        }
    }
        
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headerId, for: indexPath)
            
            let titleView: UILabel = {
                let view = UILabel()
                view.translatesAutoresizingMaskIntoConstraints = false
                view.font = UIFont(name: "Poppins-SemiBold", size: 17)
                view.textColor = Colors.colorDarkGray
                view.text = self.titles[self.type! - 1].uppercased()
                return view
            }()
            
            let dismissButton: UIButton = {
                let view = UIButton()
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            
            dismissButton.setTitle("Cancel".uppercased(), for: .normal)
            dismissButton.setTitleColor(.systemBlue, for: .normal)
            dismissButton.titleLabel?.font = UIFont(name: "Poppins-Light", size: 16)
            
            dismissButton.addTarget(self, action: #selector(cancel(sender:)), for: .touchUpInside)
            
            cell.addSubview(titleView)
            cell.addSubview(dismissButton)
            cell.addSubview(searchBar)
            
            cell.addConstraintsWithFormat(format: "H:|-12-[v0]", views: titleView)
            cell.addConstraintsWithFormat(format: "H:[v0]-12-|", views: dismissButton)
            cell.addConstraintsWithFormat(format: "H:|-2-[v0]-2-|", views: searchBar)
            
            cell.addConstraintsWithFormat(format: "V:|-12-[v0(30)]-6-[v1(35)]-12-|", views: titleView, searchBar)
            cell.addConstraintsWithFormat(format: "V:|-12-[v0(30)]", views: dismissButton)
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.footerId, for: indexPath)

            let indicatorView: UIActivityIndicatorView = {
                let view = UIActivityIndicatorView(style: .gray)
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            
            indicatorView.startAnimating()
            cell.addSubview(indicatorView)
            cell.addConstraintsWithFormat(format: "V:|[v0]|", views: indicatorView)
            cell.addConstraintsWithFormat(format: "H:|[v0]|", views: indicatorView)
            cell.addConstraint(NSLayoutConstraint(item: indicatorView, attribute: .centerY, relatedBy: .equal, toItem: cell, attribute: .centerY, multiplier: 1, constant: 0))
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let emptyTextRect = NSString(string: "No Menu To Show").boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: 23)!], context: nil)
        if self.hasLoaded {
            return !self.menus.isEmpty ? CGSize(width: self.view.frame.width, height: self.restaurantMenuCellHeight(index: indexPath.row)) : CGSize(width: view.frame.width, height: 30 + 90 + 12 + emptyTextRect.height + 30)
        } else { return CGSize(width: view.frame.width, height: 94 + 12) }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 95)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.spinnerViewHeight)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.menus.count - 1 {
            if self.shouldLoad {
                pageIndex += 1
                self.spinnerViewHeight = 40
                getOrderRestaurantMenus(index: pageIndex, q: query)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
        if !self.menus.isEmpty {
            let menu = self.menus[indexPath.item]
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let menuController = storyboard.instantiateViewController(withIdentifier: "RestaurantMenuBottomView") as! BottomSheetMenuControllerView
            menuController.menu = menu
            menuController.controller = self
            let sheetController = SheetViewController(controller: menuController, sizes: [.fixed(415), .fixed(640)])
            sheetController.blurBottomSafeArea = false
            sheetController.adjustForBottomSafeArea = true
            sheetController.topCornersRadius = 8
            sheetController.dismissOnBackgroundTap = true
            sheetController.extendBackgroundBehindHandle = false
            sheetController.willDismiss = {_ in }
            sheetController.didDismiss = {_ in }
            self.present(sheetController, animated: false, completion: nil)
        }
    }
    
    @IBAction func cancel(sender: UIButton) {
        self.onClose()
        self.dismiss(animated: true, completion: nil)
    }
    
    private func restaurantMenuCellHeight(index: Int) -> CGFloat {
        
        let device = UIDevice.type
        
        var menuNameTextSize: CGFloat = 15
        var menuDescriptionTextSize: CGFloat = 13
        var menuImageConstant: CGFloat = 80
        
        let menu = self.menus[index]
        
        let heightConstant: CGFloat = 12 + 25 + 1 + 4 + 4 + 4 + 1 + 8 + 8 + 8 + 8 + 26 + 50 + 12
        
        if UIDevice.smallDevices.contains(device) {
            menuImageConstant = 55
            menuNameTextSize = 14
            menuDescriptionTextSize = 12
        } else if UIDevice.mediumDevices.contains(device) {
            menuImageConstant = 70
            menuNameTextSize = 15
            menuDescriptionTextSize = 12
        }
        
        let frameWidth = view.frame.width - (60 + menuImageConstant)
        
        let menuNameRect = NSString(string: (menu.menu?.name!)!).boundingRect(with: CGSize(width: frameWidth, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: menuNameTextSize)!], context: nil)
        
        let menuDescriptionRect = NSString(string: (menu.menu?.description!)!).boundingRect(with: CGSize(width: frameWidth - 18, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: menuDescriptionTextSize)!], context: nil)
        
        var menuPriceHeight: CGFloat = 16
        
        let priceRect = NSString(string: "UGX 10,000").boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: 27)!], context: nil)
        
        let quantityRect = NSString(string: "2 packs / counts").boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 12)!], context: nil)
        
        let lastPriceRect = NSString(string: "UGX 6,000").boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 12)!], context: nil)
        
        if (menu.menu?.isCountable)! && Double((menu.menu?.price)!) != Double((menu.menu?.lastPrice)!) {
            menuPriceHeight += priceRect.height + quantityRect.height + lastPriceRect.height
        } else if !(menu.menu?.isCountable)! && Double((menu.menu?.price)!) != Double((menu.menu?.lastPrice)!) {
            menuPriceHeight += priceRect.height + lastPriceRect.height + 4
        } else if (menu.menu?.isCountable)! && !(Double((menu.menu?.price)!) != Double((menu.menu?.lastPrice)!)) {
            menuPriceHeight += priceRect.height + quantityRect.height + 4
        } else { menuPriceHeight += priceRect.height + 4 }
        
        return heightConstant + menuNameRect.height + menuDescriptionRect.height + CGFloat(menuPriceHeight)
    }
}
