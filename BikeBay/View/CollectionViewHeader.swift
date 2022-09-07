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
        self.layer.cornerRadius = 14.0
        let blurEffect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.layer.bounds
        blurView.autoresizingMask = .flexibleWidth
        self.addSubview(blurView)
        self.sendSubviewToBack(blurView)
        
        headerLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        subHeader.font = UIFont.systemFont(ofSize: 14, weight: .thin)
        subHeader.textColor = .darkGray
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
