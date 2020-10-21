//
//  CarouselView.swift
//  Delego
//
//  Created by Zachary Khan on 6/8/17.
//  Copyright © 2017 ZacharyKhan. All rights reserved.
//

import UIKit

final public class CarouselView: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private let cellId = "slideCellId"
    
    public var slides : [CarouselSlide] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.pageControl.numberOfPages = self.slides.count
                self.pageControl.size(forNumberOfPages: self.slides.count)
            }
        }
    }
    
    public var rowSize: CGSize = .zero {
        didSet {
            self.frame = CGRect(x: 0, y: 0, width: rowSize.width, height: rowSize.height)
            self.setupCarousel()
            self.collectionView.reloadData()
        }
    }
    
    private lazy var tapGesture : UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler(tap:)))
        return tap
    }()
    
    public lazy var pageControl : UIPageControl = {
        let control = UIPageControl()
        control.currentPage = 0
        control.hidesForSinglePage = true
        control.pageIndicatorTintColor = .lightGray
        control.currentPageIndicatorTintColor = Colors.colorPrimary
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    public lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.isPagingEnabled = true
        cv.register(CarouselCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        cv.clipsToBounds = true
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.bounces = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCarousel()
    }
    
    private func setupCarousel() {
        self.backgroundColor = .clear
        
        self.addSubview(collectionView)

        self.addConstraintsWithFormat(format: "H:|[v0(\(rowSize.width))]|", views: collectionView)
        self.addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
        self.collectionView.addGestureRecognizer(self.tapGesture)
        
        self.addSubview(pageControl)
        NSLayoutConstraint(item: pageControl, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -35).isActive = true
        NSLayoutConstraint(item: pageControl, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -5).isActive = true
        NSLayoutConstraint(item: pageControl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 18).isActive = true
        
        self.bringSubviewToFront(pageControl)
    }
    
    @objc private func tapGestureHandler(tap: UITapGestureRecognizer?) {
        var visibleRect = CGRect()
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath: IndexPath = collectionView.indexPathForItem(at: visiblePoint) ?? IndexPath(item: 0, section: 0)
        let index = visibleIndexPath.item

        if index == (slides.count-1) {
            let indexPathToShow = IndexPath(item: 0, section: 0)
            self.collectionView.selectItem(at: indexPathToShow, animated: true, scrollPosition: .centeredHorizontally)
        } else {
            let indexPathToShow = IndexPath(item: (index + 1), section: 0)
            self.collectionView.selectItem(at: indexPathToShow, animated: true, scrollPosition: .centeredHorizontally)
        }
    }
    
    private var timer : Timer = Timer()
    public var interval : Double?
    
    public func start() {
        timer = Timer.scheduledTimer(timeInterval: interval ?? 1.0, target: self, selector: #selector(tapGestureHandler(tap:)), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    public func stop() {
        timer.invalidate()
    }
    
    public func disableTap() {
        // This function is provided in case you want to remove the default gesture and provide your own. The default gesture changes the slides on tap.
        collectionView.removeGestureRecognizer(tapGesture)
    }
    
    public func selectedIndexPath() -> IndexPath? {
        var visibleRect = CGRect()
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        return collectionView.indexPathForItem(at: visiblePoint)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CarouselCollectionViewCell
        cell.slide = self.slides[indexPath.item]
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.slides.count
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: self.rowSize.width, height: collectionView.frame.height)
        return size
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.slides[indexPath.item].onSlideClick!(indexPath.item)
    }
}

