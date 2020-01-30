//
//  Beer.swift
//  BeerWiki
//
//  Created by Tyts on 26.01.2020.
//  Copyright © 2020 Tyts&Co. All rights reserved.
//

import Foundation

struct Beer: Codable & DataProtocol{

    var id: String          //The unique id of the beer.
    var name: String        //The name of the beer.
    var nameDisplay: String //Display name of the beer.
    var description: String? //The description of the beer.
    let labels: BeerLabels?      //If this object is set then labels exist and it will contain items icon, medium, and large that are URLs to the images.
    
    static func type() -> typeOfData {
        return .beer
    }
}

enum BeerImageSize: String {
    
    case icon
    case medium
    case large
    case contentAwareIcon
    case contentAwareMedium
    case contentAwareLarge
    
}

struct BeerLabels: Codable {
    let icon: String?
    let medium: String?
    let large: String?
    let contentAwareIcon: String?
    let contentAwareMedium: String?
    let contentAwareLarge: String?
}
