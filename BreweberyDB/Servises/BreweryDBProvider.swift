
//
//  APIProvider.swift
//  BeerWiki
//
//  Created by Tyts on 27.01.2020.
//  Copyright © 2020 Tyts&Co. All rights reserved.
//

import Foundation
import RxSwift
import Moya

class BreweryDBProvider<T: Codable & DataProtocol>{
    
    private let _dataProvider = MoyaProvider<BreweryDBService>()

    private func _requestData(requestParams: BreweryDBService) -> Observable<Response<T>> {
        return self._dataProvider.rx.request(requestParams)
            .filterSuccessfulStatusAndRedirectCodes()
            .map(Response<T>.self)
            .filter({ (val) -> Bool in
                print("status: \(val.status) / params: \(requestParams) / results: \(val.data?.count ?? 0)") // print requests here
                return val.status=="success"
            }).asObservable()
    }
    
    func getBeer(beerIds: [String]) -> Observable<Response<T>> {
        return self._requestData(requestParams: .beer(beerIds: beerIds))
    }
    
    func getBeers(page: Int=1) -> Observable<Response<T>> {
        return self._requestData(requestParams: .beers(page: page))
    }
    
    func search(type:typeOfData, searchString: String, page: Int=1) -> Observable<Response<T>> {
        return self._requestData(requestParams: .search(type: type, searchString: searchString, page: page))
    }
    
    func getBreweryBeer(type: typeOfData, breweryId: String) -> Observable<Response<T>> {
        return self._requestData(requestParams: .breweryBeer(type: type, breweryId: breweryId))
    }
    
    func getBreweries(latitude: Float, longitude: Float) -> Observable<Response<T>> {
        return self._requestData(requestParams: .breweries(latitude: latitude, longitude: longitude))
    }
    
}

