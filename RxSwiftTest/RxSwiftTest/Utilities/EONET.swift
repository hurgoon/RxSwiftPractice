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
    static let eventUrl = "https://eonet.sci.gsfc.nasa.gov/api/v2.1/events"
    
    static var eoCategories: Observable<[EOCategory]> = {
        guard let url = URL(string: categoryUrl) else { fatalError("Invalid Url") } // 실제앱에서는 fatalError 띄우면 애플이 리젝함.
        
        return URLSession.shared.rx.data(request: URLRequest(url: url)).map{ data -> [EOCategory] in
            guard let eonetCategory = try? JSONDecoder().decode(EONETCategory.self, from: data) else { return [] }
            
            return eonetCategory.categories.sorted(by: { $0.title < $1.title})
            }.catchErrorJustReturn([]).share(replay: 1, scope: .forever)
    }()
    
    fileprivate static func events(isOpen: Bool) -> Observable<[EOEvent]> {
        guard var components = URLComponents(string: eventUrl) else { fatalError("Invalid Url") }
        
        components.queryItems = [URLQueryItem(name: "days", value: "360"), URLQueryItem(name: "status", value: isOpen ? "open" : "closed")]
        
        guard let finalUrl = components.url else { fatalError("Invalid Url")}
        
        return URLSession.shared.rx.data(request: URLRequest(url: finalUrl)).map({ (data) -> [EOEvent] in
            guard let eonetEvent = try? JSONDecoder().decode(EONETEvent.self, from: data) else { return [] }
            return eonetEvent.events
        }).catchErrorJustReturn([])
    }
    
    static func events() -> Observable<[EOEvent]> {
        let openEvents = events(isOpen: true)
        let closedEvents = events(isOpen: false)
        
//        return openEvents.concat(closedEvents).reduce([], accumulator: +) 시간을 줄여보자...
//        return Observable.of(openEvents, closedEvents).merge().reduce([], accumulator: +)
        
        return Observable.of(openEvents, closedEvents).merge().scan([], accumulator: +)
    }
    
}
