//
//  BikeBayModel.swift
//  BikeBay
//
//  Created by Aleksandrs Trubacs on 24/08/2022.
//

import Foundation

class BikeBayModel {
    
    static var bikeBays = [BikeBay]()
    
    
    class func feedTheModel(_ response: TFLResponse?) {
        for object in response! {
            BikeBayModel.bikeBays.append(BikeBay(id: object.id, url: object.url, commonName: object.commonName, numberOfBikes: numberOfBikes(station: object.additionalProperties), numberOfBays: numberOfBays(additionalProperties: object.additionalProperties), lat: object.lat, lon: object.lon))
        }
    }
    
}

struct BikeBay: Codable {
    let id, url, commonName: String
    let numberOfBikes: Int
    let numberOfBays: Int
    let lat, lon: Double
}
