//
//  SocketResponseMessage.swift
//  ting
//
//  Created by Christian Scott on 08/08/2020.
//  Copyright © 2020 Ir Christian Scott. All rights reserved.
//

import Foundation

struct SocketResponseMessage : Codable {
    var uuid: String
    var type: String
    var sender: SocketUser?
    var receiver: SocketUser?
    var status: Int
    var message: String
    let args: [String: String]?
    let data: [String: String]?
}

struct SocketUser : Codable {
    var id: Int?
    var type: Int? //1 => Branch, 2 => Waiter, 3 => User
    var name: String?
    var image: String?
    var channel: String
}
