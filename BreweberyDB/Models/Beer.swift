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
    let name: String        //The name of the beer.
    let nameDisplay: String //Display name of the beer.
    let description: String? //The description of the beer.
    let labels: BeerLabels?      //If this object is set then labels exist and it will contain items icon, medium, and large that are URLs to the images.
  
}

extension Beer {
    
    static var type: DataType {
        return .beer
    }
    
    func getImageUrl(size: BeerImageSize) -> String? {
        if let images = self.labels {
            switch size {
            case .icon:
                return images.icon
            case .medium:
                return images.medium
            case .large:
                return images.large
            case .contentAwareIcon:
                return images.contentAwareIcon
            case .contentAwareMedium:
                return images.contentAwareMedium
            case .contentAwareLarge:
                return images.contentAwareLarge
            }
        } else {
            return nil
        }
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
