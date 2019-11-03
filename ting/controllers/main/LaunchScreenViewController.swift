//
//  LaunchScreenViewController.swift
//  ting
//
//  Created by Ir Christian Scott on 06/08/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserAuthentication().isUserLoggedIn() {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
            let appDelegate = UIApplication.shared.delegate! as! AppDelegate
            let homeDiscoverViewController = storyBoard.instantiateViewController(withIdentifier: "HomeTabBar")
            appDelegate.window?.rootViewController = homeDiscoverViewController
            appDelegate.window?.makeKeyAndVisible()
        } else {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = storyBoard.instantiateInitialViewController() as! LoginViewController
            self.present(loginViewController, animated: true, completion: nil)
        }
    }

}
