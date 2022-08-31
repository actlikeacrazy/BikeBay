//
//  TFLBikePointResponse.swift
//  BikeBay
//
//  Created by Aleksandrs Trubacs on 30/08/2022.
//

import Foundation

// MARK: - TFLBikePointResponse
struct TFLBikePointResponse: Codable {
    let type, id, url, commonName: String
    let placeType: String
    let additionalProperties: [AdditionalProperty]
    let children: [JSONAny]
    let lat, lon: Double

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case id, url, commonName, placeType, additionalProperties, children, lat, lon
    }
}





