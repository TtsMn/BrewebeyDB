//
//  Brewery.swift
//  BeerWiki
//
//  Created by Tyts on 27.01.2020.
//  Copyright © 2020 Tyts&Co. All rights reserved.
//

import Foundation

struct Brewery: Codable & DataProtocol {
    
    var id: String
    let name: String
    let nameShortDisplay: String?
    let description: String?
    let images: BreweryLabels?

}

extension Brewery {
    
    static var type: DataType {
        return .brewery
    }
    
    func getImageUrl(size: BreweryImageSize) -> String? {
        if let images = self.images {
            switch size {
            case .icon:
                return images.icon
            case .medium:
                return images.medium
            case .large:
                return images.large
            case .squareMedium:
                return images.squareMedium
            case .squareLarge:
                return images.squareLarge
            }
        } else {
            return nil
        }
    }
}

enum BreweryImageSize: String {
    
    case icon
    case medium
    case large
    case squareMedium
    case squareLarge
    
}

struct BreweryLabels: Codable {
    
    let icon: String?
    let medium: String?
    let large: String?
    let squareMedium: String?
    let squareLarge: String?
    
}

func reduseImageUrlForMoyaFactory(url: String?) -> String {
    return (url ?? "") + ""
}
