//
//  RestaurantFilters.swift
//  ting
//
//  Created by Christian Scott on 12/08/2020.
//  Copyright © 2020 Ir Christian Scott. All rights reserved.
//

import Foundation

struct Filter : Codable {
    let id: Int
    let title: String
}

struct RestaurantFilters : Codable {
    let availability: [Filter]
    let cuisines: [Filter]
    let services: [Filter]
    let specials: [Filter]
    let types: [Filter]
    let ratings: [Filter]
}

struct FiltersParameters : Codable {
    var availability: [Int]
    var cuisines: [Int]
    var services: [Int]
    var specials: [Int]
    var types: [Int]
    var ratings: [Int]
}
