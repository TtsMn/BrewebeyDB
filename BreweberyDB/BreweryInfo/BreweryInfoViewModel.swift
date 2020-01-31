//
//  BreweryInfoViewModel.swift
//  BreweberyDB
//
//  Created by Tyts on 30.01.2020.
//  Copyright © 2020 Tyts&Co. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class BreweryInfoViewModel {
        
    public let disposeBag = DisposeBag()
    private var _dataProvider = MoyaProvider<BreweryDBService<Brewery>>()
//    private var _breweryDBProvider = BreweryDBProvider<Brewery>()
    public var data = BehaviorRelay<[Beer]>(value: [Beer]())
    
    init(breweryId: String) {
        
        self.request(breweryId: breweryId)
        
    }
    
    public func request(breweryId: String) {

        self._dataProvider.rx
            .request(.getListFor(id: breweryId, type: .beer))
            .filterSuccessfulStatusAndRedirectCodes()
            .map(Response<Beer>.self)
            .filter { $0.status=="success" }
            .asObservable()
            .subscribe(onNext: { response in
                if let data = response.data {
                    self.data.accept(data)
                }
            }).disposed(by: self.disposeBag)
    }
}
