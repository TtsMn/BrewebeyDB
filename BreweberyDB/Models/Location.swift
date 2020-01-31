//
//  DBD.swift
//  Location
//
//  Created by Tyts on 30.01.2020.
//  Copyright © 2020 Tyts&Co. All rights reserved.
//

import Foundation

class Location: Codable & DataProtocol {
    
    var id: String
    let name: String
    var description: String?
    let brewery: Brewery?
    
    static var type: DataType {
        return .location
    }
    
}
