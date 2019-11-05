//
//  RestaurantMenu.swift
//  ting
//
//  Created by Ir Christian Scott on 02/08/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import Foundation

struct RestaurantMenu: Codable {
    let id: Int?
    let type: MenuType?
    let urls: MenuUrls?
    let url: String?
    let menu: Menu?
}

struct MenuType: Codable {
    let id: Int
    let name: String
}

struct MenuUrls: Codable {
    let url: String
    let like: String
    let loadReviews: String
    let addReview: String
    let apiGet: String
    let apiLike: String
    let apiReviews: String
    let apiAddReview: String
}

struct Menu: Codable {
    let id: Int
    let restaurant: Restaurant?
    let branch: Branch?
    let name: String?
    let category: FoodCategory?
    let dishTimeId: Int?
    let dishTime: String?
    let foodType: String?
    let foodTypeId: Int?
    let drinkTypeId: Int?
    let drinkType: String?
    let description: String?
    let ingredients: String?
    let showIngredients: Bool?
    let price: String?
    let lastPrice: String?
    let currency: String?
    let isCountable: Bool?
    let isAvailable: Bool?
    let quantity: Int?
    let hasDrink: Bool?
    let drink: [String: String]?
    let url: String?
    let promotions: MenuPromotions?
    let reviews: MenuReviews?
    let likes: MenuLikes?
    let foods: MenuFoods?
    let images: MenuImages?
    let createdAt: String?
    let updatedAt: String?
}

struct MenuPromotions: Codable {
    let count: Int
    let promotions: [MenuPromotion]?
}

struct MenuReviews: Codable {
    let count: Int
    let average: Double
    let percents: [Int]
    let reviews: [MenuReview]?
}

struct MenuLikes: Codable {
    let count: Int
    let likes: [MenuLike]?
}

struct MenuFoods: Codable {
    let count: Int
    let foods: [Menu]?
}

struct MenuImage: Codable {
    let id: Int
    let image: String
    let createdAt: String
}

struct MenuImages: Codable {
    let count: Int
    let images: [MenuImage]
}

struct FoodCategory: Codable {
    let id: Int?
    let name: String?
    let description: String?
    let image: String?
    let createdAt: String?
    let updatedAt: String?
}

struct MenuLike: Codable {
    let id: Int
    let user: User
    let createdAt: String
    let updatedAt: String
}

struct MenuReview: Codable {
    let id: Int
    let user: User
    let review: Int
    let comment: String
    let createdAt: String
    let updatedAt: String
}
