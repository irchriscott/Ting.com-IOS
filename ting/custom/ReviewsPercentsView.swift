//
//  ReviewsPercentsView.swift
//  ting
//
//  Created by Christian Scott on 11/13/19.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit
import Charts

class ReviewsPercentsView: UIView {

    private let mainLayer: CALayer = CALayer()
    private let scrollView: UIScrollView = UIScrollView()
    
    let space: CGFloat = 4.0
    let barHeight: CGFloat = 6.0
    let contentSpace: CGFloat = 30.0
    
    var width: CGFloat? {
        didSet {}
    }
    
    var dataEntries: [BarChartEntry] = [] {
        didSet {
            mainLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
            scrollView.frame = CGRect(x: 0, y: 0, width: width!, height: barHeight + space * CGFloat(5) + contentSpace)
            scrollView.contentSize = CGSize(width: width!, height: barHeight + space * CGFloat(5) + contentSpace)
            mainLayer.frame = CGRect(x: 0, y: 0, width: width! - 24, height: barHeight + space * CGFloat(5) + contentSpace)
            for i in 0..<dataEntries.count {
                showEntry(index: i, entry: dataEntries[i])
            }
            setupView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        scrollView.layer.addSublayer(mainLayer)
        addSubview(scrollView)
    }
    
    private func showEntry(index: Int, entry: BarChartEntry) {
        let xPos: CGFloat = translateWidthValueToXPosition(value: Float(entry.score) / Float(100.0))
        let yPos: CGFloat = space + CGFloat(index) * (barHeight + space)
        drawBar(xPos: xPos, yPos: yPos)
        drawTextValue(xPos: xPos + 155.0, yPos: yPos + 4.0, textValue: "\(entry.score)")
        drawTitle(xPos: 0.0, yPos: yPos - 3.0, width: 20.0, height: 15.0, title: entry.title)
    }
    
    private func drawBar(xPos: CGFloat, yPos: CGFloat) {
        let barLayer = CALayer()
        if xPos > 0 {
            barLayer.backgroundColor = Colors.colorPrimaryDark.cgColor
            barLayer.frame = CGRect(x: 26.0, y: yPos, width: xPos, height: 6.0)
        } else {
            barLayer.backgroundColor = Colors.colorVeryLightGray.cgColor
            barLayer.frame = CGRect(x: 26.0, y: yPos, width: mainLayer.frame.width - space, height: 6.0)
        }
        barLayer.cornerRadius = 3.0
        barLayer.masksToBounds = true
        mainLayer.addSublayer(barLayer)
    }
    
    private func drawTextValue(xPos: CGFloat, yPos: CGFloat, textValue: String) {
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: xPos, y: yPos, width: 33, height: 80.0)
        textLayer.foregroundColor = UIColor.black.cgColor
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.font = UIFont(name: "Poppins-Regular", size: 9)!
        textLayer.fontSize = 9
        textLayer.string = textValue
    }
    
    private func drawTitle(xPos: CGFloat, yPos: CGFloat, width: CGFloat, height: CGFloat = 15, title: String) {
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: xPos, y: yPos, width: width, height: height)
        textLayer.foregroundColor = Colors.colorGray.cgColor
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.alignmentMode = CATextLayerAlignmentMode.right
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.font = UIFont(name: "Poppins-Regular", size: 9)!
        textLayer.fontSize = 9
        textLayer.string = title
        mainLayer.addSublayer(textLayer)
    }
    
    private func translateWidthValueToXPosition(value: Float) -> CGFloat {
        let width = CGFloat(value) * (mainLayer.frame.width - space)
        return abs(width)
    }

}
