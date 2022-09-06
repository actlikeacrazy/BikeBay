//
//  CollectionViewHeader.swift
//  BikeBay
//
//  Created by Aleksandrs Trubacs on 06/09/2022.
//

import Foundation
import UIKit

class CollectionViewHeader: UICollectionReusableView {
    
    // MARK: Outlets
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var subHeader: UILabel!
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        headerLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        subHeader.font = UIFont.systemFont(ofSize: 14, weight: .thin)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
