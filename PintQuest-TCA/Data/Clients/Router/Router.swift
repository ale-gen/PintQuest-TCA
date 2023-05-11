//
//  Router.swift
//  PintQuest-TCA
//
//  Created by Aleksandra Generowicz on 07/05/2023.
//

import Foundation

struct Route {
  let path: String
  let queryItems: [URLQueryItem]?

  init(path: String, queryItems: [URLQueryItem]? = nil) {
    self.path = path
    self.queryItems = queryItems
  }

  var url: URL? {
    var components = URLComponents()

    components.scheme = "https"
    components.host = Environment.apiURL.absoluteString
    components.path = "/\(Environment.apiVersion)/\(path)"
    components.queryItems = queryItems

    return components.url
  }
}

struct Router {}
