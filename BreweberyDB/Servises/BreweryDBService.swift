//
//  BreweryDB.swift
//  BeerWiki
//
//  Created by Tyts on 26.01.2020.
//  Copyright © 2020 Tyts&Co. All rights reserved.
//

import Foundation
import RxSwift
import Moya

struct BreweryDB {
    static let apiUrl: String = "https://sandbox-api.brewerydb.com/v2"
    static let apiKey: String = "9afa41b681412a56a35f4b1a1f523adb"
}

/// Represent API requests.
enum BreweryDBService<T: Codable & DataProtocol> {

    /// Return all data.
    case getData(id: String, params: [String:Any]?=nil)
    case getList(page: Int=1, params: [String:Any]?=nil)
    case getListFor(id: String, type: DataType, params: [String:Any]?=nil)
    case search(searchString: String, params: [String:Any]?=nil)
    
    /// Search only breweries, max radius is 100 km. Returns Location data type.
    case geo(latitude: Float, longitude: Float, radius: Int=100, params: [String:Any]?=nil)
    
}

extension BreweryDBService: TargetType {
    
    var baseURL: URL {
        switch self {
        default:
            return URL(string: BreweryDB.apiUrl)!
        }
    }
    
    var path: String {
        
        switch self {
        case .getList(_, _):
            return "/\(T.type.multiple)"
        case .getData(let id, _):
            return "/\(T.type.single)/\(id)" + ""
        case .getListFor(let id, let type, _):
            return "/\(T.type.single)/\(id)/\(type.multiple)"
        case .search:
            return "/search"
        case .geo:
            return "/search/geo/point"
        }
    }
   
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }

    var task: Task {
        let authParams: [String: Any] = ["key": BreweryDB.apiKey] // Binary operator '+' cannot be applied to two '[String : Any]' operands
        let encoding = URLEncoding.default
        
        switch self {
            
        case .getData(_, _), .getListFor(_, _, _):
            return .requestParameters(parameters: authParams,
                                      encoding: encoding)
        case .getList(let page, _):
            return .requestParameters(parameters: ["key": BreweryDB.apiKey,
                                                   "p": page],
                                  encoding: encoding)
        case .search(let searchString, _):
            return .requestParameters(parameters: ["key": BreweryDB.apiKey,
                                                   "type": T.type.single,
                                                   "q": searchString],
                                      encoding: encoding)
        case .geo(let latitude, let longitude, let radius, _):
            return .requestParameters(parameters: ["key": BreweryDB.apiKey,
                                                   "lat": String(latitude),
                                                   "lng": String(longitude),
                                                   "radius": radius],
                                      encoding: encoding)
        }


    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}

