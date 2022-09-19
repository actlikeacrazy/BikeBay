//
//  ViewController.swift
//  BikeBay
//
//  Created by Aleksandrs Trubacs on 18/08/2022.
//

import UIKit
import MapKit
import CoreData

class MainMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, NSFetchedResultsControllerDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Actions
    
    // MARK: Properties
    var pin: MKAnnotation!
    var selectedBikePoint: BikeBay!
    
    // MARK: Data Controller set up 
    var dataController:DataController!
    
    var fetchedResultsController:NSFetchedResultsController<BikeBay>!
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<BikeBay> = BikeBay.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "bikebays")
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
        self.mapView.showsUserLocation = true
        downloadPins()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let tabBarController = tabBarController as! TabBarViewController
        dataController = tabBarController.dataController
        tabBarSetUp()
        mapView.setUserTrackingMode(.follow, animated: true)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
        mapView.setUserTrackingMode(.none, animated: true)
    }
    
    // MARK: - MKMapview Delegate Methods
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        if annotation is MKUserLocation {
               return nil
           }
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
        self.mapView.removeAnnotations(mapView.annotations)
        TFLClient.downloadingBikePoints { [self] response, error in
            guard let error = error else {
                print("downloaded locations: \(response!.count)")
                if fetchedResultsController.fetchedObjects!.isEmpty {
                    print("Is storage empty: \(fetchedResultsController.fetchedObjects!.isEmpty)")
                    dataController.batchInsertTFLData(response!)
                } else {
                    dataController.batchUpdate(response!)
                }
                // Annotations
                var annotations = [MKPointAnnotation]()
                //print("There are \(BikeBayModel.bikeBays.count) locations in the model")
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
                return
            }
            Swift.print(error)
            // Present an Alert with error
            let alert = UIAlertController(title: "Try Again", message: "Something went wrong downloading Bike Locations, please try again later!", preferredStyle: .actionSheet)
            // Create actions
            let tryAgainAction = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] action in
                self!.manuallyTrigerDownload()
            }
            alert.addAction(tryAgainAction)
        }
    }
    
    
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "fromMapToDetail",
        let bikePointDetailViewController = segue.destination as? BikePointDetailViewController else {return}
        bikePointDetailViewController.pin = self.pin
        bikePointDetailViewController.currentBikePoint = selectedBikePoint
        bikePointDetailViewController.dataController = dataController
        print("Selected bike point: \(String(describing: selectedBikePoint))")
    }
    
    // Delegate method to perform a segue when tapped on a pin
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.mapView.setUserTrackingMode(.none, animated: true)
        if view.annotation is MKUserLocation {
           // do nothing
        } else {
            for pin in mapView.annotations {
                if pin.coordinate.latitude == view.annotation?.coordinate.latitude && pin.coordinate.longitude == view.annotation?.coordinate.longitude {
                    findBikePoint(pin)
                    self.pin = pin
                }
            }
            performSegue(withIdentifier: "fromMapToDetail", sender: self)
        }
    }

    // MARK: Helper Methods
    fileprivate func findBikePoint(_ pin: MKAnnotation) {
        for bikePoint in fetchedResultsController.fetchedObjects! {
            if bikePoint.lon == pin.coordinate.longitude && bikePoint.lat == pin.coordinate.latitude {
                selectedBikePoint = bikePoint
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
    
    fileprivate func manuallyTrigerDownload() {
        TFLClient.downloadingBikePoints { [self] response, error in
            guard let error = error else {
                if self.fetchedResultsController.fetchedObjects!.isEmpty {
                    self.dataController.batchInsertTFLData(response!)
                } else {
                    self.dataController.batchUpdate(response!)
                }
                return
            }
            print(error)
        }
    }
    
}

