//
//  ImageLoaderViewController.swift
//  RxSwiftTest
//
//  Created by Bernard Hur on 13/03/2019.
//  Copyright © 2019 Bernard Hur. All rights reserved.
//

import UIKit
import RxSwift

class ImageLoaderViewController: UIViewController {
    
    let bag = DisposeBag()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func imageLoadButton(_ sender: UIButton) {
        
        Observable.just("800x600")
            .map { $0.replacingOccurrences(of: "x", with: "/") }
            .map { "https://picsum.photos/\($0)/?random" }
            .map { URL(string: $0) }
            .filter { $0 != nil }
            .map { $0! }
            .map { try Data(contentsOf: $0) }
            .map { UIImage(data: $0) }
            .subscribe(onNext: { image in
                self.imageView.image = image
            }).disposed(by: bag)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}
