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
import Moya

class BreweryViewModel {
    
    private let _disposeBag = DisposeBag()
//    private var _breweryDBProvider = BreweryDBProvider<Location>()
    private let _dataProvider = MoyaProvider<BreweryDBService<Location>>()
    public var data = BehaviorRelay<[Brewery]>(value: [Brewery]())
 
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
                
                self._dataProvider.rx
                        .request(.geo(latitude: Float(location.coordinate.latitude), longitude: Float(location.coordinate.longitude)))
                        .filterSuccessfulStatusAndRedirectCodes()
                        .map(Response<Location>.self)
                        .filter { $0.status=="success" }
                        .asObservable().subscribe(onNext: { (response) in

                    if let data = response.data {
                        var breweries = [Brewery]()
                        data.forEach { (location) in
                            if let brewery = location.brewery {
                                breweries.append(brewery)
                            }
                        }
                        self.data.accept(breweries)
                    }
                }).disposed(by: self._disposeBag)
        }).disposed(by: self._disposeBag)
        
    }
    
}
