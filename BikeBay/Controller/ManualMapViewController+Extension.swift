//
//  ManualMapViewController+Extension.swift
//  BikeBay
//
//  Created by Aleksandrs Trubacs on 21/09/2022.
//

import Foundation
import UIKit
import MapKit
import CoreData

extension MainMapViewController {
    
    // MARK: Helper Methods
    func findBikePoint(_ pin: MKAnnotation) {
        for bikePoint in fetchedResultsController.fetchedObjects! {
            if bikePoint.lon == pin.coordinate.longitude && bikePoint.lat == pin.coordinate.latitude {
                self.selectedBikePoint = bikePoint
                self.pin = pin
            }
        }
    }
    
    func tabBarSetUp() {
        self.tabBarController?.tabBar.isTranslucent = true
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.tabBarController?.tabBar.bounds ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        blurView.autoresizingMask = .flexibleWidth
        self.tabBarController?.tabBar.insertSubview(blurView, at: 0)
        self.edgesForExtendedLayout = .bottom
        self.extendedLayoutIncludesOpaqueBars = true
    }
    
    func addAnnotations() {
        // Annotations
        var annotations = [MKPointAnnotation]()
        for dictionary in self.fetchedResultsController.fetchedObjects! {
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(dictionary.lat)
            let long = CLLocationDegrees(dictionary.lon)
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
    }
    
    func manuallyTrigerDownload() {
        TFLClient.downloadingBikePoints { [self] response, error in
            guard let error = error else {
                if self.fetchedResultsController.fetchedObjects!.isEmpty {
                    self.dataController.batchInsertTFLData(response!)
                } else {
                    self.dataController.batchUpdate(response!)
                }
                addAnnotations()
                return
            }
            print(error)
        }
    }
    
    func isActivityIndicator(_ running: Bool) {
        activityIndicator.style = .large
        if running {
            activityIndicator.startAnimating()
            activityIndicator.isHidden = !running
        } else if running == false {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = !running
        }
    }
    
}
