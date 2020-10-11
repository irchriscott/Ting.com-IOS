//
//  PlacementViewController.swift
//  ting
//
//  Created by Christian Scott on 29/09/2020.
//  Copyright © 2020 Ir Christian Scott. All rights reserved.
//

import UIKit
import PubNub
import BLTNBoard

class PlacementViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextViewDelegate {
    
    let headerId = "headerId"
    let footerId = "footerId"
    let cellId = "cellId"
    
    var placement: Placement? {
        didSet {
            if let placement = self.placement {
                if placement.isDone {
                    self.showAlertMessage(image: "icon_important_75_white", message: "Placement Terminated") {
                        PlacementProvider().placeOut()
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
                self.collectionView.reloadSections(IndexSet(integer: 0))
            }
        }
    }
    
    let appWindow = UIApplication.shared.keyWindow
    
    let session = UserAuthentication().get()!
    
    var pubnub: PubNub!
    let listener = SubscriptionListener(queue: .main)
    
    let colors: [UIColor] = [Colors.colorPlacementMenuOne, Colors.colorPlacementMenuTwo, Colors.colorPlacementMenuThree, Colors.colorPlacementMenuFour, Colors.colorPlacementMenuFive, Colors.colorPlacementMenuSix]
    
    private var menus: [[String]] = [
        ["Foods", "icon_p_menu_foods"],
        ["Drinks", "icon_p_menu_drinks"],
        ["Dishes", "icon_p_menu_dishes"],
        ["Orders", "icon_p_menu_orders"],
        ["Bill", "icon_p_menu_bill"],
        ["Request Waiter", "icon_p_menu_request"]
    ]
        
    let spinner = Spinner()
    
    var loadedData:[Bool] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        
        self.loadedData = [Bool](repeating: false, count: self.menus.count)
        
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.cellId)
        self.collectionView.register(PlacementHeaderViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: self.headerId)
        self.collectionView.register(PlacementFooterViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: self.footerId)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_info_25_white"), style: .plain, target: self, action: #selector(restaurantAbout(sender:)))
        
        if let place = PlacementProvider().get() {
            self.placement = place
        }
        
        PubNub.log.levels = [.all]
        PubNub.log.writers = [ConsoleLogWriter(), FileLogWriter()]

        let config = PubNubConfiguration(publishKey: "pub-c-62f722d6-c307-4dd9-89dc-e598a9164424", subscribeKey: "sub-c-6597d23e-1b1d-11ea-b79a-866798696d74")
        pubnub = PubNub(configuration: config)
        
        let channels = [session.channel]
        
        listener.didReceiveMessage = { message in
            do {
                let response = try JSONDecoder().decode(SocketResponseMessage.self, from: message.payload.jsonStringify!.data(using: .utf8)!)
                self.spinner.hide()
                switch response.type {
                case Socket.SOCKET_RESPONSE_ERROR:
                    if let m = response.message {
                        self.showErrorMessage(message: m, title: "Sorry")
                    } else { self.showErrorMessage(message: "An error has occurred. Try again", title: "Sorry") }
                case Socket.SOCKET_RESPONSE_TABLE_WAITER:
                    break
                case Socket.SOCKET_RESPONSE_PLACEMENT_DONE:
                    PlacementProvider().placeOut()
                    self.showAlertMessage(image: "icon_important_75_white", message: "Placement Terminated") {
                        PlacementProvider().placeOut()
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                case Socket.SOCKET_RESPONSE_RESTO_BILL_PAID:
                    let page = BLTNPageItem(title: "Bill Marked As Paid")
                    page.image = UIImage(named: "icon_info_75_primary")

                    page.descriptionText = "You can now terminate your placement. Bill Paid"
                    page.actionButtonTitle = "OK"
                    page.alternativeButtonTitle = "Cancel"
                    
                    page.appearance.actionButtonColor = Colors.colorPrimary
                    page.appearance.alternativeButtonTitleColor = Colors.colorPrimary
                    page.appearance.actionButtonTitleColor = .white
                    page.appearance.actionButtonCornerRadius = 4
                    page.appearance.descriptionFontSize = 14
                    page.appearance.descriptionTextColor = Colors.colorGray
                    page.appearance.descriptionFontDescriptor = UIFontDescriptor(name: "Poppins-Regular", size: 14)
                    page.appearance.titleFontDescriptor = UIFontDescriptor(name: "Poppins-SemiBold", size: 20)
                    page.appearance.titleTextColor = Colors.colorGray
                    
                    page.isDismissable = true
                    page.requiresCloseButton = false
                    
                    page.actionButton?.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 15)
                    page.alternativeButton?.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 15)
                    
                    let manager = BLTNItemManager(rootItem: page)
                    manager.backgroundViewStyle = .dimmed
                    manager.showBulletin(in: UIApplication.shared)
                    manager.cardCornerRadius = 12
                    
                    page.actionHandler = { item in
                        manager.dismissBulletin(animated: true)
                    }
                    
                    page.alternativeHandler = { item in
                        manager.dismissBulletin(animated: true)
                    }
                default:
                    self.showErrorMessage(message: "No Response. Try again", title: "Humm ?")
                }
            } catch {
                self.spinner.hide()
                self.showErrorMessage(message: "An error has occurred. Try again", title: "Ouch")
            }
        }
        
