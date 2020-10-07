//
//  SearchResult.swift
//  ting
//
//  Created by Christian Scott on 08/08/2020.
//  Copyright © 2020 Ir Christian Scott. All rights reserved.
//

import Foundation

struct SearchResult : Codable {
    let id: Int
    let type: Int
    let image: String
    let name: String
    let description: String
    let text: String
    let reviews: Int
    let reviewAverage: Int
    let apiGet: String
    let relative: String
}
