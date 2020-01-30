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
    private var _breweryDBProvider = BreweryDBProvider<Beer>()
    public var data = BehaviorRelay<[Beer]>(value: [Beer]())
    
    init(breweryId: String) {
        
        self.request(breweryId: breweryId)
        
    }
    
    public func request(breweryId: String) {
        
        self._breweryDBProvider
            .getBreweryBeer(type: .brewery, breweryId:  breweryId)
            .subscribe(onNext: { response in
                if let data = response.data {
                    print(data.count)
                        self.data.accept(data)
                    }
            }).disposed(by: self.disposeBag)
    }
}
