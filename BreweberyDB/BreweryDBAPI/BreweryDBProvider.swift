
//
//  APIProvider.swift
//  BeerWiki
//
//  Created by Tyts on 27.01.2020.
//  Copyright © 2020 Tyts&Co. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class BreweryDBProvider<T: Codable & BDBDataProtocol>{
    
    private let provider = MoyaProvider<BreweryDBService>()

    private func _request(requestParams: BreweryDBService) -> Observable<BDBResponse<T>> {
        return provider.rx.request(requestParams)
            .filterSuccessfulStatusAndRedirectCodes()
            .map(BDBResponse<T>.self)
            .filter({ (val) -> Bool in
                print(val.status)
                return val.status=="success"
            }).asObservable()
    }
    
    func getBeer(beerIds: [String]) -> Observable<BDBResponse<T>> {
        return self._request(requestParams: .beer(beerIds: beerIds))
    }
    
    func getBeers(page: Int=1) -> Observable<BDBResponse<T>> {
        return self._request(requestParams: .beers(page: page))
    }
    
    func search(type:typeOfData, searchString: String, page: Int=1) -> Observable<BDBResponse<T>> {
        return self._request(requestParams: .search(type: type, searchString: searchString, page: page))
    }
    
    func getBreweryBeer(breweryId: String) -> Observable<BDBResponse<T>> {
        return self._request(requestParams: .breweryBeer(type: T.type(), breweryId: breweryId))
    }
    
    func getBreweries(latitude: Float, longitude: Float) -> Observable<BDBResponse<T>> {
        return self._request(requestParams: .breweries(latitude: latitude, longitude: longitude))
    }
    
    func download(url: String, completionHandler: @escaping (UIImage) -> ()) -> Void {//.subscribe {
        //        self.provider.rx.request( BreweryDBService.download(url: url))
        //            .mapImage()
        //            .subscribe(onSuccess: { (img) in
        //                completionHandler(img)
        //            }, onError: { (ree) in
        //                print(ree)
        //            }).disposed(by: DisposeBag())
        
        
        let url = URL(string: url)
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print("Error fetching the image! 😢")
            } else {
                if let data = data,
                    let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completionHandler(image)
                    }
                } else {
                    print("Error loading image");
                }
            }
        }.resume()
        
    }
    
}

