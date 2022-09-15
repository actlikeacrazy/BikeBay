//
//  BatchRequest.swift
//  BikeBay
//
//  Created by Aleksandrs Trubacs on 15/09/2022.
//

import Foundation
import CoreData

extension DataController {
    
    func batchInsertRequest(TFLResponseData: TFLResponse) -> NSBatchInsertRequest {
        
        var index = 0
        let total = TFLResponseData.count
        
        let batchInsert = NSBatchInsertRequest(entity: BikeBay.entity()) { (managedObject: NSManagedObject) -> Bool in guard index < total else { return true }
            if let bikeBay = managedObject as? BikeBay {
                let data = TFLResponseData[index]
                
                bikeBay.id = data.id
                bikeBay.commonName = data.commonName
                bikeBay.lon = data.lon
                bikeBay.lat = data.lat
                bikeBay.numberOfBikes = Int64(numberOfBikes(additionalProperties: data.additionalProperties))
                bikeBay.numberOfBays = Int64(numberOfBays(additionalProperties: data.additionalProperties))
            }
            index += 1
            return false
        }
        return batchInsert
    }
    
    func batchInsertTFLData(_ TFLResponseData: TFLResponse) {
        // 1
        guard !TFLResponseData.isEmpty else { return }
        
        // 2
        persistentContainer.performBackgroundTask { context in
            // 3
            let batchInsert = self.batchInsertRequest(TFLResponseData: TFLResponseData)
            do {
                try context.execute(batchInsert)
            } catch {
                // log any errors
            }
        }
    }
    
    
}
