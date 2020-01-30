//
//  Bookmarks.swift
//  BreweberyDB
//
//  Created by Tyts on 29.01.2020.
//  Copyright © 2020 Tyts&Co. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class BookmarkService<T: Codable & BDBDataProtocol> {
    
//    private let type: typeOfData!
//
//    init(type: typeOfData) {
//        self.type = type
//    }
    
    func searching(searchString: String) -> [T] {
        
        return self.getBookmars().filter {
            $0.name.contains(searchString)
        }
        
    }
    
    func set(data: T, value: Bool) -> Void {
        
        var bookmarks = self.getBookmars()
        bookmarks = bookmarks.filter{$0.id != data.id }
        if value {
            bookmarks.append(data)
        }
        self.setBookmarks(bookmarks: bookmarks)
        
    }
    
    func get(data: T) -> Bool {
        
        let bookmarks = self.getBookmars()
        return bookmarks.contains(where: { data.id == $0.id })
        
    }
    
    func getBookmars() -> [T] {
        
        let defaults = self._getDefaults()
        let bm = defaults.object(forKey: T.type().rawValue) as? [NSDictionary] ?? [NSDictionary]()
        var bookmarks:[T] = []
        bm.forEach { (val) in
            do {
                bookmarks.append(try T(from: val))
            } catch { }
        }
        return bookmarks
    }
    
    func setBookmarks(bookmarks: [T]) -> Void {
        
        let defaults = self._getDefaults()
        var newBookmarks: [NSDictionary] = []
        bookmarks.forEach{ val in
            do {
                newBookmarks.append(try val.asDictionary() as NSDictionary)
            } catch { }
        }
        defaults.setValue(newBookmarks, forKey: T.type().rawValue)
        
    }
    
    private func _getDefaults() -> UserDefaults {
        
        return UserDefaults.standard
        
    }
}

extension Decodable {
  init(from: Any) throws {
    let data = try JSONSerialization.data(withJSONObject: from, options: .prettyPrinted)
    let decoder = JSONDecoder()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:sszzz"
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    self = try decoder.decode(Self.self, from: data)
  }
}

extension Encodable {
  func asDictionary() throws -> [String: Any] {
    let data = try JSONEncoder().encode(self)
    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
      throw NSError()
    }
    return dictionary
  }
}
