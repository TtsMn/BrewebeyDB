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
    
    private let _provider = BreweryDBProvider<BDBBeerResponse>()
    public var beer: BDBBeerResponse? = nil
    
    func loadThumbnail() -> Void {
        if let lbls = self.beer?.labels,
            let imageURLString = lbls.icon {
            self._provider.download(url: imageURLString) { (img) in
                self.imageCell.image = img
            }
        }
    }
}
