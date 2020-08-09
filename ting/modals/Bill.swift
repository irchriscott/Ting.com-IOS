//
//  Bill.swift
//  ting
//
//  Created by Christian Scott on 08/08/2020.
//  Copyright © 2020 Ir Christian Scott. All rights reserved.
//

import Foundation

struct Bill : Codable {
    let id: Int
    let number: String
    let token: String
    let amount: Double
    let discount: Double
    let tips: Double
    let extrasTotal: Double
    let total: Double
    let currency: String
    let isRequested: Bool
    let isPaid: Bool
    let isComplete: Bool
    let paidBy: Int?
    let orders: BillOrders?
    let extras: [BillExtra]
    let createdAt: String
    let updatedAt: String
}

struct BillOrders : Codable {
    let count: Int
    let orders: [OrderData]
}

struct Order : Codable {
    let id: Int
    let menu: RestaurantMenu
    let token: String
    let quantity: Int
    let price: Double
    let currency: String
    let conditions: String?
    let isAccepted: Bool
    let isDeclined: Bool
    let reasons: String?
    let hasPromotions: Bool
    let promotion: PromotionDataString?
    let createdAt: String
    let updatedAt: String
}

struct OrderData : Codable {
    let id: Int
    let menu: String
    let token: String
    let quantity: Int
    let price: Double
    let currency: String
    let conditions: String?
    let isAccepted: Bool
    let isDeclined: Bool
    let reasons: String?
    let hasPromotions: Bool
    let promotion: PromotionDataString?
    let createdAt: String
    let updatedAt: String
}

struct BillExtra : Codable {
    let id: Int
    let name: String
    let price: Double
    let quantity: Int
    let total: Double
    let createdAt: String
    let updatedAt: String
}
