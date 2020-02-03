//
//  BreweryInfoTableViewCell.swift
//  BreweberyDB
//
//  Created by Tyts on 30.01.2020.
//  Copyright © 2020 Tyts&Co. All rights reserved.
//

import UIKit
import RxSwift
import Moya

class BreweryInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var ttlLabel: UILabel!
    
    private static let _provider = MoyaProvider<ImageService>()
    private static let _disposeBag = DisposeBag()
    public var beer: Beer? = nil
    
    override func prepareForReuse() {
        self.icon.image = UIImage(named: "noImage-1")
    }
    
    public func configureImage() -> Void {
        if let imageURLString = self.beer?.getImageUrl(size: .icon) {
            BreweryInfoTableViewCell._provider.rx
                .request(.image(url: imageURLString), callbackQueue: DispatchQueue.main)
                .mapImage()
                .subscribe(onSuccess: { (image) in
                    self.icon.image = image
                }).disposed(by: BreweryInfoTableViewCell._disposeBag)
        }
    }
}
