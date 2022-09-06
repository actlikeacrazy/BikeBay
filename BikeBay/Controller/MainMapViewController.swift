//
//  ViewController.swift
//  BikeBay
//
//  Created by Aleksandrs Trubacs on 18/08/2022.
//

import UIKit
import MapKit

class MainMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Actions
    
    // MARK: Properties
    var pin: MKAnnotation!
    var selectedBikePoint: TFLBikePointResponse!
    fileprivate let locationManager: CLLocationManager = CLLocationManager()
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.showsUserLocation = true
        downloadPins()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        
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
            pinView.animatesDrop = false
            return pinView
        }
    }
    
    func downloadPins() {
        TFLClient.downloadingBikePoints { response, error in
            guard let error = error else {
                Swift.print("downloaded locations: \(response!.count)")
                BikeBayModel.bikeBays = response!
                // Annotations
                var annotations = [MKPointAnnotation]()
                print("There are \(BikeBayModel.bikeBays.count) locations in the model")
                for dictionary in BikeBayModel.bikeBays {
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
                
                return
            }
            Swift.print(error)
            // TODO: Show Error Message
        }
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "fromMapToDetail",
        let bikePointDetailViewController = segue.destination as? BikePointDetailViewController else {return}
        bikePointDetailViewController.pin = self.pin
        bikePointDetailViewController.currentBikePoint = selectedBikePoint
        print("Selected bike point: \(selectedBikePoint.id)")
    }
    
    // Delegate method to perform a segue when tapped on a pin
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        for pin in mapView.annotations {
            if pin.coordinate.latitude == view.annotation?.coordinate.latitude && pin.coordinate.longitude == view.annotation?.coordinate.longitude {
                findBikePoint(pin)
                self.pin = pin
            }
        }
        performSegue(withIdentifier: "fromMapToDetail", sender: self)
    }

    // MARK: Helper Methods
    private func handleTFLResponse(response: TFLResponse?, error: Error?) {
        guard let error = error else {
            print("downloaded locations: \(response!.count)")
            BikeBayModel.bikeBays = response!
            return
        }
        print(error)
        // TODO: Show Error Message
    }
    
    fileprivate func findBikePoint(_ pin: MKAnnotation) {
        for bikePoint in BikeBayModel.bikeBays {
            if bikePoint.lon == pin.coordinate.longitude && bikePoint.lat == pin.coordinate.latitude {
                selectedBikePoint = TFLBikePointResponse(type: bikePoint.type, id: bikePoint.id, url: bikePoint.url, commonName: bikePoint.commonName, placeType: bikePoint.placeType, additionalProperties: bikePoint.additionalProperties, children: bikePoint.children, lat: bikePoint.lat, lon: bikePoint.lon)
            }
        }
    }
    
}

