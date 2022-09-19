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
                fatalError("Failed to execute request: \(error)")
            }
        }
    }
    
    func batchUpdate(_ TFLResponseData: TFLResponse) {
        // 1
        guard !TFLResponseData.isEmpty else { return }
        // 2
        persistentContainer.performBackgroundTask { context in
            // 3
            let batchUpdate = self.batchUpdateRequest(TFLResponseData: TFLResponseData)
            do {
                let result = try context.execute(batchUpdate) as? NSBatchUpdateResult
                let objectIDArray = result?.result as? [NSManagedObjectID]
                let changes = [NSUpdatedObjectsKey : objectIDArray]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes as [AnyHashable : Any], into: [context])
            } catch {
                fatalError("Failed to execute request: \(error)")
            }
        }
    }
    
    func batchUpdateRequest(TFLResponseData: TFLResponse) -> NSBatchUpdateRequest {
        let batchUpdate = NSBatchUpdateRequest(entity: BikeBay.entity())
        for object in TFLResponseData {
            let predicate = NSPredicate(format: "id == %@", object.id)
            batchUpdate.predicate = predicate
            batchUpdate.propertiesToUpdate = ["numberOfBays" : Int64(numberOfBays(additionalProperties: object.additionalProperties)),"numberOfBikes" : Int64(numberOfBikes(additionalProperties: object.additionalProperties))]
        }
        batchUpdate.resultType = .updatedObjectIDsResultType
        return batchUpdate
    }
    
    
    
}
