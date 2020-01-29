//
//  BreweryDB.swift
//  BeerWiki
//
//  Created by Tyts on 26.01.2020.
//  Copyright © 2020 Tyts&Co. All rights reserved.
//

import Foundation
import Moya

enum BreweryDBService {
    static private let API_URL = "https://sandbox-api.brewerydb.com/v2"
    static private let API_KEY = "9afa41b681412a56a35f4b1a1f523adb"
    
    case beer(beerId: String, page: Int=1)
    case beers(page: Int=1)
    case beersFetch(beerName: String, page: Int=1)
    case brewery(breweryId: String, page: Int=1)
    case breweries(latitude: Float, longitude: Float, page: Int=1)
    
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
        case .beer(let beerId):
            return "/beer/\(beerId)"
        case .beers, .beersFetch:
            return "/beers"
        case .brewery(let breweryId):
            return "/brewery/\(breweryId)"
        case .breweries:
            return "/breweries"
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
        case .beer(_, let page), .beers(let page), .brewery(_, let page):
            return .requestParameters(parameters: ["key": BreweryDBService.API_KEY,
                                                   "p": page],
                                      encoding: encoding)
        case .beersFetch(let beerName, let page):
            return .requestParameters(parameters: ["key": BreweryDBService.API_KEY,
                                                   "name": beerName,
                                                   "p": page],
                                      encoding: encoding)
        case .breweries(let latitude, let longitude, let page):
            return .requestParameters(parameters: ["key": BreweryDBService.API_KEY,
                                                   "latitude": latitude,
                                                   "longitude": longitude,
                                                   "p": page],
                                      encoding: encoding)
        case .download:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
