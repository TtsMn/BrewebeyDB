//
//  BreweryDB.swift
//  BeerWiki
//
//  Created by Tyts on 26.01.2020.
//  Copyright © 2020 Tyts&Co. All rights reserved.
//

import Foundation
import Moya

enum typeOfData: String {
    case beer = "beer"
    case brewery = "brewery"
    case area = ""
}
enum BreweryDBService {
    static private let API_URL = "https://sandbox-api.brewerydb.com/v2"
    static private let API_KEY = "9afa41b681412a56a35f4b1a1f523adb"
    
    case beer(beerIds: [String])
    case beers(page: Int=1)
    case search(type: typeOfData, searchString: String, page: Int=1)
    case breweryBeer(type:typeOfData, breweryId: String)
    case breweries(latitude: Float, longitude: Float)
    
    case download(url: String)
}

extension BreweryDBService: TargetType {
    var baseURL: URL {
        switch self {
        case .download(let url):
            return URL(string: url)!
        default:
            return URL(string: BreweryDBService.API_URL)!
        }
    }
    
    var path: String {
        switch self {
        case .search:
            return "/search"
        case .beer, .beers:
            return "/beers"
        case .breweryBeer(let typeOfData, let breweryId):
            return "/\(typeOfData.rawValue)/\(breweryId)/beers"
        case .breweries:
            return "/search/geo/point"
        case .download:
            return ""
        }
    }
   
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
//        let authParams: [String: String] = ["key": BreweryDBService.API_KEY]
        let encoding = URLEncoding.default
        
        switch self {
            
        case .beer(let ids):
            return .requestParameters(parameters: ["key": BreweryDBService.API_KEY,
                                                       "ids": ids.joined(separator: ",")],
                                      encoding: encoding)
            
        case .beers(let page):
            return .requestParameters(parameters: ["key": BreweryDBService.API_KEY,
                                                   "p": page],
                                      encoding: encoding)
            
        case .search(let type, let searchString, let page):
            return .requestParameters(parameters: ["key": BreweryDBService.API_KEY,
                                                   "type": type.rawValue,
                                                   "q": searchString,
                                                   "p": page],
                                      encoding: encoding)
            
        case .breweries(let latitude, let longitude):
            return .requestParameters(parameters: ["key": BreweryDBService.API_KEY,
                                                   "lat": String(latitude),
                                                   "lng": String(longitude),
                                                   "radius": 100],
                                      encoding: encoding)

        case .breweryBeer(_):
            return .requestParameters(parameters: ["key": BreweryDBService.API_KEY],
                                      encoding: encoding)
            
        case .download:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
