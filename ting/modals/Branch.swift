//
//  Branch.swift
//  ting
//
//  Created by Ir Christian Scott on 02/08/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import Foundation

struct Branch: Codable {
    let id: Int
    let restaurant: Restaurant?
    let name: String
    let country: String
    let town: String
    let address: String
    let latitude: String
    let longitude: String
    var dist: Double?
    let placeId: String
    let email: String
    let phone: String
    let channel: String
    let isAvailable: Bool
    let categories: RestaurantCategories
    let tables: BranchTables
    let specials: [BranchSpecials]
    let services: [BranchSpecials]
    let tags: [String]
    let menus: BranchMenus
    let promotions: BranchPromotions?
    let reviews: BranchReviews?
    let likes: BranchLikes?
    let urls: BranchUrls
    let createdAt: String
    let updatedAt: String
}

struct BranchSpecials: Codable {
    let id: Int
    let name: String
    let icon: String
}

struct BranchTables: Codable {
    let count: Int
    let iron: Int?
    let wooden: Int?
    let plastic: Int?
    let couch: Int?
    let mixture: Int?
    let inside: Int?
    let outside: Int?
    let balcony: Int?
    let rooftop: Int?
    let tables: [RestaurantTable]?
}

struct BranchMenus: Codable {
    let count: Int
    let type: BranchMenusType
    let menus: [RestaurantMenu]?
}

struct BranchMenusType: Codable {
    let foods: BranchMenusTypeFood
    let drinks: Int
    let dishes: Int
}

struct BranchMenusTypeFood: Codable {
    let count: Int
    let type: BranchMenusTypeFoodTypes
}

struct BranchMenusTypeFoodTypes: Codable {
    let appetizers: Int
    let meals: Int
    let desserts: Int
    let sauces: Int
}

struct BranchPromotions: Codable {
    let count: Int
    let promotions: [MenuPromotion]?
}

struct BranchReviews: Codable {
    let count: Int
    let average: Int
    let percents: [Int]
    let reviews: [RestaurantReview]?
}

struct BranchLikes: Codable {
    let count: Int
    let likes: [Int]?
}

struct BranchUrls: Codable {
    let relative: String
    let loadReviews: String
    let addReview: String
    let likeBranch: String
    let loadLikes: String
    let apiGet: String
    let apiPromotions: String
    let apiFoods: String
    let apiDrinks: String
    let apiDishes: String
    let apiReviews: String
    let apiAddReview: String
    let apiLikes: String
    let apiAddLike: String
}

struct TableLocation : Codable {
    let id: Int
    let name: String
}

struct BranchTableLocations : Codable {
    let locations: [TableLocation]
    let tables: [Int]
}
