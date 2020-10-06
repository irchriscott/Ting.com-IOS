//
//  MenuOrdersViewController.swift
//  ting
//
//  Created by Christian Scott on 06/10/2020.
//  Copyright © 2020 Ir Christian Scott. All rights reserved.
//

import UIKit
import ShimmerSwift


class MenuOrdersViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UITextViewDelegate {

    private let cellId = "cellId"
    private let headerId = "headerId"
    private let footerId = "footerId"
    
    private let shimmerCellId = "shimmerCellId"
    private let emptyCellId = "emptyCellId"
    
    var spinnerViewHeight: CGFloat = 0
    var orders: [Order] = []
    
    let placement = PlacementProvider().get()!
    
    var type: Int? {
        didSet {}
    }
    
    var onClose: (() -> Void)!
    var onOrder: ((RestaurantMenu) -> Void)!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(OrderViewCell.self, forCellWithReuseIdentifier: self.cellId)
        
        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: self.headerId)
        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: self.footerId)
        
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.shimmerCellId)
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.emptyCellId)
        
        self.getPlacementOrders(index: pageIndex, q: query)
    }
    
    var pageIndex = 1
    var shouldLoad = true
    var hasLoaded = false
    
    var query = ""
    
    private func getPlacementOrders(index: Int, q: String){
        APIDataProvider.instance.getPlacementOrderMenus(token: self.placement.token, page: index, query: q, completion: { (ms) in
            DispatchQueue.main.async {
                self.hasLoaded = true
                if !ms.isEmpty {
                    self.orders.append(contentsOf: ms)
                    self.spinnerViewHeight = 0
                    self.collectionView.reloadData()
                } else {
                    self.spinnerViewHeight = 0
                    self.shouldLoad = false
                }
                
                if self.orders.isEmpty {
                    self.collectionView.reloadData()
                }
            }
        })
    }

    var loadedMenus:[Int] = []
    
    lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.placeholder = "Filter Orders"
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
            return !self.orders.isEmpty ? self.orders.count : 1
        } else { return 3 }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.pageIndex = 1
        self.loadedMenus = []
        self.orders = []
        if searchText == "" {
            self.getPlacementOrders(index: pageIndex, q: searchText)
        }
     }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.getPlacementOrders(index: pageIndex, q: searchBar.text ?? "")
        self.view.endEditing(true)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.hasLoaded {
            if !self.orders.isEmpty {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! OrderViewCell
                if !self.loadedMenus.contains(indexPath.row) {
                    let order = self.orders[indexPath.row]
                    cell.order = order
                    self.loadedMenus.append(indexPath.row)
                    cell.onReorder = {
                            
                        let alert = UIAlertController(title: "Re-Order Menu", message: nil, preferredStyle: .alert)

                        let widthConstraints = alert.view.constraints.filter({ return $0.firstAttribute == .width })
                        alert.view.removeConstraints(widthConstraints)
                        let newWidth = UIScreen.main.bounds.width * 0.90
                        let widthConstraint = NSLayoutConstraint(item: alert.view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: newWidth)
                        alert.view.addConstraint(widthConstraint)
                            
                        let firstContainer = alert.view.subviews[0]
                        let constraint = firstContainer.constraints.filter({ return $0.firstAttribute == .width && $0.secondItem == nil })
                            firstContainer.removeConstraints(constraint)
                            alert.view.addConstraint(NSLayoutConstraint(item: firstContainer, attribute: .width, relatedBy: .equal, toItem: alert.view, attribute: .width, multiplier: 1.0, constant: 0))
                            
                        let innerBackground = firstContainer.subviews[0]
                        let innerConstraints = innerBackground.constraints.filter({ return $0.firstAttribute == .width && $0.secondItem == nil })
                        innerBackground.removeConstraints(innerConstraints)
                        firstContainer.addConstraint(NSLayoutConstraint(item: innerBackground, attribute: .width, relatedBy: .equal, toItem: firstContainer, attribute: .width, multiplier: 1.0, constant: 0))
                        
                        let height = NSLayoutConstraint(item: alert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 260)
                        alert.view.addConstraint(height)
                            
                        alert.addTextField { (textField) in
                            textField.placeholder = "Enter Quantity"
                            textField.keyboardType = .numberPad
                            textField.font = UIFont(name: "Poppins-Regular", size: 15)
                            textField.returnKeyType = .next
                            textField.textColor = Colors.colorGray
                            textField.textRect(forBounds: textField.bounds.inset(by: UIEdgeInsets(top: 8, left: 6, bottom: 8, right: 6)))
                            textField.placeholderRect(forBounds: textField.bounds.inset(by: UIEdgeInsets(top: 8, left: 6, bottom: 8, right: 6)))
                                textField.editingRect(forBounds: textField.bounds.inset(by: UIEdgeInsets(top: 8, left: 6, bottom: 8, right: 6)))
                            textField.layer.cornerRadius = 4
                            textField.layer.masksToBounds = true
                                
                            textField.attributedPlaceholder = NSAttributedString(string: "Enter Quantity", attributes: [
                                    NSAttributedString.Key.foregroundColor: Colors.colorLightGray,
                                    NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 15)!
                            ])
                            textField.addTarget(self, action: #selector(self.doneEditing), for: UIControl.Event.primaryActionTriggered)
                        }
                            
                        let conditionsTextView = UITextView()
                        conditionsTextView.isEditable = true
                        conditionsTextView.text = "Enter Conditions"
                        conditionsTextView.textColor = Colors.colorLightGray
                        conditionsTextView.font = UIFont(name: "Poppins-Regular", size: 12)!
                        conditionsTextView.backgroundColor = Colors.colorWhite
                        conditionsTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 6, right: 10)
                        conditionsTextView.frame = CGRect(x: 16, y: 105, width: newWidth - 30, height: 100)
                        conditionsTextView.layer.cornerRadius = 4
                        conditionsTextView.layer.masksToBounds = true
                        conditionsTextView.delegate = self
                        conditionsTextView.returnKeyType = .done
                            
                        alert.view.addSubview(conditionsTextView)
                            
                        let action = UIAlertAction(title: "OK", style: .default) { _ in
                            let quantityText = alert.textFields![0]
                            let quantity = quantityText.text != "" && !quantityText.text!.isEmpty && !quantityText.text!.isNil ? quantityText.text! : "1"
                            let conditions = conditionsTextView.text != "Enter Conditions" ? conditionsTextView.text! : ""
                                
                            let params: Parameters = ["token": self.placement.token, "quantity": quantity, "conditions": conditions, "menu": "\(order.menu.id!)"]
                                
                            TingClient.postRequest(url: URLs.placeOrderMenu, params: params) { (data) in
                                DispatchQueue.main.async {
                                    if let data = data {
                                        do {
                                            let response = try JSONDecoder().decode(ServerResponse.self, from: data)
                                            let style: Toast.Style = response.type == "success" ? .success : .error
                                            Toast.makeToast(message: response.message, duration: Toast.MID_LENGTH_DURATION, style: style)
                                        } catch {
                                            self.showErrorMessage(message: "An error has occurred. Sorry!")
                                        }
                                    }
                                }
                            }
                        }
                            
                        let cancel = UIAlertAction(title: "CANCEL", style: .destructive) { (alertAction) in
                            alert.dismiss(animated: true, completion: nil)
                        }
                            
                        alert.addAction(cancel)
                        alert.addAction(action)
                            
                        self.present(alert, animated: true, completion: nil)
                    }
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
                    view.text = "No Orders To Show"
                    view.font = UIFont(name: "Poppins-SemiBold", size: 23)
                    view.textColor = Colors.colorVeryLightGray
                    view.textAlignment = .center
                    return view
                }()
                    
                let emptyTextRect = NSString(string: "No Orders To Show").boundingRect(with: CGSize(width: cell.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: 23)!], context: nil)
                    
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
        
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == Colors.colorLightGray {
            textView.text = ""
            textView.textColor = Colors.colorGray
        }
    }
        
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter Conditions"
            textView.textColor = Colors.colorLightGray
        }
        textView.resignFirstResponder()
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headerId, for: indexPath)
            
            let titleView: UILabel = {
                let view = UILabel()
                view.translatesAutoresizingMaskIntoConstraints = false
                view.font = UIFont(name: "Poppins-SemiBold", size: 17)
                view.textColor = Colors.colorDarkGray
                view.text = "Orders".uppercased()
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
        let emptyTextRect = NSString(string: "No Orders To Show").boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: 23)!], context: nil)
        if self.hasLoaded {
            return !self.orders.isEmpty ? CGSize(width: self.view.frame.width, height: self.orderMenuCellHeight(index: indexPath.row)) : CGSize(width: view.frame.width, height: 30 + 90 + 12 + emptyTextRect.height + 30)
        } else { return CGSize(width: view.frame.width, height: 94 + 12) }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 95)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.spinnerViewHeight)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.orders.count - 1 {
            if self.shouldLoad {
                pageIndex += 1
                self.spinnerViewHeight = 40
                getPlacementOrders(index: pageIndex, q: query)
            }
        }
    }
    
    @IBAction func cancel(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func doneEditing(){
        self.view.endEditing(true)
    }
    
    private func orderMenuCellHeight(index: Int) -> CGFloat {
        
        let order = self.orders[index]
        
        var menuNameHeight: CGFloat = 20
        let device = UIDevice.type
        
        var menuNameTextSize: CGFloat = 15
        var menuImageConstant: CGFloat = 80
        
        var promotionReductionHeight: CGFloat = 0
        var promotionSupplementHeight: CGFloat = 0
        
        if UIDevice.smallDevices.contains(device) {
            menuImageConstant = 55
            menuNameTextSize = 14
        } else if UIDevice.mediumDevices.contains(device) {
            menuImageConstant = 70
            menuNameTextSize = 15
        }
        
        let frameWidth = self.view.frame.width - (60 + menuImageConstant)
        
        let menuNameRect = NSString(string: (order.menu.menu?.name)!).boundingRect(with: CGSize(width: frameWidth, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: menuNameTextSize)!], context: nil)
        
        menuNameHeight = menuNameRect.height
        
        if order.hasPromotion {
            if let promotion = order.promotion {
                if let supplement = promotion.supplement {
                    let promotionSupplementRect = NSString(string: supplement).boundingRect(with: CGSize(width: frameWidth, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 13)!], context: nil)
                    promotionSupplementHeight = promotionSupplementRect.height
                }
                
                if let reduction = promotion.reduction {
                    let promotionReductionRect = NSString(string: reduction).boundingRect(with: CGSize(width: frameWidth, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 13)!], context: nil)
                    promotionReductionHeight = promotionReductionRect.height
                }
            }
        }
        
        var staticValue: CGFloat = 2 + 4 + 15 + 8 + 16 + 30 + 16 + 4 + 1 + 26 + 24
        
        if !order.isAccepted && !order.isDeclined {
            staticValue += 63
        } else {
            if order.isDeclined {
                staticValue += 63
            }
        }
        
        if order.hasPromotion {
            staticValue += promotionReductionHeight + promotionSupplementHeight + 50
        }
        
        return 24 + staticValue + menuNameHeight + 10
    }
}
