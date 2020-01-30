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
        
    private let _disposeBag = DisposeBag()
    private var _breweryDBProvider = BreweryDBProvider<BDBBeerResponse>()
    public var data = BehaviorRelay<[BDBBeerResponse]>(value: [BDBBeerResponse]())
    
    init() {
        
    }
    
    public func request(breweryId: String) {
        
        self._breweryDBProvider
            .getBreweryBeer(breweryId:  breweryId)
            .subscribe(onNext: { response in
                if let response = response.data {
                        self.data.accept(response)
                    }
            }).disposed(by: self._disposeBag)
    }
}
