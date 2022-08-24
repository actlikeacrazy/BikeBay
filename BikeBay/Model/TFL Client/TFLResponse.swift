//
//  TFLResponse.swift
//  BikeBay
//
//  Created by Aleksandrs Trubacs on 24/08/2022.
//

import Foundation
import Foundation

// MARK: - TFLResponseElement
struct TFLResponseElement: Codable {
    let type, id, url, commonName: String
    let placeType: PlaceType
    let additionalProperties: [AdditionalProperty]
    let children, childrenUrls: [JSONAny]
    let lat, lon: Double

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case id, url, commonName, placeType, additionalProperties, children, childrenUrls, lat, lon
    }
}

// MARK: - AdditionalProperty
struct AdditionalProperty: Codable {
    let type: String
    let category: Category
    let key: Key
    let sourceSystemKey: SourceSystemKey
    let value: String
    let modified: ModifiedUnion

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case category, key, sourceSystemKey, value, modified
    }
}

enum Category: String, Codable {
    case categoryDescription = "Description"
}

enum Key: String, Codable {
    case installDate = "InstallDate"
    case installed = "Installed"
    case locked = "Locked"
    case nbBikes = "NbBikes"
    case nbDocks = "NbDocks"
    case nbEBikes = "NbEBikes"
    case nbEmptyDocks = "NbEmptyDocks"
    case nbStandardBikes = "NbStandardBikes"
    case removalDate = "RemovalDate"
    case temporary = "Temporary"
    case terminalName = "TerminalName"
}

enum ModifiedUnion: Codable {
    case dateTime(Date)
    case enumeration(ModifiedEnum)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Date.self) {
            self = .dateTime(x)
            return
        }
        if let x = try? container.decode(ModifiedEnum.self) {
            self = .enumeration(x)
            return
        }
        throw DecodingError.typeMismatch(ModifiedUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ModifiedUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .dateTime(let x):
            try container.encode(x)
        case .enumeration(let x):
            try container.encode(x)
        }
    }
}

enum ModifiedEnum: String, Codable {
    case the20220818T16243879Z = "2022-08-18T16:24:38.79Z"
    case the20220818T163940333Z = "2022-08-18T16:39:40.333Z"
    case the20220818T164641577Z = "2022-08-18T16:46:41.577Z"
    case the20220818T16504175Z = "2022-08-18T16:50:41.75Z"
    case the20220818T165344383Z = "2022-08-18T16:53:44.383Z"
    case the20220818T165442283Z = "2022-08-18T16:54:42.283Z"
    case the20220818T171244843Z = "2022-08-18T17:12:44.843Z"
    case the20220818T17144438Z = "2022-08-18T17:14:44.38Z"
    case the20220818T17174543Z = "2022-08-18T17:17:45.43Z"
    case the20220818T172345473Z = "2022-08-18T17:23:45.473Z"
    case the20220818T17244598Z = "2022-08-18T17:24:45.98Z"
    case the20220818T172946193Z = "2022-08-18T17:29:46.193Z"
    case the20220818T173144647Z = "2022-08-18T17:31:44.647Z"
    case the20220818T17334658Z = "2022-08-18T17:33:46.58Z"
    case the20220818T173546603Z = "2022-08-18T17:35:46.603Z"
    case the20220818T17364729Z = "2022-08-18T17:36:47.29Z"
    case the20220818T17384695Z = "2022-08-18T17:38:46.95Z"
    case the20220818T173947307Z = "2022-08-18T17:39:47.307Z"
    case the20220818T174048303Z = "2022-08-18T17:40:48.303Z"
    case the20220818T174245863Z = "2022-08-18T17:42:45.863Z"
    case the20220818T17444823Z = "2022-08-18T17:44:48.23Z"
    case the20220818T17464818Z = "2022-08-18T17:46:48.18Z"
    case the20220818T174748187Z = "2022-08-18T17:47:48.187Z"
    case the20220818T174846453Z = "2022-08-18T17:48:46.453Z"
    case the20220818T174948573Z = "2022-08-18T17:49:48.573Z"
    case the20220818T175048377Z = "2022-08-18T17:50:48.377Z"
    case the20220818T17514844Z = "2022-08-18T17:51:48.44Z"
    case the20220818T175249793Z = "2022-08-18T17:52:49.793Z"
    case the20220818T175348693Z = "2022-08-18T17:53:48.693Z"
    case the20220818T175547787Z = "2022-08-18T17:55:47.787Z"
    case the20220818T17574932Z = "2022-08-18T17:57:49.32Z"
    case the20220818T17585014Z = "2022-08-18T17:58:50.14Z"
    case the20220818T180049707Z = "2022-08-18T18:00:49.707Z"
    case the20220818T180148187Z = "2022-08-18T18:01:48.187Z"
    case the20220818T18024991Z = "2022-08-18T18:02:49.91Z"
    case the20220818T180351623Z = "2022-08-18T18:03:51.623Z"
    case the20220818T18045167Z = "2022-08-18T18:04:51.67Z"
    case the20220818T180551217Z = "2022-08-18T18:05:51.217Z"
    case the20220818T18065186Z = "2022-08-18T18:06:51.86Z"
    case the20220818T18075148Z = "2022-08-18T18:07:51.48Z"
    case the20220818T180851647Z = "2022-08-18T18:08:51.647Z"
    case the20220818T180950467Z = "2022-08-18T18:09:50.467Z"
    case the20220818T181552723Z = "2022-08-18T18:15:52.723Z"
    case the20220818T181650757Z = "2022-08-18T18:16:50.757Z"
    case the20220818T181752457Z = "2022-08-18T18:17:52.457Z"
    case the20220818T181852567Z = "2022-08-18T18:18:52.567Z"
    case the20220818T18195371Z = "2022-08-18T18:19:53.71Z"
    case the20220818T182053367Z = "2022-08-18T18:20:53.367Z"
    case the20220818T182152883Z = "2022-08-18T18:21:52.883Z"
    case the20220818T182253767Z = "2022-08-18T18:22:53.767Z"
    case the20220818T182353087Z = "2022-08-18T18:23:53.087Z"
    case the20220818T182453757Z = "2022-08-18T18:24:53.757Z"
    case the20220818T182556373Z = "2022-08-18T18:25:56.373Z"
    case the20220818T18265469Z = "2022-08-18T18:26:54.69Z"
    case the20220818T182757063Z = "2022-08-18T18:27:57.063Z"
    case the20220818T182852623Z = "2022-08-18T18:28:52.623Z"
}

