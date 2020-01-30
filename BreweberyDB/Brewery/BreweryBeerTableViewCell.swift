//
//  BreweryBeerTableViewCell.swift
//  BreweberyDB
//
//  Created by Tyts on 30.01.2020.
//  Copyright © 2020 Tyts&Co. All rights reserved.
//

import UIKit

class BreweryBeerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var ttlLabel: UILabel!
    
    private let _provider = BreweryDBProvider<BDBBeerResponse>()
    public var beer: BDBBeerResponse? = nil
    
    func loadThumbnail() -> Void {
        if let lbls = self.beer?.labels,
            let imageURLString = lbls.icon {
            self._provider.download(url: imageURLString) { (img) in
                self.icon.image = img
            }
        }
    }
}
