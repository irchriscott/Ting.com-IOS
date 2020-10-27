//
//  HomeViewController.swift
//  ting
//
//  Created by Ir Christian Scott on 06/08/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit
import UserNotifications
import Reachability
import SwiftToast

class HomeViewController: UITabBarController, UITabBarControllerDelegate {
    
    let reachability = Reachability()
    
    let successToast =  SwiftToast(
        text: "Connected",
        textAlignment: .center,
        backgroundColor: .green,
        textColor: .white,
        font: UIFont(name: "Poppins-Regular", size: 12.0),
        duration: 3.0,
        statusBarStyle: .lightContent,
        aboveStatusBar: true,
        target: nil,
        style: .statusBar
    )
    
    var isConnected: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.removeLabels()
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability?.startNotifier()
        } catch { }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 3 {}
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if tabBarController.selectedIndex == 3 { return true }
        return true
    }
    
    @objc func reachabilityChanged(note: Notification) {

        let reachability = note.object as! Reachability

        switch reachability.connection {
        case .wifi:
            if !self.isConnected {
                self.present(self.successToast, animated: true)
            }
        case .cellular:
            if !self.isConnected {
                self.present(self.successToast, animated: true)
            }
        case .none:
            let toast =  SwiftToast(
                                text: "Tryng to connect to internet...",
                                textAlignment: .center,
                                backgroundColor: .red,
                                textColor: .white,
                                font: UIFont(name: "Poppins-Regular", size: 12.0),
                                duration: 120.0,
                                statusBarStyle: .lightContent,
                                aboveStatusBar: true,
                                target: nil,
                                style: .statusBar)
            self.present(toast, animated: true)
            
            self.isConnected = false
        }
    }
}
