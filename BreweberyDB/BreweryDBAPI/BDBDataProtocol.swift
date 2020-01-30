//
//  BDBDataProtocol.swift
//  BrewebeyDB
//
//  Created by Tyts on 28.01.2020.
//  Copyright © 2020 Tyts&Co. All rights reserved.
//

import Foundation

protocol BDBDataProtocol {
    var id: String { get }
    var name: String { get }
    
    static func type() -> typeOfData 
}

