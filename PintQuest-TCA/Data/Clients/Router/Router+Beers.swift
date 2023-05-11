//
//  Router+Beers.swift
//  PintQuest-TCA
//
//  Created by Aleksandra Generowicz on 07/05/2023.
//

import Foundation

extension Router {
    static func beersPage(_ page: Int) -> Route {
        Route(
            path: "beers",
            queryItems: [
                .init(name: "page", value: "\(page)")
            ]
        )
    }
    
    static func nameBeersPage(_ name: String, _ page: Int) -> Route {
        Route(
            path: "beers",
            queryItems: [
                .init(name: "name", value: "\(name)"),
                .init(name: "page", value: "\(page)")
            ]
        )
    }
}
