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
    
    private let _cellReuseIdentifer = "beerCell"
    private let _disposeBag = DisposeBag()
    private let _beerViewModel = BeerViewModel<BDBBeerResponse>(typeOfData: BDBBeerResponse.type())
    private let _provider = BreweryDBProvider<BDBBeerResponse>()
    public var brewery: BDBBreweryResponse? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        self.navigationItem.title = brewery?.name
        self._configureImage()
    }

    func configureTableView() -> Void {
        self._beerViewModel.data.bind(to: self.tableView.rx.items(cellIdentifier: self._cellReuseIdentifer, cellType: BreweryBeerTableViewCell.self)) { row, beer, cell in
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
        if segue.identifier == "showBeerInfo",
            let beerVC = segue.destination as? BeerInfoViewController,
            let cell = sender as? BreweryBeerTableViewCell {
            beerVC.beer = cell.beer
        }
    }
}
