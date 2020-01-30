//
//  BreweryViewController.swift
//  BreweberyDB
//
//  Created by Tyts on 30.01.2020.
//  Copyright © 2020 Tyts&Co. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BreweryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let _cellReuseIdentifer = "breweryCell"
    private let _disposeBag = DisposeBag()
    private let _breweryViewModel = BreweryViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self._configureTableView()
        
    }
    
    private func _configureTableView() -> Void {
        
        self._breweryViewModel.data.bind(to: self.tableView.rx.items(cellIdentifier: self._cellReuseIdentifer, cellType: BreweryTableViewCell.self)) { row, brewery, cell in
            cell.brewery = brewery
            cell.textLabel?.text = brewery.name
        }.disposed(by: self._disposeBag)
        
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBreweryInfo",
            let beerVC = segue.destination as? BreweryInfoViewController,
            let cell = sender as? BreweryTableViewCell {
            beerVC.brewery = cell.brewery
        }
    }

}
