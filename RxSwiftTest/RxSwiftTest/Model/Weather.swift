//
//  Weather.swift
//  RxSwiftTest
//
//  Created by Bernard Hur on 07/04/2019.
//  Copyright © 2019 Bernard Hur. All rights reserved.
//

import Foundation

struct Weather: Codable {
    let name: String // London
    let sys: Sys
    let main: Main
    
    static let empty = Weather(name: "RxCity", sys: Sys(country: "RX"), main: Main(temp: 100, humidity: 1000)) // for prepare network failure.
}

struct Sys: Codable {
    let country: String
}

struct Main: Codable {
    let temp: Double
    let humidity: Int
}
