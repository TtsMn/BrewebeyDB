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
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = true
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.placeholder = "Enter here for searching"
        
        searchController.searchBar.rx.text.orEmpty
            .bind(to: self.beersViewModel.searchText)
            .disposed(by: self._disposeBag)
        
        searchController.searchBar.rx.cancelButtonClicked.subscribe(onNext: {
            self.beersViewModel.changeDataSource()
        }).disposed(by: self._disposeBag)
         
        let segmentedControl = UISegmentedControl(items: ["Beers", "Bookmarks"])
        segmentedControl.selectedSegmentIndex = 0
        self.navigationItem.titleView = segmentedControl
        segmentedControl.rx.value.asDriver().drive(onNext: { (val) in
            self.beersViewModel.changeDataSource(source: val == 1 ? .bookmarks : .api)
        }).disposed(by: self._disposeBag)

    }
    
    func configureTableView() -> Void {
        self.beersViewModel.data.bind(to: self.tableView.rx.items(cellIdentifier: self._cellReuseIdentifer, cellType: BeerTableViewCell.self)) { row, beer, cell in
            cell.beer = beer
            cell.ttlLabel?.text = beer.name
            cell.loadThumbnail()
            
            print("\(row) - \(self.beersViewModel.data.value.count)")
            if self.beersViewModel.data.value.count - 20 < row {
                self.beersViewModel.nextPage()// TOFIX: the code downloads fucking huge of count pages, bcs it works asynk
            }
        }.disposed(by: _disposeBag)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBeerInfo",
            let beerVC = segue.destination as? BeerInfoViewController,
            let cell = sender as? BeerTableViewCell {
            beerVC.beer = cell.beer
            if self.beersViewModel._dataSource == .bookmarks {
                beerVC.updateListHandler = {[weak self] in
                    self?.beersViewModel.changeDataSource()
                }
            }
        }
    }

}
