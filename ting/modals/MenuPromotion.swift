//
//  MenuPromotion.swift
//  ting
//
//  Created by Ir Christian Scott on 02/08/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import Foundation

struct MenuPromotion: Codable {
    let id: Int
    let restaurant: Restaurant?
    let branch: Branch?
    let occasionEvent: String
    let uuid: String
    let uuidUrl: String
    let promotionItem: PromotionItem
    let menus: PromotionMenus
    let reduction: PromotionReduction
    let supplement: PromotionSupplement
    let period: String
    let description: String
    let posterImage: String
    let isOn: Bool
    let isOnToday: Bool
    let interests: PromotionInterests
    let urls: PromotionUrls
    let createdAt: String
    let updatedAt: String
}

struct PromotionItem: Codable {
    let type: PromotionItemType
    let category: FoodCategory?
    let menu: RestaurantMenu?
}

struct PromotionItemType: Codable {
    let id: String
    let name: String
}

struct PromotionReduction: Codable {
    let hasReduction: Bool
    let amount: Int
    let reductionType: String?
}

struct PromotionSupplement: Codable {
    let hasSupplement: Bool
    let minQuantity: Int
    let isSame: Bool
    let supplement: RestaurantMenu?
    let quantity: Int
}

struct PromotionInterest: Codable {
    let id: Int
    let user: User
    let isInterested: Bool
    let createdAt: String
}

struct PromotionInterests: Codable {
    let count: Int
    let interests: [Int]
}

struct PromotionUrls: Codable {
    let relative: String
    let interest: String
    let apiGet: String
    let apiInterest: String
}

struct PromotionMenus : Codable {
    let count: Int
    let menus: [RestaurantMenu]?
}

struct PromotionDataString : Codable {
    let id: Int
    let occasionEvent: String
    let posterImage: String
    let supplement: String?
    let reduction: String?
}
