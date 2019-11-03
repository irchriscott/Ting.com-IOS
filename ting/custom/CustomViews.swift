//
//  CustomViews.swift
//  ting
//
//  Created by Christian Scott on 25/08/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit

class UICircularButtomImageView: UIView {
    
    var image: UIImage = UIImage(named: "icon_edit_25_gray")!
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Colors.colorDarkTransparent
        layer.cornerRadius = 20
        layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        
        imageView.image = self.image
        addSubview(imageView)
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class UIEditUserRowView: UIView {
    
    public enum InputType : Int32 {
        case text
        case number
        case dropdown
        case date
        case password
    }
    
    let label: SmallTitleTextLabel = {
        let view = SmallTitleTextLabel()
        return view
    }()
    
    let input: InputTextFieldElse = {
        let view = InputTextFieldElse()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-Regular", size: 13)
        return view
    }()
    
    let button: UICircularButtomImageView = {
        let view = UICircularButtomImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "icon_edit_25_gray")!
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setup(hasButton: Bool, isEditable: Bool, title: String, value: String, controller: EditUserCollectionViewController?, type: InputType, data: [String]){
        
        label.text = title
        input.isEnabled = isEditable
        input.textColor = isEditable ? Colors.colorGray : Colors.colorLightGray
        input.text = value
        input.isSecureTextEntry = type == InputType.password ? true : false
        
        addSubview(label)
        addSubview(input)
        
        addConstraint(NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: input, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        addConstraintsWithFormat(format: "V:[v0(40)]", views: input)
        
        if hasButton {
            button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            addSubview(button)
            addConstraintsWithFormat(format: "V:[v0(40)]", views: button)
            addConstraint(NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
            addConstraintsWithFormat(format: "H:|[v0(100)]-8-[v1]-8-[v2(40)]|", views: label, input, button)
        } else {
            addConstraintsWithFormat(format: "H:|[v0(100)]-8-[v1]|", views: label, input)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
