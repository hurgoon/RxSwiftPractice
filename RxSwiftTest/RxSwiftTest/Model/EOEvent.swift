//
//  EOEvent.swift
//  RxSwiftTest
//
//  Created by Bernard Hur on 30/03/2019.
//  Copyright © 2019 Bernard Hur. All rights reserved.
//

import Foundation

struct EventCategory: Decodable {
    let id: Int
}

struct EOEvent: Decodable {
    let title: String
    let categories: [EventCategory]
}

struct EONETEvent: Decodable {
    let events: [EOEvent]
}
