//
//  BreweryDBProvider.swift
//  BreweberyDB
//
//  Created by Tyts on 01.02.2020.
//  Copyright © 2020 Tyts&Co. All rights reserved.
//

import Foundation
import RxSwift
import Moya

class BreweryDBProvider<T: Codable & DataProtocol> {
    
    fileprivate let _dataProvider = MoyaProvider<BreweryDBService<T>>()
     
    private func request(requestParams: BreweryDBService<T>) -> Observable<Response<T>> {
        return self._dataProvider.rx.request(requestParams)
            .filterSuccessfulStatusAndRedirectCodes()
            .map(Response<T>.self)
            .filter({ (val) -> Bool in
                print("\(requestParams) - \(val.status)") // print requests here
                return val.status=="success"
            }).asObservable()
    }

    func getData(id: String, params: [String:Any]?=nil) -> Observable<Response<T>> {
        
        return self.request(requestParams: .getData(id: id, params: params))
        
    }
    
    func getList(page: Int=1, params: [String:Any]?=nil) -> Observable<Response<T>> {
        
        return self.request(requestParams: .getList(page: page, params: params))
        
    }
    
    func getListFor(id: String, type: DataType, params: [String:Any]?=nil) -> Observable<Response<T>> {
        
        return self.request(requestParams: .getListFor(id: id, type: type, params: params))
        
    }
    
    func search(searchString: String, params: [String:Any]?=nil) -> Observable<Response<T>> {
        
        return self.request(requestParams: .search(searchString: searchString, params: params))
        
    }
    
}

//extension BreweryDBService where T == Brewery {
//    
//    func geo(latitude: Float, longitude: Float, radius: Int=100, params: [String:Any]?=nil) -> Observable<Response<T>> {
//        
//        self._
//        
//    }
//    
//}

