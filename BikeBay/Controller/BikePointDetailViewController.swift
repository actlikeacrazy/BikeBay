//
//  BikeBayDetailViewController.swift
//  BikeBay
//
//  Created by Aleksandrs Trubacs on 30/08/2022.
//

import UIKit
import MapKit
import CoreData

class BikePointDetailViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    
    // MARK: Properties
    var pin: MKAnnotation!
    var currentBikePoint: BikeBay!
    var dataController:DataController!
    var saveObserverToken: Any?
    
    // MARK: Actions
    @IBAction func favouriteButtonPressed(_ sender: Any) {
        currentBikePoint.favourite.toggle()
        saveContext()
    }
    // MARK: Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        flowLayout.minimumLineSpacing = 5
        flowLayout.sectionHeadersPinToVisibleBounds = true
        flowLayout.itemSize = CGSize(width: 60, height: 60)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        print(pin.coordinate)
        createPinForMap(annotation: pin)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveContext()
    }
    
    // MARK: - MKMapview Delegate Methods
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
}

    // MARK: - CollectionView Delegate Methods
extension BikePointDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(currentBikePoint.numberOfBays)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BikeCell.defaultReuseIdentifier, for: indexPath) as! BikeCell
        switch indexPath.item < currentBikePoint.numberOfBikes {
        case true:
            cell.imageView.image = UIImage(named: "santanderCycle")
        case false:
            cell.imageView.image = UIImage(systemName: "square.dashed")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? CollectionViewHeader {
            sectionHeader.headerLabel.text = "\(currentBikePoint.commonName!)"
            sectionHeader.subHeader.text = "\(currentBikePoint.numberOfBikes) bikes available out of \(currentBikePoint.numberOfBays) bays"
            sectionHeader.favouriteButton.isSelected = currentBikePoint.favourite
            sectionHeader.favouriteButton.setImage(UIImage(systemName: "star"), for: .normal)
            sectionHeader.favouriteButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
        
            addSaveNotificationObserver(sectionHeader)
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
}
