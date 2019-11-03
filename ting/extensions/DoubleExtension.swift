//
//  DoubleExtension.swift
//  ting
//
//  Created by Christian Scott on 17/09/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import Foundation

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
