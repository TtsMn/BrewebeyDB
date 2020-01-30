//
//  DBD.swift
//  DBDLocationResponse
//
//  Created by Tyts on 30.01.2020.
//  Copyright © 2020 Tyts&Co. All rights reserved.
//

import Foundation

class DBDLocationResponse: Codable & BDBDataProtocol {
    var id: String
    let name: String
    let brewery: BDBBreweryResponse
    
    
    static func type() -> typeOfData {
        return .area
    }
    
}
