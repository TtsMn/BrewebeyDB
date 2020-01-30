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
    private let _disposeBag = DisposeBag()
    private var beersViewModel: BeerViewModel<BDBBeerResponse>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        beersViewModel = BeerViewModel(typeOfData: .beer)
        configureNavigationBar()
        configureTableView()
        
        definesPresentationContext = true
    }
    
    func configureNavigationBar() -> Void {
       
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.searchController = _searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self._searchController.obscuresBackgroundDuringPresentation = false
        self._searchController.searchBar.showsCancelButton = true
        self._searchController.searchBar.placeholder = "Enter here for searching"
        
        self._searchController.searchBar.rx.text.orEmpty
            .bind(to: self.beersViewModel.searchText)
            .disposed(by: self._disposeBag)
        
        self._searchController.searchBar.rx.cancelButtonClicked.subscribe(onNext: {
            self.beersViewModel.changeDataSource()
        }).disposed(by: self._disposeBag)

        self._segmentedControl.selectedSegmentIndex = 0
        self.navigationItem.titleView = self._segmentedControl
        self._segmentedControl.rx.value.asDriver().drive(onNext: { (val) in
            self.beersViewModel.changeDataSource(source: val == 1 ? .bookmarks : .api)
        }).disposed(by: self._disposeBag)

    }
    
    func configureTableView() -> Void {
        
        self.beersViewModel.data.bind(to: self.tableView.rx.items(cellIdentifier: self._cellReuseIdentifer, cellType: BeerTableViewCell.self)) { row, beer, cell in
            cell.beer = beer
            cell.ttlLabel?.text = beer.nameDisplay
            cell.loadThumbnail()

            if self.beersViewModel.data.value.count - 20 < row {
                self.beersViewModel.nextPage()
            }
        }.disposed(by: _disposeBag)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBeerInfo",
            let beerVC = segue.destination as? BeerInfoViewController,
            let cell = sender as? BeerTableViewCell {
            beerVC.beer = cell.beer
            if self.beersViewModel.dataSource == .bookmarks {
                beerVC.updateListHandler = {[weak self] in
                    self?.beersViewModel.changeDataSource()
                }
            }
        }
    }

}
