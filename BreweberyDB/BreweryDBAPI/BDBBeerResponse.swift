//
//  File.swift
//  BeerWiki
//
//  Created by Tyts on 26.01.2020.
//  Copyright © 2020 Tyts&Co. All rights reserved.
//

import Foundation
import UIKit

struct BDBBeerResponse: Codable{
    let id: String          //The unique id of the beer.
    let name: String        //The name of the beer.
    let nameDisplay: String //Display name of the beer.
    let description: String? //The description of the beer.
    let labels: BeerLabelsResponse?      //If this object is set then labels exist and it will contain items icon, medium, and large that are URLs to the images.
}

struct BeerLabelsResponse: Codable {
    let icon: String?
    let medium: String?
    let large: String?
    let contentAwareIcon: String?
    let contentAwareMedium: String?
    let contentAwareLarge: String?
}
