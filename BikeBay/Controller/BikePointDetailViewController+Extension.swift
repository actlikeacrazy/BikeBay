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
    
    func addSaveNotificationObserver(_ collectionView:CollectionViewHeader) {
        removeSaveNotificationObserver()
        saveObserverToken = NotificationCenter.default.addObserver(forName: .NSManagedObjectContextObjectsDidChange, object: dataController?.viewContext, queue: nil, using: { notification in
            self.handleSaveNotification(collectionView, notification: notification)
        })
    }
    
    func removeSaveNotificationObserver() {
        if let token = saveObserverToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    fileprivate func reloadData(_ collectionView: CollectionViewHeader) {
        collectionView.favouriteButton.isSelected = self.currentBikePoint.favourite
    }
    
    func handleSaveNotification(_ collectionView: CollectionViewHeader,notification:Notification) {
        DispatchQueue.main.async {
            self.reloadData(collectionView)
        }
    }
    
    
    
}
