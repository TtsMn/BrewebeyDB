//
//  BeerTableViewController.swift
//  BrewebeyDB
//
//  Created by Tyts on 28.01.2020.
//  Copyright © 2020 Tyts&Co. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BeersViewController: UIViewController{
      
//    let entries = Observable.just([BData(title: "Easiest", image: "green_circle"),
//                    BData(title: "Intermediate", image: "blue_square"),
//                    BData(title: "Advanced", image: "black_diamond"),
//                    BData(title: "Expert Only", image: "double_black_diamond")])
    
    let searchController = UISearchController(searchResultsController: nil)
    let segmetedController = UISegmentedControl(items: ["Search", "Bookmarks"])
  
    private let reuseCellIdentifier = "beerCell"
    private let disposeBag = DisposeBag()
    private var beersViewModel: BeersViewModel!
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.beersViewModel = BeersViewModel()
        self.configureNavigationBar()
        configureTableView()
    }
    
        
    private func configureNavigationBar() -> Void {

        self.definesPresentationContext = true
        self.navigationItem.titleView = segmetedController
        self.navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Enter beer name for fetching."
        searchController.searchBar.rx.text.orEmpty
            .bind(to: self.beersViewModel.searchText)
            .disposed(by: disposeBag)
    }
    
    func configureTableView() -> Void {

    print("\(#function)")
        
        let items = Observable.just(
            (0..<20).map { "\($0)" }
        )
                    print("\(#function)")

        items
            .bind(to: tableView.rx.items(cellIdentifier: reuseCellIdentifier, cellType: UITableViewCell.self)) { (row, element, cell) in
            print("\(#function)")
                cell.textLabel?.text = "\(element) @ row \(row)"
            }
            .disposed(by: disposeBag)
            print("\(#function)")
        
//        var dataSource : PublishSubject<[String]> = PublishSubject()
//
//        dataSource.asObservable().bind(to: self.tableView.rx.items) { (collectionView, row, element ) in
//            print("\(#function)")
//            let cell = collectionView.dequeueReusableCell(withIdentifier: self.reuseCellIdentifier, for: IndexPath(row : row, section : 0))
//
//            return cell
//
//        }.disposed(by: disposeBag)
//
//        dataSource.onNext(["blah", "blah", "blah"])
        
        
//        self.entries.bind(to: tableView.rx.items(cellIdentifier: reuseCellIdentifier)) { _, beer, cell in
//                print("\(#function)")
//
//                cell.textLabel?.text = beer.title
//                cell.detailTextLabel?.text = beer.image
//            }.disposed(by: disposeBag)
        
//        self.beersViewModel.data.drive(self.tableView.rx.items(cellIdentifier: reuseCellIdentifier)) { _, beer, cell in
//
//            print("\(#function)")
//
////            cell.beer = beer
//            cell.textLabel?.text = beer.name
//            cell.detailTextLabel?.text = beer.nameDisplay
//        }.disposed(by: disposeBag)

//        self.tableView.rx.modelSelected(BDBBeerResponse.self).subscribe(onNext: { val in
//            print("\(#function)")
//        }).disposed(by: disposeBag)
        
        
    }
       
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showBeerInfo",
            let beerVC = segue.destination as? BeerViewController,
            let beerCell = sender as? BeerTableViewCell {
            beerVC.beer = beerCell.beer
        }
    }
    

}
