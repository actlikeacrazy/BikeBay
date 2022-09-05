//
//  bikeCell.swift
//  BikeBay
//
//  Created by Aleksandrs Trubacs on 31/08/2022.
//

import Foundation
import UIKit

 class BikeCell: UICollectionViewCell, Cell {
     
    // MARK: Outlets

    
    override func prepareForReuse() {
        self.contentView.layer.cornerRadius = 2.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        super.prepareForReuse()
    }
}

protocol Cell: AnyObject {
    /// A default reuse identifier for the cell class
    static var defaultReuseIdentifier: String { get }
}

extension Cell {
    static var defaultReuseIdentifier: String {
        // Should return the class's name, without namespacing or mangling.
        // This works as of Swift 3.1.1, but might be fragile.
        return "\(self)"
    }
}
