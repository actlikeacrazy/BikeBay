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
    func saveContext() {
        do {
            try dataController.viewContext.save()
        } catch {
            print("viewContext save failed!")
        }
        
        
    }

    
}
