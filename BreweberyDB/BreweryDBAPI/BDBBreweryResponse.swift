//
//  BDBBreweryResults.swift
//  BeerWiki
//
//  Created by Tyts on 27.01.2020.
//  Copyright © 2020 Tyts&Co. All rights reserved.
//

import Foundation

struct BDBBreweryResponse: Codable & BDBDataProtocol {
    var id: String         //The unique id of the beer.
    let name: String        //The name of the beer.
    let nameShortDisplay: String? //Display name of the beer.
    let description: String? //The description of the beer.
    let images: BreweryLabelsResponse?  //If this object is set then labels exist and it will contain items icon, medium, and large that are URLs to the images.
    
    static func type() -> typeOfData {
        return .brewery
    }
}

struct BreweryLabelsResponse: Codable {
    let icon: String?
    let medium: String?
    let large: String?
    let squareMedium: String?
    let squareLarge: String?
}
