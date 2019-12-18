//
//  UserTabContentViewCell.swift
//  ting
//
//  Created by Christian Scott on 12/17/19.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit

class UserTabContentViewCell : UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    let cellId = "cellId"
    
    lazy var userTabLayout : UserTabLayoutView  = {
        let view = UserTabLayoutView()
        view.userTabContentView = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var userViewPager: UICollectionView = {
        let layout =  UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = Colors.colorWhite
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    func setup(){
        addSubview(userTabLayout)
        addSubview(userViewPager)
        
        userViewPager.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        userViewPager.isPagingEnabled = true
        
        if let flowLayout = userViewPager.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: userTabLayout)
        addConstraintsWithFormat(format: "V:|[v0(50)]", views: userTabLayout)
        
        addConstraintsWithFormat(format: "V:|-50-[v0]|", views: userViewPager)
        addConstraintsWithFormat(format: "H:|[v0]|", views: userViewPager)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        userTabLayout.selectorTabViewLeftAnchor?.constant = scrollView.contentOffset.x / 3
    }
    
    func scrollToMenuAtIndex(menuIndex: Int){
        let indexPath = IndexPath(item: menuIndex, section: 0)
        userViewPager.scrollToItem(at: indexPath, at: .left, animated: true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        userTabLayout.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

