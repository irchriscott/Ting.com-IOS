//
//  UserTabLayoutView.swift
//  ting
//
//  Created by Ir Christian Scott on 22/08/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit

class UserTabLayoutView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    let cellId = "cellId"
    let tabTitles = ["MOMENTS", "RESTAURANT", "PROFILE"]
    var selectorTabViewLeftAnchor: NSLayoutConstraint?
    
    var userTabContentView: UserTabContentViewCell?
    
    lazy var collectionView : UICollectionView = {
        let layout =  UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = Colors.colorWhite
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TabBarLayoutItemViewCell
        cell.tabTitle.text = tabTitles[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 3, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        userTabContentView?.scrollToMenuAtIndex(menuIndex: indexPath.item)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Colors.colorWhite
        self.setup()
    }
    
    func setup(){
        addSubview(collectionView)
        
        collectionView.register(TabBarLayoutItemViewCell.self, forCellWithReuseIdentifier: cellId)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
        collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .top)
        
        let selectorTabView = UIView()
        selectorTabView.backgroundColor = Colors.colorPrimary
        selectorTabView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(selectorTabView)
        
        selectorTabViewLeftAnchor = selectorTabView.leftAnchor.constraint(equalTo: self.leftAnchor)
        
        selectorTabViewLeftAnchor?.isActive = true
        selectorTabView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        selectorTabView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3).isActive = true
        selectorTabView.heightAnchor.constraint(equalToConstant: 3).isActive = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class UserTabLayoutViewCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    let cellId = "cellId"
    let tabTitles = ["MOMENTS", "RESTAURANT", "PROFILE"]
    var selectorTabViewLeftAnchor: NSLayoutConstraint?
    
    var userTabContentView: UserTabContentViewCell?
    
    lazy var collectionView : UICollectionView = {
        let layout =  UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = Colors.colorWhite
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TabBarLayoutItemViewCell
        cell.tabTitle.text = tabTitles[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 3, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        userTabContentView?.scrollToMenuAtIndex(menuIndex: indexPath.item)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Colors.colorWhite
        self.setup()
    }
    
    func setup(){
        addSubview(collectionView)
        
        collectionView.register(TabBarLayoutItemViewCell.self, forCellWithReuseIdentifier: cellId)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
        collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .top)
        
        let selectorTabView = UIView()
        selectorTabView.backgroundColor = Colors.colorPrimary
        selectorTabView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(selectorTabView)
        
        selectorTabViewLeftAnchor = selectorTabView.leftAnchor.constraint(equalTo: self.leftAnchor)
        
        selectorTabViewLeftAnchor?.isActive = true
        selectorTabView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        selectorTabView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3).isActive = true
        selectorTabView.heightAnchor.constraint(equalToConstant: 3).isActive = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TabBarLayoutItemViewCell : UICollectionViewCell {
    
    let tabTitle: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-Medium", size: 16)
        view.textColor = Colors.colorPrimary
        return view
    }()
    
    override var isHighlighted: Bool {
        didSet {}
    }
    
    override var isSelected: Bool {
        didSet {}
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    func setup(){
        addSubview(tabTitle)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: tabTitle)
        addConstraintsWithFormat(format: "V:[v0(30)]", views: tabTitle)
        addConstraint(NSLayoutConstraint(item: tabTitle, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: tabTitle, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
