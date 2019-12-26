//
//  UIViewControllerExtension.swift
//  ting
//
//  Created by Ir Christian Scott on 01/08/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import Foundation
import UIKit

var vSpinner: UIView?

extension UIViewController {
    
    func showSpinner(onView: UIView){
        let spinnerView = UIView(frame: onView.bounds)
        spinnerView.backgroundColor = Colors.colorTransparent
        let ai = UIActivityIndicatorView(style: .white)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner(){
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
    
    func showViewAnimateLeftToRight(fromView: UIView, toView: UIView, scrollView: UIScrollView){
        toView.frame.size.width = self.view.frame.width - 24
        toView.center = self.view.center
        scrollView.addSubview(toView)
        toView.transform = CGAffineTransform(translationX: self.view.frame.size.width, y: 0)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            fromView.alpha = 0.0
        }, completion: { (finished) in
            toView.transform = CGAffineTransform(translationX: 0, y: 0)
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
                toView.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: { (finished) in
                fromView.removeFromSuperview()
            })
        })
    }
    
    func showErrorMessage(message: String){
        DispatchQueue.main.async {
            let alertDialog = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
            alertDialog.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertDialog, animated: true, completion: nil)
        }
    }
    
    func showSuccessMessage(successOverlayView: UIView, image: UIImageView, label: UILabel, message: String) {
        successOverlayView.bounds.size.width = self.view.bounds.width
        successOverlayView.bounds.size.height = self.view.bounds.height
        successOverlayView.center = self.view.center
        successOverlayView.backgroundColor = Colors.colorTransparent
        successOverlayView.alpha = 0.0
    
        DispatchQueue.main.async {
            self.view.addSubview(successOverlayView)
            UIView.animate(withDuration: 2.5, animations: {
                successOverlayView.alpha = 1.0
                label.text = message
                UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
                    image.transform = CGAffineTransform(translationX: 0, y: -40)
                    image.transform = CGAffineTransform(rotationAngle: -180)
                }, completion: { (success) in
                    UIView.animate(withDuration: 0.5, animations: {
                        image.transform = CGAffineTransform(translationX: 0, y: 0)
                        image.transform = CGAffineTransform(rotationAngle: 0)
                    }, completion: {(success) in
                        sleep(2)
                        successOverlayView.removeFromSuperview()
                    })
                })
            })
        }
    }
    
    func topMostViewController() -> UIViewController {
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController!.topMostViewController()
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController!.topMostViewController()
    }
}
