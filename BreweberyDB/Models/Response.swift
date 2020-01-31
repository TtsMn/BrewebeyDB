//
//  File.swift
//  BeerWiki
//
//  Created by Tyts on 27.01.2020.
//  Copyright © 2020 Tyts&Co. All rights reserved.
//

import Foundation

struct Response<T: Codable>: Codable {
    let status: String
    let message: String?
    let errorMessage: String?
    let currentPage: Int?
    let numberOfPages: Int?
    let totalResults: Int?
    let data: [T]?
}

