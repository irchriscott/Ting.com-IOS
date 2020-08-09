//
//  Administrator.swift
//  ting
//
//  Created by Christian Scott on 08/08/2020.
//  Copyright © 2020 Ir Christian Scott. All rights reserved.
//

import Foundation

struct Administrator : Codable {
    let id: Int
    let name: String
    let username: String
    let type: String
    let email: String
    let phone: String
    let image: String
    let badgeNumber: String
    let channel: String
    let permissions: [String]
    let createdAt: String
    let updatedAt: String
}
