//
//  BreweryInfoViewController.swift
//  BreweberyDB
//
//  Created by Tyts on 30.01.2020.
//  Copyright © 2020 Tyts&Co. All rights reserved.
//

import UIKit
import RxSwift

class BreweryInfoViewController: UIViewController {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    private let _cellReuseIdentifer = "breweryBeerCell"
    private let _disposeBag = DisposeBag()
    private var _breweryInfoViewModel: BreweryInfoViewModel!
    private let _provider = BreweryDBProvider<BDBBeerResponse>()
    public var brewery: BDBBreweryResponse!
    
    override func viewDidLoad() {
        guard let brewery = self.brewery else { return }
        
        super.viewDidLoad()
        self._breweryInfoViewModel = BreweryInfoViewModel(breweryId: brewery.id)
        self.navigationItem.title = brewery.name
        self._configureTableView()
        self._configureImage()

    }

    private func _configureTableView() -> Void {
        self._breweryInfoViewModel.data.bind(to: self.tableView.rx.items(cellIdentifier: self._cellReuseIdentifer, cellType: BreweryBeerTableViewCell.self)) { row, beer, cell in
            cell.beer = beer
            cell.ttlLabel?.text = beer.name
            cell.loadThumbnail()

        }.disposed(by: self._disposeBag)
    }
    
    private func _configureImage() -> Void {
        
        if let lbls = self.brewery?.images,
            let imageURLString = lbls.squareLarge {
            self._provider.download(url: imageURLString) { (img) in
                self.icon.image = img
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBeerInfoFromBreweryInfo",
            let beerVC = segue.destination as? BeerInfoViewController,
            let cell = sender as? BreweryBeerTableViewCell {
            beerVC.beer = cell.beer
        }
    }
}
