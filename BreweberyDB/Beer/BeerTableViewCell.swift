//
//  CollectionViewCellTest.swift
//  BreweberyDB
//
//  Created by Tyts on 29.01.2020.
//  Copyright © 2020 Tyts&Co. All rights reserved.
//

import UIKit
import RxSwift
import Moya

class BeerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var ttlLabel: UILabel!
    
    private static let _provider = MoyaProvider<ImageService>()
    private static let _disposeBag = DisposeBag()
    public var beer: Beer? = nil
    
    override func prepareForReuse() {
        self.imageCell.image = UIImage(named: "noImage-1")
    }
    
    public func configureImage() -> Void {
        if let imageURLString = self.beer?.getImageUrl(size: .icon) {
            BeerTableViewCell._provider.rx
                .request(.image(url: imageURLString), callbackQueue: DispatchQueue.main)
                .mapImage()
                .subscribe(onSuccess: { (image) in
                    self.imageCell.image = image
                }).disposed(by: BeerTableViewCell._disposeBag)
        }
    }
}
