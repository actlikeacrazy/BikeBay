//
//  FavouriteListViewController.swift
//  BikeBay
//
//  Created by Aleksandrs Trubacs on 13/09/2022.
//

import UIKit

class FavouriteListViewController: UIViewController, UITableViewDataSource {
    
    // MARK: Properties
    
    let model = BikeBayModel.bikeBays
    
    // MARK: Life cycle
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
    }
    
    // MARK:  Table View Delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let station = BikeBayModel.bikeBays[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableListCell", for: indexPath) as! TabelListCell
        
        // Configure cell
        cell.textPreviewLabel.text = station.commonName
        cell.detailLabel.text = "Available bikes: \(station.numberOfBikes)"
        
        return cell
        
    }

}
