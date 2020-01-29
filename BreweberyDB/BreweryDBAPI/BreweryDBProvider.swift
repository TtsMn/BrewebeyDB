
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

class BreweryDBProvider {
    
    public static let shared = BreweryDBProvider()
    private let provider = MoyaProvider<BreweryDBService>()
    
//    private static func _request<T: Codable>(requestParams: BreweryDBService) -> Driver<[T]> {
//        return provider.rx.request(requestParams)
//            .filterSuccessfulStatusAndRedirectCodes()
//            .map(BDBResponse<T>.self)
//            .filter({ (val) -> Bool in
//                val.status=="success"
//            }).map { (val) -> [T] in
//                (val.data ?? [])
//        }.asDriver(onErrorJustReturn: [])
//    }
//    _request(requestParams: .beers(page: page), type: BDBBeerResponse.self)
    
    private func _beer_request(requestParams: BreweryDBService) -> Driver<[BDBBeerResponse]> {
        return provider.rx.request(requestParams)
            .filterSuccessfulStatusAndRedirectCodes()
            .map(BDBResponse<BDBBeerResponse>.self)
            .filter({ (val) -> Bool in
                val.status=="success"
            }).map { (val) -> [BDBBeerResponse] in
                (val.data ?? [])
        }.asDriver(onErrorJustReturn: [])
    }
    
    private func _brewery_request(requestParams: BreweryDBService) -> Driver<[BDBBeerResponse]> {
        return provider.rx.request(requestParams)
            .filterSuccessfulStatusAndRedirectCodes()
            .map(BDBResponse<BDBBeerResponse>.self)
            .filter({ (val) -> Bool in
                val.status=="success"
            }).map { (val) -> [BDBBeerResponse] in
                print("\(val.data?.count)")//temp
                return (val.data ?? [])
        }.asDriver(onErrorJustReturn: [])
    }
    
    func getBeer(beerId: String, page: Int=1) -> Driver<[BDBBeerResponse]> {
        print("\(#function)")
        return _beer_request(requestParams: .beer(beerId: beerId, page: page))
    }
    
    func getBeers(page: Int=1) -> Driver<[BDBBeerResponse]> {
        print("\(#function)")
        return _beer_request(requestParams: .beers(page: page))
    }
    
    func getBeersFetch(beerName: String, page: Int=1) -> Driver<[BDBBeerResponse]> {
        return _beer_request(requestParams: .beersFetch(beerName: beerName, page: page))
    }
    
    func getBrewery(breweryId: String, page: Int=1) -> Driver<[BDBBeerResponse]> {
        return _brewery_request(requestParams: .brewery(breweryId: breweryId, page: page))
    }
    
    func getBreweries(latitude: Float, longitude: Float, page: Int=1) -> Driver<[BDBBeerResponse]> {
        return _brewery_request(requestParams: .breweries(latitude: latitude, longitude: longitude, page: page))
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

