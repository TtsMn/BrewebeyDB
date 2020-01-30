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

class BeerViewModel<T: Codable & DataProtocol> {
    
    private let DELTA = 20
    
    private let _breweryDBProvider = BreweryDBProvider<T>()
    private let _bookmarkService: BookmarkService<T> = BookmarkService()
    private let _typeOfData: typeOfData!
    public var dataSource: dataSource!
    
    public let disposeBag = DisposeBag()
    public var searchText: BehaviorRelay<String>!
    public var data: BehaviorRelay<[T]>!
    public var numberOfShownCells: PublishSubject<Int>
//    public var totalNumberOfCells: Observable<Int>!
    
    private var lastSearchString = ""
    private var totalCountOfPages = 0
    private var loadedPages = 1
    private var currentPage = 1
 
    let loadNextPage = BehaviorRelay(value: 0)
    
    init(typeOfData: typeOfData, dataSource: dataSource = .api) {
        
        self._typeOfData = typeOfData
        
        self.searchText = BehaviorRelay<String>(value: "")
        self.data = BehaviorRelay<[T]>(value: [T]())
        self.numberOfShownCells = PublishSubject<Int>()
        
        self._configurePager()
        self._configureSearchUpdateHandle()
        self.changeDataSource(source: dataSource)

    }
    
    private func _configurePager() -> Void {

        Observable.combineLatest(self.numberOfShownCells, self.data)
            .throttle(TimeInterval(0.5), scheduler: MainScheduler.instance)
//        .myDebug(identifier: "pager")
            .subscribe(onNext: { (numberOfShownCells, data) in
                if numberOfShownCells > 0,
                    (data.count - numberOfShownCells) < self.DELTA,
                    self.totalCountOfPages > self.currentPage,
                    self.loadedPages <= self.currentPage {
                    
                    self.currentPage += 1
                    self.loadedPages = self.currentPage
                    self.request(searchString: self.lastSearchString, page: self.currentPage)
                }
            }, onError: { (err) in
                self.numberOfShownCells.onNext(0)
            }).disposed(by: self.disposeBag)

    }
    
    private func _configureSearchUpdateHandle() -> Void {
                
        self.searchText
            .throttle(TimeInterval(0.3), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .myDebug(identifier: "search string")
            //            .flatMapFirst({ self._search(type: .beer, searchString: $0, page: 1) })// fail
            .subscribe(onNext: { (searchString) in
                self.request(searchString: searchString)
            }).disposed(by: self.disposeBag)
        
    }
    
    public func changeDataSource(source: dataSource?=nil) -> Void {
        if let source = source {
            self.dataSource = source
            self.currentPage = 0
            self.loadedPages = 0
            self.totalCountOfPages = 0
            self.numberOfShownCells.onNext(0)
        }
        
        self.request()
    }
    
    public func nextPage() {
        guard self.currentPage < self.totalCountOfPages,
            self.currentPage >= self.loadedPages
            else { return }
        loadNextPage.accept(self.currentPage)
        
    }
    
    public func request(searchString: String="", page: Int=1) -> Void {
        
        if self.dataSource == .api {
            
            let subscriptionHandler: (Response<T>) -> Void = { [weak self] response in
                
                guard let self = self, let numberOfPages = response.numberOfPages else { return }
                
                self.lastSearchString = searchString
                self.currentPage = page
                self.totalCountOfPages = numberOfPages
                
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
                    }).disposed(by: self.disposeBag)
                
            } else {
                
                self._breweryDBProvider.search(type: self._typeOfData, searchString: searchString, page: page)
                    .subscribe(onNext: { response in
                        subscriptionHandler(response)
                    }).disposed(by: self.disposeBag)
                
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
