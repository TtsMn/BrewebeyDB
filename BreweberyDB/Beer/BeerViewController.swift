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

class BeerViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let _searchController = UISearchController(searchResultsController: nil)
    private let _segmentedControl = UISegmentedControl(items: ["Beers", "Bookmarks"])
    
    private let _cellReuseIdentifer = "beerCell"

    private var _viewModel: BeerViewModel<Beer>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self._viewModel = BeerViewModel(typeOfData: .beer)
        self._configureNavigationBar()
        self._configureTableView()
        
        definesPresentationContext = true
    }
    
    private func _configureNavigationBar() -> Void {
       
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.searchController = _searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self._searchController.obscuresBackgroundDuringPresentation = false
        self._searchController.searchBar.showsCancelButton = true
        self._searchController.searchBar.placeholder = "Enter here for searching"
        
        self._searchController.searchBar.rx.text.orEmpty
            .bind(to: self._viewModel.searchText)
            .disposed(by: self._viewModel.disposeBag)
        
        self._searchController.searchBar.rx.cancelButtonClicked.subscribe(onNext: {
            self._viewModel.changeDataSource()
        }).disposed(by: self._viewModel.disposeBag)

        self._segmentedControl.selectedSegmentIndex = 0
        self.navigationItem.titleView = self._segmentedControl
        self._segmentedControl.rx.value.asDriver().drive(onNext: { (val) in
            self._viewModel.changeDataSource(source: val == 1 ? .bookmarks : .api)
        }).disposed(by: self._viewModel.disposeBag)

    }
    
    private func _configureTableView() -> Void {
        
        self._viewModel.data.bind(to: self.tableView.rx.items(cellIdentifier: self._cellReuseIdentifer, cellType: BeerTableViewCell.self)) { row, beer, cell in
            cell.beer = beer
            cell.ttlLabel?.text = beer.nameDisplay
            cell.configureImage()

            self._viewModel.numberOfShownCells.onNext(row)
        }.disposed(by: _viewModel.disposeBag)
        
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBeerInfo",
            let beerVC = segue.destination as? BeerInfoViewController,
            let cell = sender as? BeerTableViewCell {
            beerVC.beer = cell.beer
            if self._viewModel.dataSource == .bookmarks {
                beerVC.updateListHandler = {[weak self] in
                    self?._viewModel.changeDataSource()
                }
            }
        }
    }

}
