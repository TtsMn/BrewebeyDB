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
    
    private let _provider = BreweryDBProvider<BDBBeerResponse>()
    private let _disposeBag = DisposeBag()
    private var _bookmarkService: BookmarkService<BDBBeerResponse>!
    private var _bookmark: BehaviorRelay<Bool>!
    var beer:BDBBeerResponse! = nil
    var updateListHandler: () -> () = {  }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = self.beer?.name
        self.nameLabel.text = self.beer?.nameDisplay
        self.descriptionLabel.text! = self.beer?.description ?? "description is missing."

        self._configureBookmark()
        self._configureImage()
        self.descriptionLabel.sizeToFit()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.updateListHandler()
        
    }
    
    private func _configureBookmark() {
        
        self._bookmarkService = BookmarkService()
        
        self._bookmark = BehaviorRelay<Bool>(value: self._bookmarkService.get(data: self.beer))
        
        self._bookmark.subscribe(onNext: { (val) in
            self._bookmarkService.set(data: self.beer, value: val)
            self.bookmarkButton.image = UIImage(systemName: val ? "bookmark.fill" : "bookmark")
        }).disposed(by: _disposeBag)
        
        self.bookmarkButton.rx.tap.asDriver().drive(onNext: {
            self._bookmark.accept(!self._bookmark.value)
        }).disposed(by: self._disposeBag)

    }
    
    private func _configureImage() -> Void {
        
        if let lbls = self.beer?.labels,
            let imageURLString = lbls.large {
            self._provider.download(url: imageURLString) { (img) in
                self.icon.image = img
            }
        }
    }
}

