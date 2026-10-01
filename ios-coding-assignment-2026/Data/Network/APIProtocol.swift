//
//  APIProtocol.swift
//  ios-coding-assignment-2026
//
//  Created by Park Kwonyong on 10/1/26.
//

import Foundation
import Alamofire

let developmentBaseURL: String = "https://dummyjson.com"

protocol APIProtocol {
  var baseURL: String { get }
  var url: String { get }
  var header: HTTPHeaders { get }
  var parameter: Encodable? { get }
  var method: HTTPMethod { get }
  var urlEncoding: URLEncoding { get }
}

extension APIProtocol {
  var baseURL: String {
    return developmentBaseURL
  }
  
  var header: HTTPHeaders {
    var headers = HTTPHeaders()
    headers.add(.contentType("application/json"))
    return headers
  }
  
  var method: HTTPMethod {
    return .post
  }
  
  var urlEncoding: URLEncoding {
    return .httpBody
  }
  
}

extension Encodable {
  subscript(key: String) -> Any? {
    return dictionary[key]
  }
  var dictionary: [String: any Any & Sendable] {
    return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: any Any & Sendable] ?? [:]
  }
}
