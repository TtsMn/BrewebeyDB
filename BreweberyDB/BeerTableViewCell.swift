//
//  BeerTableViewCell.swift
//  BrewebeyDB
//
//  Created by Tyts on 28.01.2020.
//  Copyright © 2020 Tyts&Co. All rights reserved.
//

import UIKit

class BeerTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
   
    var beer: BDBBeerResponse? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadThumbnail() -> Void {
//        if let lbls = self.beer?.labels,
//            let imageURLString = lbls.icon {
//            BreweryDBProvider.shared.download(url: imageURLString) { (img) in
//                self.imageViewCell.image = img
//            }
//        } else {
//            self.imageViewCell.image = UIImage(named: "noimage")
//        }
    }

}
