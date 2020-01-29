//
//  BeersViewController.swift
//  BreweberyDB
//
//  Created by Tyts on 29.01.2020.
//  Copyright © 2020 Tyts&Co. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BeersViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let cellReuseIdentifer = "beerCell"
    private let disposeBag = DisposeBag()
    private var beersViewModel: BeersViewModel!
    private var currentBeer: BDBBeerResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        configureNavigationBar()
        configureTableView()

        // Do any additional setup after loading the view.
    }
    
    func configureNavigationBar() -> Void {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.titleView = searchController.searchBar
//        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        //        searchController.automaticallyShowsCancelButton = true
        //        searchController.searchBar.placeholder = "Enter beer name for fetching."
        //        searchController.searchBar.rx.text.orEmpty
        //            .bind(to: self.beersViewModel.searchText)
        //            .disposed(by: disposeBag)
        
        //        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    
    
    func configureTableView() -> Void {
        
        
        
        let items = Observable.just(
            (0..<20).map { "\($0)" }
        )
        
        items
            .bind(to: self.tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element) @ row \(row)"
        }
        .disposed(by: disposeBag)
        
//        self.beersViewModel.data.drive(self.tableView.rx.items(cellIdentifier: cellReuseIdentifer, cellType: BeersTableViewCell.self)) { _, beer, cell in
//            cell.beer = beer
//            cell.nameOfBeer.text = beer.name
//            cell.descriptionOfBeer?.text? = beer.nameDisplay
//        }.disposed(by: disposeBag)
        
        //        tableView.rx.modelSelected(BDBBeerResponse.self).subscribe(onNext: { [weak self] val in
        //
        //            guard let strongSelf = self else { return }
        //
        //            guard let beerVC = strongSelf.storyboard?.instantiateViewController(identifier: "beerInfoVC") as? BeerViewController
        //                else { fatalError(" vc doesn't create")}
        //
        //            beerVC.beer = val
        //            strongSelf.navigationController?.pushViewController(beerVC, animated: true)
        //        }).disposed(by: disposeBag)
    }
    

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBeerInfo",
            let beerVC = segue.destination as? BeerViewController,
            let cell = sender as? BeerTableViewCell{
            beerVC.beer = cell.beer
        }
    }
    
    
}
