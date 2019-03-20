//
//  ImageCache.swift
//  RxSwiftTest
//
//  Created by Bernard Hur on 20/03/2019.
//  Copyright © 2019 Bernard Hur. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxSwiftExt

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func loadImage(with url: URL, placeHolder: UIImage? = nil, bag: DisposeBag) {
        self.image = placeHolder
        
        let key = NSString(string: url.absoluteString)
        
        if let image = imageCache.object(forKey: NSString(string: key)) { // 플레이스홀더(디폴트) 이미지
            self.image = image
            
            return
        }
        
        Observable.just(url) // 실제 이미지 패치
            .map({ URLRequest(url: $0 ) })
            .flatMap({ URLSession.shared.rx.data(request: $0) })
            .subscribe(onNext: { (data) in
                guard let image = UIImage(data: data) else { return }
                imageCache.setObject(image, forKey: NSString(string: url.absoluteString))
                
                DispatchQueue.main.async {
                    self.image = image
                }
                
            }).disposed(by: bag)
        
    }
}
