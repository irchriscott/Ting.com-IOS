//
//  InlineIconTextView.swift
//  ting
//
//  Created by Christian Scott on 20/09/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit

class InlineIconTextView: UIView {
    
    public enum Size : Int32 {
        case small
        case medium
        case large
    }
    
    var imageSize: CGFloat = 18
    var textSize: CGFloat = 15
    
    open var text: String = "Hello World" {
        didSet { self.setup() }
    }
    
    open var icon: UIImage? = UIImage(named: "default_user") {
        didSet { self.setup() }
    }
    
    open var size: InlineIconTextView.Size = .medium {
        didSet {
            switch self.size {
            case .small:
                self.imageSize = 14
                self.textSize = 13
            case .medium:
                self.imageSize = 18
                self.textSize = 15
            case .large:
                self.imageSize = 24
                self.textSize = 17
            }
            self.setup()
        }
    }
    
    let iconView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = CGRect(x: 0, y: 0, width: 14, height: 14)
        view.image = UIImage(named: "icon_address_black")
        view.alpha = 0.5
        return view
    }()
    
    let textView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-Regular", size: 13)
        view.textColor = Colors.colorGray
        view.text = "Nana Hostel, Kampala, Uganda"
        view.numberOfLines = 2
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private func setup(){
        addSubview(iconView)
        addSubview(textView)
        
        iconView.image = self.icon
        textView.text = self.text
        textView.font = UIFont(name: "Poppins-Regular", size: self.textSize)
        
        addConstraintsWithFormat(format: "H:|[v0(\(imageSize))]-4-[v1]|", views: iconView, textView)
        addConstraintsWithFormat(format: "V:|[v0(\(imageSize))]", views: iconView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: textView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
