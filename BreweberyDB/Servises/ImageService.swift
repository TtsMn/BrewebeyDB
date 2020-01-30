//
//  ImageService.swift
//  BreweberyDB
//
//  Created by Tyts on 30.01.2020.
//  Copyright © 2020 Tyts&Co. All rights reserved.
//

import Foundation
import Moya

enum ImageService {
    
    case image(url: String)
    
}

extension ImageService: TargetType {
    var baseURL: URL {
        switch self {
        case .image(let url):
            return URL(string: url)!
        }
    }
    
    var path: String {
        return ""
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .requestParameters(parameters: [String: Any](), encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        return nil
    }
}

//enum ImageService {
//
//    case beer(beerId: String, imageId: String, imageSize: String)
//    case brewery(breweryId: String, imageId: String, imageSize: String)
//
//}
////
//extension ImageService: TargetType {
//    var baseURL: URL {
//        return URL(string: "https://brewerydb-images.s3.amazonaws.com/")!
//    }
//
//    var path: String {
//        switch self {
//        case .beer(let beerId, let imageId, let imageSize):
//            return "beer/\(beerId)/upload_\(imageId)-\(imageSize).png"
//        case .brewery(let breweryId, let imageId, let imageSize):
//            return "brewery/\(breweryId)/upload_\(imageId)-\(imageSize).png"
//        }
//    }
//
//    var method: Moya.Method {
//        return .get
//    }
//
//    var sampleData: Data {
//        return Data()
//    }
//
//    var task: Task {
//        return .requestParameters(parameters: [String: Any](), encoding: URLEncoding.default)
//    }
//
//    var headers: [String : String]? {
//        return nil
//    }
//}
