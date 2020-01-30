//
//  BreweryViewModel.swift
//  BreweberyDB
//
//  Created by Tyts on 30.01.2020.
//  Copyright © 2020 Tyts&Co. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation
import RxCoreLocation

class BreweryViewModel {
    
    private let _disposeBag = DisposeBag()
    private var _breweryDBProvider = BreweryDBProvider<DBDLocationResponse>()
//    private var _beerDBProvider = BreweryDBProvider<BDBBeerResponse>()
    public var data = BehaviorRelay<[BDBBreweryResponse]>(value: [BDBBreweryResponse]())
 
    init() {
        
        configureLocationManager()
    }
        
    func configureLocationManager() -> Void {
       
        let manager = CLLocationManager()

        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        manager.rx
            .location
            .throttle(TimeInterval(10), scheduler: MainScheduler.instance)
            .subscribe(onNext: { location in
            guard let location = location else { return }
                self._breweryDBProvider.getBreweries(latitude: Float(location.coordinate.latitude), longitude: Float(location.coordinate.longitude)).subscribe(onNext: { (response) in

                    if let data = response.data {
                        var breweries = [BDBBreweryResponse]()
                        data.forEach { (location) in
                            breweries.append(location.brewery)
                        }
                        self.data.accept(breweries)
                    }
                }).disposed(by: self._disposeBag)
        })
            .disposed(by: self._disposeBag)

        
    }
    
}
