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
    let id: Int
    let title: String
    let description: String
    var events: [EOEvent]
    
    enum CodingKeys: String, CodingKey { case id, title, description }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        events = [EOEvent]()
    }
}



