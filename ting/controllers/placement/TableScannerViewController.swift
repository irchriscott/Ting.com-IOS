//
//  TableScannerViewController.swift
//  ting
//
//  Created by Christian Scott on 21/08/2020.
//  Copyright © 2020 Ir Christian Scott. All rights reserved.
//

import UIKit
import MercariQRScanner

class TableScannerViewController: UIViewController, QRScannerViewDelegate {
    
    var controller: UINavigationController?
    private var qrScannerView: QRScannerView!
    
    var flashButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let closeButtonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        view.backgroundColor = UIColor(red: 0.56, green: 0.55, blue: 0.93, alpha: 0.5)
        return view
    }()
    
    let closeImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        view.image = UIImage(named: "icon_close_bold_25_white")
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.closeButtonView.layer.cornerRadius = self.closeButtonView.frame.width / 2
        self.closeButtonView.layer.masksToBounds = true
        
        self.view.addSubview(closeButtonView)
        
        self.view.addConstraintsWithFormat(format: "V:|-40-[v0(30)]", views: closeButtonView)
        self.view.addConstraintsWithFormat(format: "H:|-12-[v0(30)]", views: closeButtonView)
        
        self.closeImageView.image = UIImage(named: "icon_close_bold_25_white")
        self.closeButtonView.addSubview(closeImageView)
        
        self.closeButtonView.addConstraintsWithFormat(format: "H:[v0(20)]", views: closeImageView)
        self.closeButtonView.addConstraintsWithFormat(format: "V:[v0(20)]", views: closeImageView)
        
        self.closeButtonView.addConstraint(NSLayoutConstraint(item: closeImageView, attribute: .centerX, relatedBy: .equal, toItem: closeButtonView, attribute: .centerX, multiplier: 1, constant: 0))
        self.closeButtonView.addConstraint(NSLayoutConstraint(item: closeImageView, attribute: .centerY, relatedBy: .equal, toItem: closeButtonView, attribute: .centerY, multiplier: 1, constant: 0))
        
        flashButton.setImage(UIImage(named: "icon_flash_on_25_white"), for: .selected)
        flashButton.setImage(UIImage(named: "icon_flash_off_25_white"), for: .normal)
        
        qrScannerView = QRScannerView(frame: self.view.bounds)
        self.view.addSubview(qrScannerView)
        qrScannerView.configure(delegate: self, input: .init(isBlurEffectEnabled: true))
        qrScannerView.startRunning()
        
        self.view.addSubview(flashButton)
        
        self.view.addConstraintsWithFormat(format: "V:|-40-[v0(30)]", views: flashButton)
        self.view.addConstraintsWithFormat(format: "H:[v0(30)]-12-|", views: flashButton)
        
        flashButton.addTarget(self, action: #selector(tapFlashButton(_:)), for: .touchUpInside)
        closeButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeScanner)))
        
        self.view.bringSubviewToFront(closeButtonView)
        self.view.bringSubviewToFront(flashButton)
    }
    
    func qrScannerView(_ qrScannerView: QRScannerView, didFailure error: QRScannerError) {
        self.showErrorMessage(message: error.localizedDescription)
    }

    func qrScannerView(_ qrScannerView: QRScannerView, didSuccess code: String) {
        print(code)
    }
    
    func qrScannerView(_ qrScannerView: QRScannerView, didChangeTorchActive isOn: Bool) {
        flashButton.isSelected = isOn
    }
    
    @IBAction func tapFlashButton(_ sender: UIButton) {
        qrScannerView.setTorchActive(isOn: !sender.isSelected)
    }
    
    @objc private func closeScanner() {
        qrScannerView.stopRunning()
        self.dismiss(animated: true, completion: nil)
    }
}
