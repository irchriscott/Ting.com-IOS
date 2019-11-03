//
//  User.swift
//  ting
//
//  Created by Ir Christian Scott on 02/08/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import Foundation

struct User: Codable {
    let id: Int
    let token: String?
    let name: String
    let username: String
    let email: String
    let image: String
    let pin: String
    let phone: String
    let dob: String?
    let gender: String?
    let country: String
    let town: String
    let restaurants: UserRestaurants?
    let reviews: UserRestaurantReviews?
    let addresses: UserAddresses?
    let urls: UserUrls
    let createdAt: String
    let updatedAt: String
}

struct Address: Codable {
    let id: Int
    let type: String
    let address: String
    let latitude: String
    let longitude: String
    let createdAt: String
    let updatedAt: String
}

struct UserRestaurant: Codable {
    let id: Int
    let user: User?
    let branch: Branch?
    let createdAt: String
    let updatedAt: String
}

struct UserRestaurants: Codable {
    let count: Int
    var restaurants: [UserRestaurant]
}

struct UserAddresses: Codable {
    let count: Int
    var addresses: [Address]
}

struct UserUrls: Codable {
    let loadRestaurants: String
    let loadReservations: String
    let apiGet: String
    let apiGetAuth: String
    let apiRestaurants: String
    let apiReservations: String
    let apiMoments: String
    let apiOrders: String
}

struct UserRestaurantReviews: Codable {
    let count: Int
    var reviews: [RestaurantReview]
}
