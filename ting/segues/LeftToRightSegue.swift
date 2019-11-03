//
//  LeftToRightSegue.swift
//  ting
//
//  Created by Ir Christian Scott on 02/08/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit

class LeftToRightSegue: UIStoryboardSegue {
    
    override func perform() {
        let source = self.source as UIViewController
        let destination = self.destination as UIViewController
        
        source.view.superview?.insertSubview(destination.view, aboveSubview: source.view)
        destination.view.transform = CGAffineTransform(translationX: source.view.frame.size.width, y: 0)
        
        UIView.animate(withDuration: 0.50, delay: 0.0, options: .curveEaseInOut, animations: {
            destination.view.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: { (finished) in
            source.present(destination, animated: false, completion: nil)
        })
    }
}

class UnwindLeftToRightSegue: UIStoryboardSegue {
    
    override func perform() {
        let source = self.source as UIViewController
        let destination = self.destination as UIViewController
        
        source.view.superview?.insertSubview(destination.view, aboveSubview: source.view)
        destination.view.transform = CGAffineTransform(translationX: 0, y: 0)
        
        UIView.animate(withDuration: 0.50, delay: 0.0, options: .curveEaseInOut, animations: {
            source.view.transform = CGAffineTransform(translationX: source.view.frame.size.width, y: 0)
        }) { (finished) in
            source.dismiss(animated: false, completion: nil)
        }
    }
}
