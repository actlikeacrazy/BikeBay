//
//  Services.swift
//  BikeBay
//
//  Created by Aleksandrs Trubacs on 13/09/2022.
//

import Foundation
import UIKit

func numberOfBikes(additionalProperties: [AdditionalProperty]) -> Int {
    var count = 0
    for property in additionalProperties {
        if property.key == "NbBikes" {
            count = try! Int(property.value, format: .number)
        }
    }
    return count
}

func numberOfBays(additionalProperties: [AdditionalProperty]) -> Int {
    var count = 2
    for property in additionalProperties {
        if property.key == "NbDocks" {
            count = try! Int(property.value, format: .number)
            print("There are \(property.value) bike bays")
        }
    }
    return count
}
