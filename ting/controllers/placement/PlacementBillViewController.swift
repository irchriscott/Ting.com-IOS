//
//  PlacementBillViewController.swift
//  ting
//
//  Created by Christian Scott on 08/10/2020.
//  Copyright © 2020 Ir Christian Scott. All rights reserved.
//

import UIKit
import SwiftDataTables

class PlacementBillViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, SwiftDataTableDataSource, SwiftDataTableDelegate {
    
    let headerId = "headerId"
    let cellId = "cellId"
    let footerId = "footerId"
    let emptyCellId = "emptyCellId"
    
    var controller: PlacementViewController!
    
    var bill: Bill? {
        didSet {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            if let bill = self.bill {
                if let orders = bill.orders?.orders {
                    for (index, order) in orders.enumerated() {
                        let total = Double(order.quantity) * order.price
                        let hasPromotion = order.hasPromotion ? "YES" : "NO"
                        self.ordersDataSource.append(
                            [
                                DataTableValueType.int(index + 1),
                                DataTableValueType.string(order.menu),
                                DataTableValueType.string("\(order.currency) \(numberFormatter.string(from: NSNumber(value: order.price))!)"),
                                DataTableValueType.int(order.quantity),
                                DataTableValueType.string("\(order.currency) \(numberFormatter.string(from: NSNumber(value: total))!)"),
                                DataTableValueType.string(hasPromotion)
                            ]
                        )
                    }
                }
                
                for (index, extra) in bill.extras.enumerated() {
                    let total = Double(extra.quantity) * extra.price
                    self.extrasDataSource.append(
                        [
                            DataTableValueType.int(index + 1),
                            DataTableValueType.string(extra.name),
                            DataTableValueType.string("\(bill.currency) \(numberFormatter.string(from: NSNumber(value: extra.price))!)"),
                            DataTableValueType.int(extra.quantity),
                            DataTableValueType.string("\(bill.currency) \(numberFormatter.string(from: NSNumber(value: total))!)")
                        ]
                    )
                }
            }
            self.ordersTable.reload()
            self.ordersExtraTable.reload()
            self.collectionView.reloadData()
        }
    }
    
    var ordersDataSource: DataTableContent = []
    var extrasDataSource: DataTableContent = []
    
    let placement = PlacementProvider().get()!
    
