//
//  Toast.swift
//  ting
//
//  Created by Ir Christian Scott on 06/08/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import Foundation
import UIKit

class Toast : NSObject {
    
    static let LONG_LENGTH_DURATION: Int = 6
    static let MID_LENGTH_DURATION: Int = 4
    static let SHORT_LENGTH_DURATION: Int = 2
    
    override init() {
        super.init()
    }
    
    public enum Style : Int32 {
        case `default`
        case success
        case warning
        case error
    }
    
    static public func makeToast(message: String, duration: Int, style: Toast.Style){
        
        if let window =  UIApplication.shared.keyWindow {
            let toastView = UIView()
            let height: CGFloat = 40.0
            let y = window.frame.height - (height + 25)
            
            let textFrameMaxWidth = window.frame.width - (59 + 30)
            let frameWidth = message.size(font: UIFont(name: "Poppins-Regular", size: 13.0)!, width: textFrameMaxWidth)
            
            let x = (window.frame.width - (frameWidth.width + 59)) / 2
            
            toastView.frame = CGRect(x: x, y: window.frame.height, width: frameWidth.width + 59, height: height)
            var toastIcon: UIImage?
            
            switch style {
            case .default:
                toastView.backgroundColor = Colors.colorToastDefault
                toastIcon = UIImage(data: NSData(base64Encoded: Base64ImageData.default, options: NSData.Base64DecodingOptions(rawValue: 0))! as Data)!
                break
            case .success:
                toastView.backgroundColor = Colors.colorToastSuccess
                toastIcon = UIImage(data: NSData(base64Encoded: Base64ImageData.success, options: NSData.Base64DecodingOptions(rawValue: 0))! as Data)!
                break
            case .warning:
                toastView.backgroundColor = Colors.colorToastWarning
                toastIcon = UIImage(data: NSData(base64Encoded: Base64ImageData.warning, options: NSData.Base64DecodingOptions(rawValue: 0))! as Data)!
                break
            case .error:
                toastView.backgroundColor = Colors.colorToastError
                toastIcon = UIImage(data: NSData(base64Encoded: Base64ImageData.error, options: NSData.Base64DecodingOptions(rawValue: 0))! as Data)!
                break
            }
            
            toastView.layer.cornerRadius = 4.0
            
            let messageLabel = UILabel()
            messageLabel.frame = CGRect(x: 45, y: 0, width: toastView.frame.width - 59, height: 40)
            messageLabel.textColor = Colors.colorGray
            messageLabel.text = message
            messageLabel.font = UIFont(name: "Poppins-Regular", size: 13.0)
            
            let toastIconView = UIImageView()
            toastIconView.frame = CGRect(x: 15, y: 10, width: 20, height: 20)
            toastIconView.image = toastIcon
            toastIconView.alpha = 0.5
            
            toastView.insertSubview(messageLabel, at: 1)
            toastView.insertSubview(toastIconView, at: 0)
            window.addSubview(toastView)
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                toastView.center = window.center
                toastView.frame = CGRect(x: x, y: y, width: toastView.frame.width, height: toastView.frame.height)
            }, completion: {(success) in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                   UIView.animate(withDuration: 0.3) {
                        toastView.frame = CGRect(x: x, y: window.frame.height, width: toastView.frame.width, height: toastView.frame.height)
                   }
                }
            })
        }
    }
}