enum SourceSystemKey: String, Codable {
    case bikePoints = "BikePoints"
}

enum PlaceType: String, Codable {
    case bikePoint = "BikePoint"
}

typealias TFLResponse = [TFLResponseElement]

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }
    
    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
           if let value = try? container.decode(Bool.self, forKey: key) {
               return value
           }
           if let value = try? container.decode(Int64.self, forKey: key) {
               return value
           }
           if let value = try? container.decode(Double.self, forKey: key) {
               return value
           }
           if let value = try? container.decode(String.self, forKey: key) {
               return value
           }
           if let value = try? container.decodeNil(forKey: key) {
               if value {
                   return JSONNull()
               }
           }
           if var container = try? container.nestedUnkeyedContainer(forKey: key) {
               return try decodeArray(from: &container)
           }
           if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
               return try decodeDictionary(from: &container)
           }
           throw decodingError(forCodingPath: container.codingPath)
       }

       static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
           var arr: [Any] = []
           while !container.isAtEnd {
               let value = try decode(from: &container)
               arr.append(value)
           }
           return arr
       }

       static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
           var dict = [String: Any]()
           for key in container.allKeys {
               let value = try decode(from: &container, forKey: key)
               dict[key.stringValue] = value
           }
           return dict
       }
    
    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
           for value in array {
               if let value = value as? Bool {
                   try container.encode(value)
               } else if let value = value as? Int64 {
                   try container.encode(value)
               } else if let value = value as? Double {
                   try container.encode(value)
               } else if let value = value as? String {
                   try container.encode(value)
               } else if value is JSONNull {
                   try container.encodeNil()
               } else if let value = value as? [Any] {
                   var container = container.nestedUnkeyedContainer()
                   try encode(to: &container, array: value)
               } else if let value = value as? [String: Any] {
                   var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                   try encode(to: &container, dictionary: value)
               } else {
                   throw encodingError(forValue: value, codingPath: container.codingPath)
               }
           }
       }

       static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
           for (key, value) in dictionary {
               let key = JSONCodingKey(stringValue: key)!
               if let value = value as? Bool {
                   try container.encode(value, forKey: key)
               } else if let value = value as? Int64 {
                   try container.encode(value, forKey: key)
               } else if let value = value as? Double {
                   try container.encode(value, forKey: key)
               } else if let value = value as? String {
                   try container.encode(value, forKey: key)
               } else if value is JSONNull {
                   try container.encodeNil(forKey: key)
               } else if let value = value as? [Any] {
                   var container = container.nestedUnkeyedContainer(forKey: key)
                   try encode(to: &container, array: value)
               } else if let value = value as? [String: Any] {
                   var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                   try encode(to: &container, dictionary: value)
               } else {
                   throw encodingError(forValue: value, codingPath: container.codingPath)
               }
           }
       }

       static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
           if let value = value as? Bool {
               try container.encode(value)
           } else if let value = value as? Int64 {
               try container.encode(value)
           } else if let value = value as? Double {
               try container.encode(value)
           } else if let value = value as? String {
               try container.encode(value)
           } else if value is JSONNull {
               try container.encodeNil()
           } else {
               throw encodingError(forValue: value, codingPath: container.codingPath)
           }
       }
    
    public required init(from decoder: Decoder) throws {
          if var arrayContainer = try? decoder.unkeyedContainer() {
              self.value = try JSONAny.decodeArray(from: &arrayContainer)
          } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
              self.value = try JSONAny.decodeDictionary(from: &container)
          } else {
              let container = try decoder.singleValueContainer()
              self.value = try JSONAny.decode(from: container)
          }
      }

      public func encode(to encoder: Encoder) throws {
          if let arr = self.value as? [Any] {
              var container = encoder.unkeyedContainer()
              try JSONAny.encode(to: &container, array: arr)
          } else if let dict = self.value as? [String: Any] {
              var container = encoder.container(keyedBy: JSONCodingKey.self)
              try JSONAny.encode(to: &container, dictionary: dict)
          } else {
              var container = encoder.singleValueContainer()
              try JSONAny.encode(to: &container, value: self.value)
          }
      }
  }

