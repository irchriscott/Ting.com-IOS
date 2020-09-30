//  Created by Marcin Krzyzanowski on 06/01/2020.
//
//  struct Filter: Codable {
//    let id: String
//  }
//
//  let data = try Filter(id: "foo").to(.json)
//  let filter = try Filter.from(data, format: .json)
//

import Foundation

public protocol FoundationEncoder {
    func encode<T: Encodable>(_ value: T) throws -> Data
}

extension JSONEncoder: FoundationEncoder { }
extension PropertyListEncoder: FoundationEncoder { }

public protocol FoundationDecoder {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}

extension JSONDecoder: FoundationDecoder { }
extension PropertyListDecoder: FoundationDecoder { }


public struct CodableFormat: Identifiable {
    
    public let id: String
    
    let encoder: FoundationEncoder
    let decoder: FoundationDecoder

    public init<F: FoundationEncoder, D: FoundationDecoder>(_ id: ID, _ encoder: @autoclosure () -> F, _ decoder: @autoclosure () -> D) {
        self.id = id
        self.encoder = encoder()
        self.decoder = decoder()
    }

    public static let json = CodableFormat("json", JSONEncoder(), JSONDecoder())
    public static let plist = CodableFormat("plist", PropertyListEncoder(), PropertyListDecoder())
}

public extension CodableFormat {

    private static var jsonSnakeCaseEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }

    private static var jsonSnakeCaseDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }

    // Custom format
    static let jsonSnakeCase = CodableFormat("jsonSnakeCase", jsonSnakeCaseEncoder, jsonSnakeCaseDecoder)
}

public extension Encodable {
    func to(_ format: CodableFormat) throws -> Data {
        try format.encoder.encode(self)
    }
}

public extension Decodable {
    static func from(_ data: Data, format: CodableFormat) throws -> Self {
        try format.decoder.decode(Self.self, from: data)
    }

    static func from(_ string: String, format: CodableFormat) throws -> Self {
        try self.from(Data(string.utf8), format: format)
    }
}

extension Encodable {
    var dict : [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else { return nil }
        return json
    }
}

extension JSONEncoder {
    func encodeJSONObject<T: Encodable>(_ value: T, options opt: JSONSerialization.ReadingOptions = []) throws -> Any {
        let data = try encode(value)
        return try JSONSerialization.jsonObject(with: data, options: opt)
    }
}

extension JSONDecoder {
    func decode<T: Decodable>(_ type: T.Type, withJSONObject object: Any, options opt: JSONSerialization.WritingOptions = []) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: object, options: opt)
        return try decode(T.self, from: data)
    }
}
