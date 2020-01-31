//
//  DataProtocol.swift
//  BrewebeyDB
//
//  Created by Tyts on 28.01.2020.
//  Copyright © 2020 Tyts&Co. All rights reserved.
//

import Foundation

enum DataType: String {
    
    case beer
    case brewery
    case guild
    case event      // deprecated
    case location   // fake data
    
    var single: String {
        return self.rawValue
    }
    
    var multiple: String {
        switch self {
        case .beer:
            return "beers"
        case .brewery:
            return "breweries"
        default:
            return ""
        }
    }
    
}

protocol DataProtocol {
    
    var id: String { get }
    var name: String { get }
    var description: String? { get }
    
    static var type: DataType { get }
    
}
