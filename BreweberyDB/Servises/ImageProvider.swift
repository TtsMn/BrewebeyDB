//
//  ImageProvider.swift
//  BreweberyDB
//
//  Created by Tyts on 30.01.2020.
//  Copyright © 2020 Tyts&Co. All rights reserved.
//

import Foundation
import RxSwift
import Moya

class ImageProvider {

    private static let _provider = MoyaProvider<ImageService>()
    private static let _disposeBag = DisposeBag()
    
    public static func image(url: String, iv: UIImageView) -> Void {
        self._provider.rx
            .request(.image(url: url), callbackQueue: DispatchQueue.main)
            .mapImage()
            .subscribe(onSuccess: { (img) in
                iv.image = img
            }).disposed(by: ImageProvider._disposeBag)
    }
}
