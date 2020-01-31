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
    private var _viewModel: BreweryInfoViewModel? = nil
    public var brewery: Brewery? = nil
    
    override func viewDidLoad() {
        guard let brewery = self.brewery else { return }
       
        super.viewDidLoad()
        
        self._viewModel = BreweryInfoViewModel(breweryId: brewery.id)
        self.navigationItem.title = brewery.name
        self.configureTableView()
        self.configureImage()

    }

    private func configureTableView() -> Void {
        
        if let viewModel = self._viewModel {
            viewModel.data.bind(to: self.tableView.rx.items(cellIdentifier: self._cellReuseIdentifer, cellType: BreweryInfoTableViewCell.self)) { row, beer, cell in
                cell.beer = beer
                cell.ttlLabel?.text = beer.name
                cell.configureImage()
                
            }.disposed(by: viewModel.disposeBag)
        }
        
    }
    
    private func configureImage() -> Void {
        if let labels = self.brewery?.images,
            let imageURLString = labels.squareLarge {
            ImageProvider.image(url: imageURLString) { (image) in
                self.icon.image = image
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showBeerInfoFromBreweryInfo",
            let beerVC = segue.destination as? BeerInfoViewController,
            let cell = sender as? BreweryInfoTableViewCell {
            beerVC.beer = cell.beer
        }
    }
}
