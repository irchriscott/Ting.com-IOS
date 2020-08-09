//
//  Restaurant.swift
//  ting
//
//  Created by Ir Christian Scott on 02/08/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import Foundation

struct Restaurant: Codable {
    let id: Int
    let token: String
    let name: String
    let motto: String
    let purposeId: Int
    let purpose: String
    let categories: RestaurantCategories
    let logo: String
    let pin: String
    let country: String
    let town: String
    let opening: String
    let closing: String
    let menus: BranchMenus?
    let branches: RestaurantBranches?
    let images: RestaurantImages
    let tables: BranchTables?
    let likes: BranchLikes?
    let foodCategories: RestaurantFoodCategories?
    let config: RestaurantConfig
    let createdAt: String
    let updatedAt: String
}

struct RestaurantConfig: Codable {
    let id: Int
    let currency: String?
    let tax: String?
    let email: String
    let phone: String
    let cancelLateBooking: Int
    let bookWithAdvance: Bool
    let bookingAdvance: String?
    let bookingPaymentMode: String
    let bookingCancelationRefund: Bool
    let bookingCancelationRefundPercent: String
    let daysBeforeReservation: Int
    let canTakeAway: Bool
    let userShouldPayBefore: Bool
}

struct RestaurantCategories: Codable {
    let count: Int
    let categories: [RestaurantCategory]
}

struct RestaurantBranches: Codable {
    let count: Int
    let branches: [Branch]?
}

struct RestaurantImage: Codable {
    let id: Int
    let image: String
    let createdAt: String
}

struct RestaurantImages: Codable {
    let count: Int
    let images: [RestaurantImage]
}

struct RestaurantFoodCategories: Codable {
    let count: Int
    let categories: [FoodCategory]?
}

struct RestaurantCategory: Codable {
    let name: String
    let country: String
    let image: String
    let createdAt: String
    let updatedAt: String
}

struct CategoryRestaurant: Codable {
    let id: Int
    let category: RestaurantCategory
    let createdAt: String
}

struct RestaurantReview: Codable {
    let id: Int
    let user: User?
    let restaurant: Restaurant?
    let branch: Branch?
    let review: Int
    let comment: String
    let createdAt: String
    let updatedAt: String
}

struct RestaurantTable: Codable {
    let id: Int
    let uuid: String
    let maxPeople: Int
    let number: String
    let location: String
    let chairType: String
    let description: String
    let isAvailable: Bool
    let createdAt: String
    let updatedAt: String
}
