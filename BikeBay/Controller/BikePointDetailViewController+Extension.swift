//
//  BikePointDetailViewController+Extension.swift
//  BikeBay
//
//  Created by Aleksandrs Trubacs on 06/09/2022.
//

import Foundation
import UIKit
import MapKit

extension BikePointDetailViewController {
    
    // MARK: Helper Methods
    func numberOfBikes() -> Int {
        var count = 0
        for property in currentBikePoint.additionalProperties {
            if property.key == "NbBikes" {
                count = try! Int(property.value, format: .number)
            }
        }
        return count
    }
    
    func numberOfBays() -> Int {
        var count = 2
        for property in currentBikePoint.additionalProperties {
            if property.key == "NbDocks" {
                count = try! Int(property.value, format: .number)
                print("There are \(property.value) bike bays")
            }
        }
        return count
    }
    
}
