//
//  BeerInfoViewModel.swift
//  BreweberyDB
//
//  Created by Tyts on 30.01.2020.
//  Copyright © 2020 Tyts&Co. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class BeerInfoViewModel {

    public let disposeBag = DisposeBag()
    
    public var bookmarkService: BookmarkService<Beer>!
    public var bookmark: BehaviorRelay<Bool>!
    
    let data: Beer!
        
    init(data: Beer) {
        self.data = data
                
        self.bookmarkService = BookmarkService()
        
        self.bookmark = BehaviorRelay<Bool>(value: self.bookmarkService.get(data: self.data))
        
    }
    
    
}
