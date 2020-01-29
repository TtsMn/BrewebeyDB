//
//  ViewController.swift
//  BrewebeyDB
//
//  Created by Tyts on 28.01.2020.
//  Copyright © 2020 Tyts&Co. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BeerViewController: UIViewController {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIBarButtonItem!
    
    var beer:BDBBeerResponse? = nil
    var Bookmarked = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = self.beer?.name
        self.nameLabel.text = self.beer?.nameDisplay
        self.descriptionLabel.text! = self.beer?.description ?? "description is missing."
        
        
        
        configureBookmarkButton()
        setImageToImageView()
    }

    @IBAction func bookmarkBeer(_ sender: Any) {
        self.Bookmarked = !self.Bookmarked
        configureBookmarkButton()
    }
    
    func configureBookmarkButton() -> Void {
        self.bookmarkButton.image = UIImage(systemName: self.Bookmarked ? "bookmark.fill" : "bookmark")
    }
    
    func setImageToImageView() {
        if let lbls = self.beer?.labels,
            let imageURLString = lbls.medium {
            BreweryDBProvider.shared.download(url: imageURLString) { (img) in
                self.icon.image = img
            }
        } else {
            self.icon.image = UIImage(named: "noimage")
        }
    }

}

