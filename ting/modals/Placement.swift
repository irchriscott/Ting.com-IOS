//
//  Placement.swift
//  ting
//
//  Created by Christian Scott on 08/08/2020.
//  Copyright © 2020 Ir Christian Scott. All rights reserved.
//

import Foundation

struct Placement : Codable {
    let id: Int
    let user: User
    let table: RestaurantTable
    let booking: Booking?
    let waiter: Administrator?
    let bill: Bill?
    let token: String
    let people: Int
    let isDone: Bool
    let needSomeone: Bool
    let createdAt: String
    let updatedAt: String
}