        listener.didReceiveStatus = { status in
            switch status {
            case .success(let connection):
                if connection == .connected {}
            case .failure(let _):
                break
            }
        }
        
        pubnub.add(listener)
        pubnub.subscribe(to: channels, withPresence: true)
        
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
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 0 : self.menus.count
     }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath)
        cell.backgroundColor = colors[indexPath.item]
        cell.layer.cornerRadius = 4
        
        let menu = self.menus[indexPath.item]
        
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
        
        if !self.loadedData[indexPath.item] {
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
            
            self.loadedData[indexPath.item] = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headerId, for: indexPath) as! PlacementHeaderViewCell
            header.placement = self.placement
            header.controller = self
            return header
        default:
            let footer =  collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.footerId, for: indexPath) as! PlacementFooterViewCell
            footer.endPlacementButton.addTarget(self, action: #selector(endPlacement(sender:)), for: .touchUpInside)
            return footer
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0, 1, 2:
            self.openOrderMenus(type: indexPath.row + 1)
        case 3:
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let ordersController = storyboard.instantiateViewController(withIdentifier: "MenuOrdersView") as! MenuOrdersViewController
            ordersController.controller = self
            self.present(ordersController, animated: true, completion: nil)
        case 4:
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let billController = storyboard.instantiateViewController(withIdentifier: "PlacementBill") as! PlacementBillViewController
            billController.controller = self
            self.present(billController, animated: true, completion: nil)
        case 5:
            self.sendRequestWaiter()
        default:
            break
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
        return section == 0 ? CGSize(width: self.view.frame.width, height: 268) : .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return section == 0 ? .zero : CGSize(width: self.view.frame.width, height: 146)
    }
    
    @objc func restaurantAbout(sender: UIBarButtonItem) {
        if let branch = self.placement?.table.branch {
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let aboutController = storyboard.instantiateViewController(withIdentifier: "RestaurantAbout") as! RestaurantAboutController
            aboutController.branch = branch
            self.navigationController?.pushViewController(aboutController, animated: true)
        }
    }
    
    private func openOrderMenus(type: Int) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let orderMenusController = storyboard.instantiateViewController(withIdentifier: "OrderMenusView") as! OrderMenusViewController
        orderMenusController.type = type
        orderMenusController.onClose = { self.getPlacement() }
        orderMenusController.onOrder = { menu in self.getPlacement() }
        self.present(orderMenusController, animated: true, completion: nil)
    }
    
    public func requestWaiter() {
        if let placement = self.placement {
            let receiver = SocketUser(id: placement.table.branch?.id, type: 1, name: "\(placement.table.branch?.restaurant?.name ?? ""), \(placement.table.branch?.name ?? "")", email: placement.table.branch?.email, image: placement.table.branch?.restaurant?.logo, channel: (placement.table.branch?.channel)!)
            
            let args:[String:String] = ["table": "\(placement.table.id)", "token": PlacementProvider().getTempToken()!]
            let data:[String:String] = ["table": placement.table.number]
            
            let message = SocketResponseMessage(uuid: UUID().uuidString, type: Socket.SOCKET_REQUEST_ASSIGN_WAITER, sender: UserAuthentication().socketUser(), receiver: receiver, status: 200, message: "", args: args, data: data)
            
            let messageJSON = try! JSONEncoder().encodeJSONObject(message)
            
            let jsonData = try! JSONSerialization.data(withJSONObject: messageJSON, options: [])
            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)!.replacingOccurrences(of: "\"", with: "'")
            
            self.pubnub.publish(channel: placement.table.branch!.channel, message: jsonString) { (result) in
                switch result {
                case .success(_):
                    Toast.makeToast(message: "Request Sent", duration: Toast.MID_LENGTH_DURATION, style: .success)
                case let .failure(error):
                    self.showErrorMessage(message: "An error has occured : \(error.localizedDescription). Try again", title: "Sorry")
                }
            }
        }
    }
    
    public func updatePeople() {
        let alert = UIAlertController(title: "How many are you ?", message: nil, preferredStyle: .alert)

        let action = UIAlertAction(title: "OK", style: .default) { _ in
            let peopleText = alert.textFields![0]
            if let people = peopleText.text {
                if !people.isEmpty {
                    self.spinner.show()
                    let params: Parameters = ["token": self.placement!.token, "people": people]
                    TingClient.postRequest(url: URLs.updatePlacementPeople, params: params) { (data) in
                        DispatchQueue.main.async {
                            if let data = data {
                                self.spinner.hide()
                                do {
                                    let placement = try JSONDecoder().decode(Placement.self, from: data)
                                    self.placement = placement
                                    PlacementProvider().set(data: data)
                                    PlacementProvider().setToken(data: placement.token)
                                } catch {
                                    self.showErrorMessage(message: error.localizedDescription)
                                    do {
                                        let response = try JSONDecoder().decode(ServerResponse.self, from: data)
                                        self.showErrorMessage(message: response.message)
                                    } catch {
                                        self.showErrorMessage(message: error.localizedDescription)
                                    }
                                }
                            } else {
                                self.showErrorMessage(message: "Sorry, an error has occurred")
                            }
                        }
                    }
                } else {
                    self.showErrorMessage(message: "Please, insert number of people")
                }
            } else {
                self.showErrorMessage(message: "Please, insert number of people")
            }
        }
        let cancel = UIAlertAction(title: "CANCEL", style: .destructive) { (alertAction) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Number of People"
            textField.keyboardType = .numberPad
            textField.textAlignment = .center
            textField.font = UIFont(name: "Poppins-Medium", size: 40)
            textField.returnKeyType = .done
            textField.textColor = Colors.colorGray
            textField.text = "\(self.placement!.people)"
            textField.attributedPlaceholder = NSAttributedString(string: "Number of People", attributes: [
                NSAttributedString.Key.foregroundColor: Colors.colorGray,
                NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 14)!
            ])
            textField.addTarget(self, action: #selector(self.doneEditing), for: UIControl.Event.primaryActionTriggered)
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func sendRequestWaiter() {
        if let placement = self.placement {
            let alert = UIAlertController(title: "Request Waiter", message: nil, preferredStyle: .alert)

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
            
            let height = NSLayoutConstraint(item: alert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 230)
            alert.view.addConstraint(height)
                
            let messageTextView = UITextView()
            messageTextView.isEditable = true
            messageTextView.text = "Enter Message"
            messageTextView.textColor = Colors.colorLightGray
            messageTextView.font = UIFont(name: "Poppins-Regular", size: 12)!
            messageTextView.backgroundColor = Colors.colorWhite
            messageTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 6, right: 10)
            messageTextView.frame = CGRect(x: 16, y: 55, width: newWidth - 30, height: 120)
            messageTextView.layer.cornerRadius = 4
            messageTextView.layer.masksToBounds = true
            messageTextView.delegate = self
            messageTextView.returnKeyType = .done
                
            alert.view.addSubview(messageTextView)
                
            let action = UIAlertAction(title: "OK", style: .default) { _ in
                
                let message = messageTextView.text != "Enter Message" ? messageTextView.text! : ""
                if message != "" && !message.isEmpty {
                    let params: Parameters = ["token": placement.token, "message": message]
                    let url = URLs.placementRequestWaiter
                    TingClient.postRequest(url: url, params: params) { (data) in
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
                } else {
                    Toast.makeToast(message: "Message cannot be empty", duration: Toast.MID_LENGTH_DURATION, style: .error)
                }
            }
                
            let cancel = UIAlertAction(title: "CANCEL", style: .destructive) { (alertAction) in
                alert.dismiss(animated: true, completion: nil)
            }
                
            alert.addAction(action)
            alert.addAction(cancel)
                
            self.present(alert, animated: true, completion: nil)
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
            textView.text = "Enter Message"
            textView.textColor = Colors.colorLightGray
        }
        textView.resignFirstResponder()
    }
    
    @IBAction func endPlacement(sender: UIButton) {
        let page = BLTNPageItem(title: "End Placement")
        page.image = UIImage(named: "icon_important_100_orange")

        page.descriptionText = "Do you really want to end this placement ?"
        page.actionButtonTitle = "Yes"
        page.alternativeButtonTitle = "Cancel"
        
        page.appearance.actionButtonColor = Colors.colorPrimary
        page.appearance.alternativeButtonTitleColor = Colors.colorPrimary
        page.appearance.actionButtonTitleColor = .white
        page.appearance.actionButtonCornerRadius = 4
        page.appearance.descriptionFontSize = 14
        page.appearance.descriptionTextColor = Colors.colorGray
        page.appearance.descriptionFontDescriptor = UIFontDescriptor(name: "Poppins-Regular", size: 14)
        page.appearance.titleFontDescriptor = UIFontDescriptor(name: "Poppins-SemiBold", size: 20)
        page.appearance.titleTextColor = Colors.colorGray
        
        page.isDismissable = false
        page.requiresCloseButton = false
        
        page.actionButton?.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 15)
        page.alternativeButton?.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 15)
        
        let manager = BLTNItemManager(rootItem: page)
        manager.backgroundViewStyle = .dimmed
        manager.showBulletin(in: UIApplication.shared)
        manager.cardCornerRadius = 12
        
        page.actionHandler = { item in
            manager.displayActivityIndicator()
            TingClient.getRequest(url: "\(URLs.placementTerminate)?token=\(self.placement!.token)") { (data) in
                DispatchQueue.main.async {
                    if let data = data {
                        manager.dismissBulletin(animated: true)
                        do {
                            let response = try JSONDecoder().decode(ServerResponse.self, from: data)
                            if response.type == "success" {
                                self.showAlertMessage(image: "icon_important_75_white", message: "Placement Terminated") {
                                    PlacementProvider().placeOut()
                                    self.navigationController?.popToRootViewController(animated: true)
                                }
                            } else {
                                self.showErrorMessage(message: response.message)
                            }
                        } catch {
                            self.showErrorMessage(message: error.localizedDescription)
                        }
                    } else {
                        self.showErrorMessage(message: "Sorry, an error has occurred")
                    }
                }
            }
        }
        
        page.alternativeHandler = { item in
            manager.dismissBulletin(animated: true)
        }
    }
    
    @objc func doneEditing(){
        self.view.endEditing(true)
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
    
    let tableNumber: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-Regular", size: 15.0)
        view.textColor = Colors.colorVeryLightGray
        view.text = "Table No"
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
    
    var controller: PlacementViewController?
    
    var placement: Placement? {
        didSet {
            if let placement = self.placement {
                restaurantName.textColor  = Colors.colorGray
                restaurantName.backgroundColor = .white
                
                tableNumber.textColor = Colors.colorGray
                tableNumber.backgroundColor = .white
                
                billNumber.textColor = Colors.colorGray
                billNumber.backgroundColor = .white
                
                waiterView.textColor = Colors.colorGray
                peopleView.textColor = Colors.colorGray
                
                restaurantName.text = "\((placement.table.branch?.restaurant?.name)!), \((placement.table.branch?.name)!)"
                tableNumber.text = "Table No \(placement.table.number)"
                
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
                } else { waiterView.text = "Request Waiter" }
                
                peopleView.text = String(placement.people)
            }
            self.setup()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.waiterView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(requestWaiter)))
        self.peopleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(updatePeople)))
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
        addSubview(tableNumber)
        addSubview(billNumber)
        addSubview(dataView)
        
        addConstraintsWithFormat(format: "H:[v0(100)]", views: restaurantImage)
        addConstraintsWithFormat(format: "H:|[v0]|", views: restaurantName)
        addConstraintsWithFormat(format: "H:|[v0]|", views: tableNumber)
        addConstraintsWithFormat(format: "H:|[v0]|", views: billNumber)
        addConstraintsWithFormat(format: "H:[v0]", views: dataView)
        
        addConstraintsWithFormat(format: "V:|-16-[v0(100)]-8-[v1(24)]-[v2(18)]-[v3(30)]-12-[v4(26)]", views: restaurantImage, restaurantName, tableNumber, billNumber, dataView)
        
        addConstraint(NSLayoutConstraint.init(item: restaurantImage, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint.init(item: restaurantName, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint.init(item: tableNumber, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint.init(item: billNumber, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint.init(item: dataView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
    }
    
    @objc private func requestWaiter() {
        if let place = self.placement {
            if let waiter = place.waiter {
                let alert = UIAlertController(title: waiter.name, message: "This is the waiter who will be serving you today. Enjoy !", preferredStyle: .alert)
                
                let imageView = UIImageView()
                imageView.layer.cornerRadius = 4
                imageView.layer.masksToBounds = true
                imageView.contentMode = .scaleAspectFill
                imageView.translatesAutoresizingMaskIntoConstraints = false
                
                imageView.kf.setImage(
                    with: URL(string: "\(URLs.hostEndPoint)\(waiter.image)")!,
                    placeholder: UIImage(named: "default_user"),
                    options: [
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(1)),
                        .cacheOriginalImage
                    ]
                )

                alert.view.addSubview(imageView)
                alert.view.addConstraintsWithFormat(format: "V:|-90-[v0(100)]", views: imageView)
                alert.view.addConstraintsWithFormat(format: "H:[v0(100)]", views: imageView)
                alert.view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: alert.view, attribute: .centerX, multiplier: 1, constant: 0))
                
                let height = NSLayoutConstraint(item: alert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
                alert.view.addConstraint(height)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                self.controller?.present(alert, animated: true, completion: nil)
            } else {
                let request = UIAlertController(title: "Request Waiter For Your Table", message: nil, preferredStyle: .actionSheet)
                request.addAction(UIAlertAction(title: "Request Waiter", style: .default) { (action) in
                    self.controller?.requestWaiter()
                })
                request.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { (action) in }))
                controller?.present(request, animated: true, completion: nil)
            }
        }
    }
    
    @objc func updatePeople() {
        controller?.updatePeople()
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

