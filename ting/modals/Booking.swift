//
//  Booking.swift
//  ting
//
//  Created by Christian Scott on 08/08/2020.
//  Copyright © 2020 Ir Christian Scott. All rights reserved.
//

import Foundation

struct Booking : Codable {
    let id: Int
    let branch: Branch?
    let table: RestaurantTable?
    let token: String
    let people: Int
    let date: String
    let time: String
    let status: String
    let createdAt: String
    let updatedAt: String
}
