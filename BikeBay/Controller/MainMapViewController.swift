//
//  ViewController.swift
//  BikeBay
//
//  Created by Aleksandrs Trubacs on 18/08/2022.
//

import UIKit
import MapKit

class MainMapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    
    // MARK: Actions
    
    // MARK: Properties
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    // MARK: MKMapview Delegate Methods
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        if let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView {
            pinView.annotation = annotation
            return pinView
        } else {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView.canShowCallout = true
            pinView.pinTintColor = .red
            pinView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            pinView.animatesDrop = true
            return pinView
        }
    }
    
    func downloadPins() {
       TFLClient.downloadingBikeBay(completion: handleTFLResponse(response:error:))
        // Annotations
        var annotations = [MKPointAnnotation]()
        
        for dictionary in BikeBayModel.bikeBays {
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(dictionary.lat)
            let long = CLLocationDegrees(dictionary.lon)
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
//            let first = dictionary.firstName
//            let last = dictionary.lastName
//            let mediaURL = dictionary.mediaURL
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
//            annotation.title = "\(first) \(last)"
//            annotation.subtitle = mediaURL
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        // When the array is complete, we add the annotations to the map.
        print("adding annotations \(annotations)")
        self.mapView.addAnnotations(annotations)
    }
    
    // Delegate method to perform a segue when tapped on a pin
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        for pin in fetchedResultsController.fetchedObjects! {
//            if pin.latitude == view.annotation?.coordinate.latitude && pin.longitude == view.annotation?.coordinate.longitude {
//                debugPrint("Pin found and assigned: \(pin)")
//                debugPrint("With \(pin.corePhotos!.count) saved photos")
//                self.pin = pin
//            }
//        }
//        performSegue(withIdentifier: "presentPhotoAlbumView", sender: self)
//    }
    
    // MARK: Helper Methods
    
    private func handleTFLResponse(response: TFLResponseElement?, error: Error?) {
        guard let error = error else {
            BikeBayModel.bikeBays = [response.unsafelyUnwrapped]
            return
        }
        print(error)
        // TODO: Show Error Message
    }
}

