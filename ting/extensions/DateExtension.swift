//
//  DateExtension.swift
//  ting
//
//  Created by Christian Scott on 16/09/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import Foundation

extension Date {
    func toMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
