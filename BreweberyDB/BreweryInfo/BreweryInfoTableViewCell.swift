//
//  BreweryInfoTableViewCell.swift
//  BreweberyDB
//
//  Created by Tyts on 30.01.2020.
//  Copyright © 2020 Tyts&Co. All rights reserved.
//

import UIKit

class BreweryInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var ttlLabel: UILabel!
    
    public var beer: Beer? = nil
    
    public func configureImage() -> Void {
        if let labels = self.beer?.labels,
            let imageURLString = labels.icon {
            ImageProvider.image(url: imageURLString) { (image) in
                self.icon.image = image
            }
        }
    }
}
