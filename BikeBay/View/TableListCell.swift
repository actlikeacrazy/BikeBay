//
//  TableListCell.swift
//  BikeBay
//
//  Created by Aleksandrs Trubacs on 13/09/2022.
//

import Foundation
import UIKit

internal final class TabelListCell: UITableViewCell, Cell {
    
    @IBOutlet weak var textPreviewLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textPreviewLabel.text = nil
        detailLabel.text = nil
    }
}
