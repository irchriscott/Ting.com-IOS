//
//  BottomSheetMenuControllerView.swift
//  ting
//
//  Created by Christian Scott on 21/09/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit

class BottomSheetMenuControllerView: UICollectionViewController {
    
    var menu: RestaurantMenu? {
        didSet {}
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.colorWhite
        self.sheetViewController!.handleScrollView(self.collectionView)
    }
}
