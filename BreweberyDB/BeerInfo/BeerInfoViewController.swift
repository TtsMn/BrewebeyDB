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

class BeerInfoViewController: UIViewController {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIBarButtonItem!

    private var _viewModel: BeerInfoViewModel!
    var beer:Beer!
    var updateListHandler: () -> () = {  }

    override func viewDidLoad() {
        guard let beer = self.beer else { return }
        
        super.viewDidLoad()

        self._viewModel = BeerInfoViewModel(data: beer)
        self._showUpData()
        self._configureImage()
        self._configureBookmark()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.updateListHandler()
        
    }
    
    private func _showUpData() {
            
        navigationItem.title = self.beer?.name
        self.nameLabel.text = self.beer?.nameDisplay
        self.descriptionLabel.text! = self.beer?.description ?? "description is missing."
        self.descriptionLabel.sizeToFit()
        
    }
    
    private func _configureBookmark() {

        self._viewModel.bookmark.subscribe(onNext: { (val) in
            self._viewModel.bookmarkService.set(data: self.beer, value: val)
            self.bookmarkButton.image = UIImage(systemName: val ? "bookmark.fill" : "bookmark")
        }).disposed(by: self._viewModel.disposeBag)
        
        self.bookmarkButton.rx.tap.asDriver().drive(onNext: {
            self._viewModel.bookmark.accept(!self._viewModel.bookmark.value)
        }).disposed(by: self._viewModel.disposeBag)

    }
    
    private func _configureImage() -> Void {
        // TODO: do smsthg with this
        if let labels = self.beer?.labels,
            let imageURLString = labels.large {
            
            ImageProvider.image(url: imageURLString) { (image) in
                self.icon.image = image
            }
        }
    }

}

