//
//  BeerViewMolel.swift
//  BeerWiki
//
//  Created by Tyts on 28.01.2020.
//  Copyright © 2020 Tyts&Co. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum dataSource {
    case api
    case bookmarks
}

class BeerViewModel<T: Codable & BDBDataProtocol> {
    
    private let _disposeBag = DisposeBag()
    private var _breweryDBProvider = BreweryDBProvider<T>()
    private let _bookmarkService: BookmarkService<T> = BookmarkService()
    private let _typeOfData: typeOfData!
    public var dataSource: dataSource!
    
    public var searchText: BehaviorRelay<String>!
    public var data: BehaviorRelay<[T]>!
    
    private var lastSearchString = ""
    private var numberOfPages = 0
    private var loadedPages = 1
    private var page = 1
 
    let loadNextPage = BehaviorRelay(value: 0)
    
    init(typeOfData: typeOfData, dataSource: dataSource = .api) {
        self._typeOfData = typeOfData
        self.changeDataSource(source: dataSource)
        
        self.searchText = BehaviorRelay<String>(value: "")
        self.data = BehaviorRelay<[T]>(value: [T]())
        
        self.searchText
            .throttle(TimeInterval(0.3), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .myDebug(identifier: "str")
            //            .flatMapFirst({ self._search(type: .beer, searchString: $0, page: 1) })// отладка требуется
            .subscribe(onNext: { (searchString) in
                self.request(searchString: searchString)
            }).disposed(by: self._disposeBag)
        

         loadNextPage.asObservable()
             .throttle(TimeInterval(1), scheduler: MainScheduler.instance)
             .subscribe(
             onNext: { page in
                 self.page = page + 1
                 self.request(searchString: self.lastSearchString, page: page + 1)
                 self.loadedPages = page + 1
         }).disposed(by: self._disposeBag)
    }
    
    public func changeDataSource(source: dataSource?=nil) -> Void {
        if let source = source {
            self.dataSource = source
            self.page = 1
            self.loadedPages = 1
            self.numberOfPages = 0
        }
        
        self.request()
        
    }
    
    public func nextPage() {
        guard self.page < self.numberOfPages,
            self.page >= self.loadedPages
            else { return }
        loadNextPage.accept(self.page)
        
    }
    
    public func request(searchString: String="", page: Int=1) -> Void {
        
        if self.dataSource == .api {
            
            let subscriptionHandler: (BDBResponse<T>) -> Void = { [weak self] response in
                
                guard let self = self, let numberOfPages = response.numberOfPages else { return }
                
                self.lastSearchString = searchString
                self.page = page
                self.numberOfPages = numberOfPages
                
                if var data = response.data {
                    if page > 1 {
                        var myData = self.data.value
                        myData.append(contentsOf: data)
                        data = myData
                    }
                    self.data.accept(data)
                }
            }
            
            if searchString.isEmpty {
                
                self._breweryDBProvider.getBeers(page: page)
                    .subscribe(onNext: { response in
                        subscriptionHandler(response)
                    }).disposed(by: self._disposeBag)
                
            } else {
                
                self._breweryDBProvider.search(type: self._typeOfData, searchString: searchString, page: page)
                    .subscribe(onNext: { response in
                        subscriptionHandler(response)
                    }).disposed(by: self._disposeBag)
                
            }
            
        } else if self.dataSource == .bookmarks {
            
            let response: [T]
            if searchString.isEmpty {
                response = self._bookmarkService.getBookmars()
            } else {
                response = self._bookmarkService.searching(searchString: searchString)
            }
            self.data.accept(response)
            
        }
        
    }
    
}

extension ObservableType {
    public func myDebug(identifier: String) -> Observable<Self.E> {
        return Observable.create { observer in
            print("subscribed \(identifier)")
            let subscription = self.subscribe { e in
                print("event \(identifier)  \(e)")
                switch e {
                case .next(let value):
                    observer.on(.next(value))
                    
                case .error(let error):
                    observer.on(.error(error))
                    
                case .completed:
                    observer.on(.completed)
                }
            }
            return Disposables.create {
                print("disposing \(identifier)")
                subscription.dispose()
            }
        }
    }
}
