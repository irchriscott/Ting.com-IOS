//
//  ServerResponse.swift
//  ting
//
//  Created by Ir Christian Scott on 01/08/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import Foundation

struct ServerResponse: Codable {
    let type: String
    let message: String
    let redirect: String?
    let status: Int
    let user: User?
}
