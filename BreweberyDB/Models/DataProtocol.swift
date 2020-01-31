//
//  DataProtocol.swift
//  BrewebeyDB
//
//  Created by Tyts on 28.01.2020.
//  Copyright © 2020 Tyts&Co. All rights reserved.
//

import Foundation

enum typeOfData: String {
    
    case beer
    case brewery
    case guild
    case event
    case location   //fake data ni
    
}

protocol DataProtocol {
    
    var id: String { get }
    var name: String { get }
    var description: String? { get }
    
    static func type() -> typeOfData 
}
