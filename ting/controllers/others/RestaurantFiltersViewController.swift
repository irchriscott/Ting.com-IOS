//
//  RestaurantFiltersViewController.swift
//  ting
//
//  Created by Christian Scott on 14/08/2020.
//  Copyright © 2020 Ir Christian Scott. All rights reserved.
//

import UIKit
import SimpleCheckbox
import BEMCheckBox
import FittedSheets

class RestaurantFiltersViewController: UITableViewController, BEMCheckBoxDelegate {
    
    let cellId = "filterCellId"
    
    let typeLabels: [String] = ["Distance", "Availability", "Cuisines", "Services", "Specials", "Types", "Ratings"]
    
    var filters: [Filter]? {
        didSet {}
    }
    
    var type: Int? {
        didSet {}
    }
    
    var checkedValues: [Int] = []
    
    var onFilterRestaurants: ((Bool) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sheetViewController!.handleScrollView(self.tableView)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellId)
        
        switch type {
        case 1:
            checkedValues = LocalData.instance.getFiltersParams().availability
            break
        case 2:
            checkedValues = LocalData.instance.getFiltersParams().cuisines
            break
        case 3:
            checkedValues = LocalData.instance.getFiltersParams().services
            break
        case 4:
            checkedValues = LocalData.instance.getFiltersParams().specials
            break
        case 5:
            checkedValues = LocalData.instance.getFiltersParams().types
            break
        case 6:
            checkedValues = LocalData.instance.getFiltersParams().ratings
            break
        default:
            break
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filters?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath)
        cell.selectionStyle = .none
        
        let filter = self.filters![indexPath.item]
        
        let _ : Checkbox = {
            let view = Checkbox()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.borderLineWidth = 4.0
            view.borderStyle = .square
            view.checkedBorderColor = Colors.colorPrimary
            view.uncheckedBorderColor = Colors.colorGray
            view.checkboxFillColor = Colors.colorPrimary
            view.checkmarkColor = Colors.colorWhite
            view.checkmarkStyle = .tick
            view.tag = filter.id
            return view
        }()
        
        let checkBox: BEMCheckBox = {
            let view = BEMCheckBox()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.boxType = .square
            view.cornerRadius = 1.0
            view.lineWidth = 2.3
            view.offAnimationType = .bounce
            view.backgroundColor = Colors.colorWhite
            view.onFillColor = Colors.colorPrimary
            view.offFillColor = Colors.colorWhite
            view.tintColor = Colors.colorGray
            view.onTintColor = Colors.colorPrimary
            view.onAnimationType = .bounce
            view.onCheckColor = Colors.colorWhite
            view.tag = filter.id
            return view
        }()
        
        checkBox.delegate = self
        
        let labelView: UILabel = {
            let view = UILabel()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.font = UIFont(name: "Poppins-Regular", size: 14.0)
            view.textColor = Colors.colorGray
            view.text = filter.title
            return view
        }()
        
        cell.addSubview(checkBox)
        cell.addSubview(labelView)
        
        cell.addConstraintsWithFormat(format: "V:[v0(20)]", views: checkBox)
        cell.addConstraintsWithFormat(format: "V:|[v0]|", views: labelView)
        cell.addConstraintsWithFormat(format: "H:|-22-[v0(20)]-12-[v1]", views: checkBox, labelView)
        
        if self.checkedValues.contains(filter.id) {
            checkBox.setOn(true, animated: true)
        }
        
        cell.addConstraint(NSLayoutConstraint(item: cell, attribute: .centerY, relatedBy: .equal, toItem: checkBox, attribute: .centerY, multiplier: 1, constant: 0))
        cell.addConstraint(NSLayoutConstraint(item: cell, attribute: .centerY, relatedBy: .equal, toItem: labelView, attribute: .centerY, multiplier: 1, constant: 0))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView: UIView = {
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
            view.backgroundColor = .white
            return view
        }()
        
        let titleLabel: UILabel = {
            let view = UILabel()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.textColor = Colors.colorGray
            view.text = "Filter By \(self.typeLabels[type ?? 0])".uppercased()
            view.font = UIFont(name: "Poppins-Regular", size: 16)
            return view
        }()
        
        headerView.addSubview(titleLabel)
        headerView.addConstraintsWithFormat(format: "H:|-12-[v0]", views: titleLabel)
        headerView.addConstraintsWithFormat(format: "V:[v0]", views: titleLabel)
        headerView.addConstraint(NSLayoutConstraint(item: headerView, attribute: .centerY, relatedBy: .equal, toItem: titleLabel, attribute: .centerY, multiplier: 1, constant: 0))
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        let footerView: UIView = {
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60)
            view.backgroundColor = .white
            return view
        }()

        let submitButton : PrimaryButtonElse = {
            let view = PrimaryButtonElse()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 15.0)
            view.titleLabel?.text = "Filter Restaurants".uppercased()
            view.titleLabel?.textColor = Colors.colorWhite
            view.titleLabel?.textAlignment = .center
            view.layer.cornerRadius = 4.0
            view.backgroundColor = Colors.colorPrimary
            return view
        }()
        
        submitButton.addTarget(self, action: #selector(filterRestaurants(_:)), for: .touchUpInside)

        footerView.addSubview(submitButton)
        footerView.addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: submitButton)
        footerView.addConstraintsWithFormat(format: "V:|-10-[v0(45)]|", views: submitButton)
        footerView.addConstraint(NSLayoutConstraint(item: footerView, attribute: .centerY, relatedBy: .equal, toItem: submitButton, attribute: .centerY, multiplier: 1, constant: 0))
        
        submitButton.setTitle("Filter Restaurants".uppercased(), for: .normal)
        submitButton.setLinearGradientBackgroundColor(colorOne: Colors.colorPrimary, colorTwo: Colors.colorPrimaryDark)

        return footerView
    }
    
    @IBAction private func filterRestaurants(_ sender: UIButton) {
        self.sheetViewController?.closeSheet()
        self.onFilterRestaurants!(true)
    }
    
    func didTap(_ checkBox: BEMCheckBox) {
        if self.checkedValues.contains(checkBox.tag) {
            self.checkedValues.remove(at: self.checkedValues.index(of: checkBox.tag)!)
        } else { self.checkedValues.append(checkBox.tag) }
    }
    
    public func updateFilterParams() {
        var params = LocalData.instance.getFiltersParams()
        switch type {
        case 1:
            params.availability = checkedValues
            break
        case 2:
            params.cuisines = checkedValues
            break
        case 3:
            params.services = checkedValues
            break
        case 4:
            params.specials = checkedValues
            break
        case 5:
            params.types = checkedValues
            break
        case 6:
            params.ratings = checkedValues
            break
        default:
            break
        }
        
        do {
            let data = try JSONEncoder().encode(params)
            LocalData.instance.saveFiltersParams(data: data)
        } catch { return }
    }
}
