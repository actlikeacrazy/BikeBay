//
//  TabBarViewController.swift
//  BikeBay
//
//  Created by Aleksandrs Trubacs on 17/09/2022.
//

import UIKit
import MapKit

class TabBarViewController: UITabBarController {
    
    var dataController: DataController!

    override func viewDidLoad() {
        super.viewDidLoad()
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        // Do any additional setup after loading the view.
    }
}
