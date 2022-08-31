//
//  BikeBayDetailViewController.swift
//  BikeBay
//
//  Created by Aleksandrs Trubacs on 30/08/2022.
//

import UIKit
import MapKit

class BikePointDetailViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Properties
    var pin: MKAnnotation!
    var bikePointID: String!
    var currentBikePoint: TFLBikePointResponse!
    
    // MARK: Actions
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        downloadBikePointDetails()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        print(pin.coordinate)
        createPinForMap(annotation: pin)
    }
    
    
    
    // MARK: MKMapview Delegate Methods
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives.
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
            pinView.animatesDrop = false
            return pinView
        }
    }
    
    func createPinForMap(annotation: MKAnnotation) {
        mapView.removeAnnotations(mapView.annotations)
        
        mapView.addAnnotation(annotation)
        mapView.setCenter(annotation.coordinate, animated: true)
        let region = MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }
    
    // MARK: Helper Methods
    private func downloadBikePointDetails() {
        TFLClient.downloadingBikePointDetails(id: bikePointID, completion: handleBikePointDetailsResponse(response:error:))
    }
    
    private func handleBikePointDetailsResponse(response: TFLBikePointResponse?, error: Error?) {
        guard let response = response else {
            return
        }
        self.currentBikePoint = response
    }
}
