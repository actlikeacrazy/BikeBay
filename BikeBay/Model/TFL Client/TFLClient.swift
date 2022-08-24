//
//  TFLClient.swift
//  BikeBay
//
//  Created by Aleksandrs Trubacs on 24/08/2022.
//

import Foundation

class TFLClient {

    enum Endpoints {
        
        static let base = "https://api.tfl.gov.uk/BikePoint"
        
        case bikePoints
        
        var stringValue: String {
            switch self {
            case .bikePoints:
                return Endpoints.base
                
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
    }

}
