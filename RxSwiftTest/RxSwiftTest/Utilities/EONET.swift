//
//  EONET.swift
//  RxSwiftTest
//
//  Created by Bernard Hur on 30/03/2019.
//  Copyright © 2019 Bernard Hur. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class EONET {
    static let categoryUrl = "https://eonet.sci.gsfc.nasa.gov/api/v2.1/categories"
    static var eoCategories: Observable<[EOCategory]> = {
        guard let url = URL(string: categoryUrl) else { fatalError("Invalid Url") } // 실제앱에서는 fatalError 띄우면 애플이 리젝함.
        
        return URLSession.shared.rx.data(request: URLRequest(url: url)).map{ data -> [EOCategory] in
            guard let eonetCategory = try? JSONDecoder().decode(EONETCategory.self, from: data) else { return [] }
            
            return eonetCategory.categories.sorted(by: { $0.title < $1.title})
        }.catchErrorJustReturn([])
    }()
}
