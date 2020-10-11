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
    var waiter: SocketUser?
    var status: Int
    var message: String?
    let args: [String: String]?
    let data: [String: String]?
    
    func getSting() -> String {
        return "{'uuid': '\(uuid)', 'type': '\(type)', 'sender': '\(String(describing: sender?.getSting()))', 'receiver': '\(String(describing: receiver?.getSting()))', 'status': \(status), 'message': '\(String(describing: message))', 'args': '', 'data': ''}"
    }
}

struct SocketUser : Codable {
    var id: Int?
    var type: Int? //1 => Branch, 2 => Waiter, 3 => User
    var name: String?
    var email: String?
    var image: String?
    var channel: String
    
    func getSting() -> String {
        return "{'id': \(String(describing: id)), 'type': \(String(describing: type)), 'name': '\(String(describing: name))', 'email': '\(String(describing: email))', 'image': '\(String(describing: image))', 'channel': '\(channel)'}"
    }
}
