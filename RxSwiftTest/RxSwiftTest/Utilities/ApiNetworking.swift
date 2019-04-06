//
//  ApiNetworking.swift
//  RxSwiftTest
//
//  Created by Bernard Hur on 07/04/2019.
//  Copyright © 2019 Bernard Hur. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

class ApiNetworking {
    static let shared = ApiNetworking()
    
    func currentWeather(for city: String) -> Observable<Weather> {
        guard var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather") else { return Observable.just(Weather.empty) }
        
        let keyQuery = URLQueryItem(name: "appid", value: "15840bb9162fffad99fc195c95ffa179")
        let unitQuery = URLQueryItem(name: "units", value: "metric")
        let cityQuery = URLQueryItem(name: "q", value: city)
    
        components.queryItems = [keyQuery, unitQuery, cityQuery]
        
        guard let url = components.url else { return Observable.just(Weather.empty) }
        
        return URLSession.shared.rx
            .data(request: URLRequest(url: url))
            .map({ (data) -> Weather in
                let weather = try? JSONDecoder().decode(Weather.self, from: data)
                return weather ?? Weather.empty
            })
            .catchErrorJustReturn(Weather.empty)
    }
    
}
