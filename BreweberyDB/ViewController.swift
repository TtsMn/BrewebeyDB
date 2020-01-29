//
//  ViewController.swift
//  BreweberyDB
//
//  Created by Tyts on 29.01.2020.
//  Copyright © 2020 Tyts&Co. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let cellReuseIdentifer = "beerCell"
    let disposeBag = DisposeBag()
    private var beersViewModel: BeersViewModel!
    private var currentBeer: BDBBeerResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        beersViewModel = BeersViewModel()
        configureNavigationBar()
        configureTableView()
    }
    
    func configureNavigationBar() -> Void {
        
        let searchController = UISearchController(searchResultsController: nil)
//        self.navigationItem.titleView = searchController.searchBar
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.searchBar.rx.text.orEmpty
            .bind(to: self.beersViewModel.searchText)
            .disposed(by: disposeBag)
    }
    
    func configureTableView() -> Void {
        self.beersViewModel.data.drive(self.tableView.rx.items(cellIdentifier: "cell1", cellType: CollectionViewCellTest.self)) { _, beer, cell in
            cell.beer = beer
            cell.ttlLabel?.text = beer.name
            cell.dtlLabel?.text = beer.nameDisplay
            cell.loadThumbnail()
               }.disposed(by: disposeBag)

//        self.beersViewModel.data.drive(self.tableView.rx.items(cellIdentifier: cellReuseIdentifer, cellType: BeerTableViewCell.self)) { _, beer, cell in
//            cell.beer = beer
//            cell.nameLabel.text = beer.name
//            cell.detailLabel.text = beer.nameDisplay
//        }.disposed(by: disposeBag)
        
    }
    

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBeerInfo",
            let beerVC = segue.destination as? BeerViewController,
            let cell = sender as? CollectionViewCellTest{
            beerVC.beer = cell.beer
        }
    }

}
