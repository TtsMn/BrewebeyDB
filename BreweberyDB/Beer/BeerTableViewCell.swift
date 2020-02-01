//
//  CollectionViewCellTest.swift
//  BreweberyDB
//
//  Created by Tyts on 29.01.2020.
//  Copyright © 2020 Tyts&Co. All rights reserved.
//

import UIKit

class BeerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var ttlLabel: UILabel!

    public var beer: Beer? = nil
    
    override func prepareForReuse() {
        self.imageCell.image = UIImage(named: "noImage-1")
    }
    
    public func configureImage() -> Void {
        if let imageURLString = self.beer?.getImageUrl(size: .icon) {
            ImageProvider.image(url: imageURLString, iv: self.imageCell)
        }
    }
}
