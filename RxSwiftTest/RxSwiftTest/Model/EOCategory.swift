//
//  EOCategory.swift
//  RxSwiftTest
//
//  Created by Bernard Hur on 30/03/2019.
//  Copyright © 2019 Bernard Hur. All rights reserved.
//

import Foundation

struct EONETCategory: Decodable {
    let categories: [EOCategory]
}

struct EOCategory: Decodable {
    let title: String
    let description: String
}


