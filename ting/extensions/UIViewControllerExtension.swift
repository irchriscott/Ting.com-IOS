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
var closeMessageCallBack: (() -> Void)?

let overlayView: UIView = {
    let view =  UIView()
    view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    return view
}()

extension UIViewController {
    
    func showSpinner(onView: UIView){
        let spinnerView = UIView(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
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
    
    func showErrorMessage(message: String, title: String = "Error"){
        DispatchQueue.main.async {
            let alertDialog = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alertDialog.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertDialog, animated: true, completion: nil)
        }
    }
    
    func showSuccessMessage(successOverlayView: UIView, image: UIImageView, label: UILabel, message: String) {
        successOverlayView.bounds.size.width = self.view.bounds.width
        successOverlayView.bounds.size.height = self.view.bounds.height
        successOverlayView.center = self.view.center
        successOverlayView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        successOverlayView.alpha = 0.0
    
        DispatchQueue.main.async {
            self.view.addSubview(successOverlayView)
            UIView.animate(withDuration: 1.5, animations: {
                successOverlayView.alpha = 1.0
                label.text = message
                UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
                    image.transform = CGAffineTransform(translationX: 0, y: -40)
                    image.transform = CGAffineTransform(rotationAngle: -180)
                }, completion: { (success) in
                    UIView.animate(withDuration: 0.5, animations: {
                        image.transform = CGAffineTransform(translationX: 0, y: 0)
                        image.transform = CGAffineTransform(rotationAngle: 0)
                    }, completion: {(success) in
                        sleep(3)
                        successOverlayView.removeFromSuperview()
                    })
                })
            })
        }
    }
    
    func showAlertMessage(image: String, message: String, onClick: @escaping () -> ()) {
        
        closeMessageCallBack = onClick
        
        let contentView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = Colors.colorTransparent
            return view
        }()
        
        let imageView: UIImageView = {
            let view = UIImageView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.image = UIImage(named: image)
            return view
        }()
        
        let labelView: UILabel = {
            let view = UILabel()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.text = message
            view.font = UIFont(name: "Poppins-SemiBold", size: 20)
            view.textColor = Colors.colorWhite
            view.textAlignment = .center
            return view
        }()
        
        contentView.addSubview(imageView)
        contentView.addSubview(labelView)
        
        contentView.addConstraintsWithFormat(format: "H:[v0(60)]", views: imageView)
        contentView.addConstraintsWithFormat(format: "H:|[v0]|", views: labelView)
        contentView.addConstraintsWithFormat(format: "V:[v0(60)]-12-[v1(30)]", views: imageView, labelView)
        
        contentView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0))
        
        overlayView.addSubview(contentView)
        overlayView.addConstraintsWithFormat(format: "H:|[v0]|", views: contentView)
        overlayView.addConstraintsWithFormat(format: "V:[v0]", views: contentView)
        
        overlayView.addConstraint(NSLayoutConstraint(item: contentView, attribute: .centerX, relatedBy: .equal, toItem: overlayView, attribute: .centerX, multiplier: 1, constant: 0))
        overlayView.addConstraint(NSLayoutConstraint(item: contentView, attribute: .centerY, relatedBy: .equal, toItem: overlayView, attribute: .centerY, multiplier: 1, constant: 0))
        
        overlayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeMessageAlert)))
        
        if let window = UIApplication.shared.keyWindow {
            overlayView.frame.size.width = window.frame.width
            overlayView.frame.size.height = window.frame.height
            overlayView.center = window.center
            overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            overlayView.alpha = 0.0
            
            DispatchQueue.main.async {
                window.addSubview(overlayView)
                UIView.animate(withDuration: 1.5, animations: {
                    overlayView.alpha = 1.0
                    UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
                        imageView.transform = CGAffineTransform(translationX: 0, y: -40)
                        imageView.transform = CGAffineTransform(rotationAngle: -180)
                    }, completion: { (success) in
                        UIView.animate(withDuration: 0.5, animations: {
                            imageView.transform = CGAffineTransform(translationX: 0, y: 0)
                            imageView.transform = CGAffineTransform(rotationAngle: 0)
                        }, completion: nil)
                    })
                })
            }
        }
    }
    
    @objc private func closeMessageAlert() {
        overlayView.removeFromSuperview()
        closeMessageCallBack!()
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
