//
//  RepoEvent.swift
//  RxSwiftTest
//
//  Created by Bernard Hur on 20/03/2019.
//  Copyright © 2019 Bernard Hur. All rights reserved.
//

import Foundation

struct RepoEvent: Decodable {
    let type: String
    let actor: Actor
    let repo: Repo
}

struct Actor: Decodable {
    let username: String
    let imageUrlString: String
    
    enum CodingKeys: String, CodingKey {
        case username = "display_login"
        case imageUrlString = "avatar_url"
    }
}

struct Repo: Decodable {
    let name: String
}