    private func getPlacementBill() {
        let url = "\(URLs.placementGetBill)?token=\(placement.token)"
        TingClient.getRequest(url: url) { (data) in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let bill = try JSONDecoder().decode(Bill.self, from: data)
                        self.bill = bill
                    } catch {
                        do {
                            self.bill = nil
                            let response = try JSONDecoder().decode(ServerResponse.self, from: data)
                            Toast.makeToast(message: response.message, duration: Toast.MID_LENGTH_DURATION, style: .error)
                        } catch {
                            self.bill = nil
                            self.showErrorMessage(message: error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    lazy var ordersTable: SwiftDataTable = {
        let view = SwiftDataTable(dataSource: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.backgroundColor = Colors.colorVeryLightGray
        return view
    }()
    
    lazy var ordersExtraTable: SwiftDataTable = {
        let view = SwiftDataTable(dataSource: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.backgroundColor = Colors.colorVeryLightGray
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.cellId)
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.emptyCellId)
        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: self.headerId)
        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: self.footerId)
        
        self.getPlacementBill()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.bill != nil ? 2 : 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let bill = self.bill {
            switch indexPath.row {
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath)
                let titleView: UILabel = {
                    let view = UILabel()
                    view.translatesAutoresizingMaskIntoConstraints = false
                    view.font = UIFont(name: "Poppins-Medium", size: 15)
                    view.textColor = Colors.colorDarkGray
                    view.text = "Orders"
                    return view
                }()
                
                cell.addSubview(titleView)
                cell.addSubview(ordersTable)
                
                cell.addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: titleView)
                cell.addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: ordersTable)
                
                let height: CGFloat = CGFloat(Double(bill.orders!.count) * 44.5)
                cell.addConstraintsWithFormat(format: "V:|[v0(20)]-8-[v1(\(height + 45))]-12-|", views: titleView, ordersTable)
                
                return cell
            case 1:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath)
                let titleView: UILabel = {
                    let view = UILabel()
                    view.translatesAutoresizingMaskIntoConstraints = false
                    view.font = UIFont(name: "Poppins-Medium", size: 15)
                    view.textColor = Colors.colorDarkGray
                    view.text = "Extras"
                    return view
                }()

                cell.addSubview(titleView)
                cell.addSubview(ordersExtraTable)

                cell.addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: titleView)
                cell.addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: ordersExtraTable)

                let height: CGFloat = CGFloat(Double(bill.extras.count) * 44.5)
                cell.addConstraintsWithFormat(format: "V:|[v0(20)]-8-[v1(\(height + 45))]-12-|", views: titleView, ordersExtraTable)

                return cell
            default:
                return collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath)
            }
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.emptyCellId, for: indexPath)
                
            let cellView: UIView = {
                let view = UIView()
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
                
            let emptyImageView: UIImageView = {
                let view = UIImageView()
                view.translatesAutoresizingMaskIntoConstraints = false
                view.image = UIImage(named: "icon_spoon_100_gray")!
                view.contentMode = .scaleAspectFill
                view.clipsToBounds = true
                view.alpha = 0.2
                return view
            }()
                
            let emptyTextView: UILabel = {
                let view = UILabel()
                view.translatesAutoresizingMaskIntoConstraints = false
                view.text = "No Bill To Show"
                view.font = UIFont(name: "Poppins-SemiBold", size: 23)
                view.textColor = Colors.colorVeryLightGray
                view.textAlignment = .center
                return view
            }()
                
            let emptyTextRect = NSString(string: "No Bill To Show").boundingRect(with: CGSize(width: cell.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: 23)!], context: nil)
                
            cellView.addSubview(emptyImageView)
            cellView.addSubview(emptyTextView)
                
            cellView.addConstraintsWithFormat(format: "H:[v0(90)]", views: emptyImageView)
            cellView.addConstraintsWithFormat(format: "H:|[v0]|", views: emptyTextView)
            cellView.addConstraintsWithFormat(format: "V:|[v0(90)]-6-[v1(\(emptyTextRect.height))]|", views: emptyImageView, emptyTextView)
                
            cellView.addConstraint(NSLayoutConstraint(item: cellView, attribute: .centerX, relatedBy: .equal, toItem: emptyImageView, attribute: .centerX, multiplier: 1, constant: 0))
            cellView.addConstraint(NSLayoutConstraint(item: cellView, attribute: .centerX, relatedBy: .equal, toItem: emptyTextView, attribute: .centerX, multiplier: 1, constant: 0))
                
            cell.addSubview(cellView)
            cell.addConstraintsWithFormat(format: "H:[v0]", views: cellView)
            cell.addConstraintsWithFormat(format: "V:|-30-[v0(\(90 + 12 + emptyTextRect.height))]-30-|", views: cellView)
                
            cell.addConstraint(NSLayoutConstraint(item: cell, attribute: .centerX, relatedBy: .equal, toItem: cellView, attribute: .centerX, multiplier: 1, constant: 0))
            cell.addConstraint(NSLayoutConstraint(item: cell, attribute: .centerY, relatedBy: .equal, toItem: cellView, attribute: .centerY, multiplier: 1, constant: 0))
                
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headerId, for: indexPath)
            
            let titleView: UILabel = {
                let view = UILabel()
                view.translatesAutoresizingMaskIntoConstraints = false
                view.font = UIFont(name: "Poppins-SemiBold", size: 17)
                view.textColor = Colors.colorDarkGray
                view.text = "Bill".uppercased()
                return view
            }()
            
            if let bill = self.bill {
                titleView.text = "Bill No \(bill.number)".uppercased()
            }
            
            let dismissButton: UIButton = {
                let view = UIButton()
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            
            dismissButton.setTitle("Cancel".uppercased(), for: .normal)
            dismissButton.setTitleColor(.systemBlue, for: .normal)
            dismissButton.titleLabel?.font = UIFont(name: "Poppins-Light", size: 16)
            
            dismissButton.addTarget(self, action: #selector(cancel(sender:)), for: .touchUpInside)
            
            cell.addSubview(titleView)
            cell.addSubview(dismissButton)
            
            cell.addConstraintsWithFormat(format: "H:|-12-[v0]", views: titleView)
            cell.addConstraintsWithFormat(format: "H:[v0]-12-|", views: dismissButton)
            
            cell.addConstraintsWithFormat(format: "V:|-12-[v0(30)]-12-|", views: titleView)
            cell.addConstraintsWithFormat(format: "V:|-12-[v0(30)]", views: dismissButton)
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.footerId, for: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let emptyTextRect = NSString(string: "No Bill To Show").boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: 23)!], context: nil)
        if let bill = self.bill {
            switch indexPath.row {
            case 0:
                let height: CGFloat = CGFloat(Double(bill.orders!.count) * 44.5)
                return CGSize(width: self.view.frame.width, height: height + 45 + 20 + 12 + 8)
            case 1:
                let height: CGFloat = CGFloat(Double(bill.extras.count) * 44.5)
                return !bill.extras.isEmpty ? CGSize(width: self.view.frame.width, height: height + 45 + 20 + 12 + 8) : .zero
            default:
                return .zero
            }
        } else {
            return CGSize(width: view.frame.width, height: 30 + 90 + 12 + emptyTextRect.height + 30)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 54)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return self.bill != nil ? CGSize(width: self.view.frame.width, height: 300) : .zero
    }
    
    func numberOfColumns(in: SwiftDataTable) -> Int {
        switch `in` {
        case self.ordersTable:
            return 6
        case self.ordersExtraTable:
            return 5
        default:
            return 0
        }
    }
    
    func numberOfRows(in: SwiftDataTable) -> Int {
        switch `in` {
        case self.ordersTable:
            return self.ordersDataSource.count
        case self.ordersExtraTable:
            return self.extrasDataSource.count
        default:
            return 0
        }
    }
    
    func dataTable(_ dataTable: SwiftDataTable, dataForRowAt index: NSInteger) -> [DataTableValueType] {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        switch dataTable {
        case self.ordersTable:
            return self.ordersDataSource[index]
        case self.ordersExtraTable:
            return self.extrasDataSource[index]
        default:
            return []
        }
    }
    
    let ordersHeader:[String] = ["No", "Menu", "Price", "Quantity", "Total", "Has Promotion"]
    let extrasHeader:[String] = ["No", "Name", "Price", "Quantity", "Total"]
    
    func dataTable(_ dataTable: SwiftDataTable, headerTitleForColumnAt columnIndex: NSInteger) -> String {
        switch dataTable {
        case self.ordersTable:
            return self.ordersHeader[columnIndex]
        case self.ordersExtraTable:
            return self.extrasHeader[columnIndex]
        default:
            return ""
        }
    }
    
    func shouldShowSearchSection(in dataTable: SwiftDataTable) -> Bool {
        return false
    }

    func heightForSectionFooter(in dataTable: SwiftDataTable) -> CGFloat {
        return 0
    }

    func heightForSearchView(in dataTable: SwiftDataTable) -> CGFloat {
        return 0
    }

    func shouldShowVerticalScrollBars(in dataTable: SwiftDataTable) -> Bool {
        return false
    }

    func shouldShowHorizontalScrollBars(in dataTable: SwiftDataTable) -> Bool {
        return false
    }
    
    func dataTable(_ dataTable: SwiftDataTable, highlightedColorForRowIndex at: Int) -> UIColor {
        return Colors.colorWhite
    }
    
    func dataTable(_ dataTable: SwiftDataTable, unhighlightedColorForRowIndex at: Int) -> UIColor {
        return Colors.colorWhite
    }
    
    @IBAction func cancel(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func doneEditing(){
        self.view.endEditing(true)
    }
}