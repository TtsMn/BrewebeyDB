//
//  BeerViewMolel.swift
//  BeerWiki
//
//  Created by Tyts on 28.01.2020.
//  Copyright © 2020 Tyts&Co. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class BeersViewModel {
    
    private let disposeBag = DisposeBag()
    public var searchText = PublishSubject<String>()
    public var data: Driver<[BDBBeerResponse]>
    
    init() {
        self.data = BreweryDBProvider.shared.getBeers()
        
        self.searchText
            .throttle(TimeInterval(0.3), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { (val) in
//                print("\(#function)")
                self.data = BreweryDBProvider.shared.getBeersFetch(beerName: val)
                print("\(val)")
            }).disposed(by: disposeBag)
    }
}