fileprivate class CarouselCollectionViewCell: UICollectionViewCell {
    
    fileprivate var slide : CarouselSlide? {
        didSet {
            guard let slide = slide else {
                print("ZKCarousel could not parse the slide you provided. \n\(String(describing: self.slide))")
                return
            }
            self.parseData(forSlide: slide)
        }
    }
    
    private lazy var imageView : UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.layer.cornerRadius = 4.0
        view.layer.masksToBounds = true
        view.addBlackGradientLayerTop(frame: self.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var promotionTitleView : UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "Poppins-SemiBold", size: 19)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private var promotionTypeView : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Medium", size: 14)
        label.textColor = .white
        label.numberOfLines = 1
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let promotionReductionView: InlineIconTextView = {
        let view = InlineIconTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.icon = UIImage(named: "icon_promo_minus_white")!
        view.size = .small
        view.text = "Reduction"
        view.textColor = .white
        return view
    }()
    
    let promotionSupplementView: InlineIconTextView = {
        let view = InlineIconTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.icon = UIImage(named: "icon_promo_plus_white")!
        view.size = .small
        view.text = "Supplement"
        view.textColor = .white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.backgroundColor = .white
        self.clipsToBounds = true
        
        self.addSubview(self.imageView)
        self.addConstraintsWithFormat(format: "H:|[v0]-24-|", views: imageView)
        self.addConstraintsWithFormat(format: "V:|[v0]|", views: imageView)
        
        self.addSubview(self.promotionTitleView)
        self.addSubview(self.separatorView)
        self.addSubview(self.promotionTypeView)
        
        self.addConstraintsWithFormat(format: "H:|-12-[v0]", views: promotionTitleView)
        self.addConstraintsWithFormat(format: "H:|-12-[v0]-60-|", views: separatorView)
        self.addConstraintsWithFormat(format: "H:|-12-[v0]", views: promotionTypeView)
        
        self.addConstraintsWithFormat(format: "V:|-12-[v0]-8-[v1(0.5)]-8-[v2]", views: promotionTitleView, separatorView, promotionTypeView)
    }
    
    private func parseData(forSlide slide: CarouselSlide) {
        if let promotion = slide.slidePromotion {
            imageView.kf.setImage(
                with: URL(string: "\(URLs.hostEndPoint)\(promotion.posterImage)")!,
                placeholder: UIImage(named: "default_restaurant"),
                options: [
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ]
            )
            
            promotionTitleView.text = promotion.occasionEvent
            promotionTypeView.text = promotion.promotionItem.type.name
        
            if promotion.promotionItem.category != nil && promotion.promotionItem.type.id == "05" {
                promotionTypeView.text = (promotion.promotionItem.category?.name)!
            }
            
            if promotion.promotionItem.menu != nil && promotion.promotionItem.type.id == "04" {
                if let menu = promotion.promotionItem.menu {
                    promotionTypeView.text = (menu.menu?.name)!
                }
            }
            
            var promotionReductionHeight: CGFloat = 0
            var promotionSupplementHeight: CGFloat = 0
            
            if promotion.reduction.hasReduction {
                let reductionText = "Order this menu and get \(promotion.reduction.amount) \((promotion.reduction.reductionType)!) reduction"
                promotionReductionView.text = reductionText
                let promotionReductionRect = NSString(string: reductionText).boundingRect(with: CGSize(width: frame.width - 60, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 13)!], context: nil)
                promotionReductionHeight = promotionReductionRect.height
                addSubview(promotionReductionView)
            }
            
            if promotion.supplement.hasSupplement {
                var supplementText: String!
                if !promotion.supplement.isSame {
                    supplementText = "Order \(promotion.supplement.minQuantity) of this menu and get \(promotion.supplement.quantity) free \((promotion.supplement.supplement?.menu?.name)!)"
                } else {
                    supplementText = "Order \(promotion.supplement.minQuantity) of this menu and get \(promotion.supplement.quantity) more for free"
                }
                promotionSupplementView.text = supplementText
                let promotionSupplementRect = NSString(string: supplementText).boundingRect(with: CGSize(width: frame.width - 60, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 13)!], context: nil)
                promotionSupplementHeight = promotionSupplementRect.height
                addSubview(promotionSupplementView)
            }
            
            if promotion.supplement.hasSupplement && promotion.reduction.hasReduction {
                addConstraintsWithFormat(format: "H:|-12-[v0]", views: promotionReductionView)
                addConstraintsWithFormat(format: "H:|-12-[v0]", views: promotionSupplementView)
                addConstraintsWithFormat(format: "V:|-78-[v0(\(promotionReductionHeight))]-6-[v1(\(promotionSupplementHeight))]", views: promotionReductionView, promotionSupplementView)
            } else if promotion.supplement.hasSupplement && !promotion.reduction.hasReduction {
                addConstraintsWithFormat(format: "H:|-12-[v0]", views: promotionSupplementView)
                addConstraintsWithFormat(format: "V:|-84-[v0(\(promotionSupplementHeight))]", views: promotionSupplementView)
            } else if !promotion.supplement.hasSupplement && promotion.reduction.hasReduction {
                addConstraintsWithFormat(format: "H:|-12-[v0]", views: promotionReductionView)
                addConstraintsWithFormat(format: "V:|-12-[v0(\(promotionReductionHeight))]", views: promotionReductionView)
            }
        }
        return
    }
}

final public class CarouselSlide : NSObject {
    
    var slidePromotion : MenuPromotion?
    var onSlideClick: ((Int) -> Void)?
    
    init(promotion: MenuPromotion, onClick: @escaping (Int) -> Void) {
        slidePromotion = promotion
        onSlideClick = onClick
    }
    
    override init() {
        super.init()
    }
}
