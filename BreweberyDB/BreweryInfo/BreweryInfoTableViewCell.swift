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
    
    override func prepareForReuse() {
        self.icon.image = UIImage(named: "noImage-1")
    }
    
    public func configureImage() -> Void {
        if let imageURLString = self.beer?.getImageUrl(size: .icon) {
            ImageProvider.image(url: imageURLString, iv: self.icon)
        }
    }
}
