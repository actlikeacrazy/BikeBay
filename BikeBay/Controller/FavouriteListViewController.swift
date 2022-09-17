//
//  FavouriteListViewController.swift
//  BikeBay
//
//  Created by Aleksandrs Trubacs on 13/09/2022.
//

import UIKit
import CoreData

class FavouriteListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    // MARK: Data Controller set up
    var dataController:DataController!
    
    var fetchedResultsController:NSFetchedResultsController<BikeBay>!
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<BikeBay> = BikeBay.fetchRequest()
        let predicate = NSPredicate(format: "favourite == YES")
        fetchRequest.predicate = predicate
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
    
    // MARK: Life cycle
    override func viewWillAppear(_ animated: Bool) {
        setupFetchedResultsController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        let tabBarController = tabBarController as! TabBarViewController
        dataController = tabBarController.dataController
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
    
    // MARK:  Table View Delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = fetchedResultsController.fetchedObjects else {return TabelListCell()}
        
        let station = model[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableListCell", for: indexPath) as! TabelListCell
        
        // Configure cell
        cell.textPreviewLabel.text = station.commonName
        cell.detailLabel.text = "Available bikes: \(station.numberOfBikes)"
        
        return cell
    }

}
