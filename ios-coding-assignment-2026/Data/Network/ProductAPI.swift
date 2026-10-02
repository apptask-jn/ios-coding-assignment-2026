//
//  ProductAPI.swift
//  ios-coding-assignment-2026
//
//  Created by Park Kwonyong on 10/1/26.
//

import Alamofire

enum ProductAPI: APIProtocol {
  case getProducts
  case getDetailProduct(id: Int)
}
extension ProductAPI {
  var url: String {
    switch self {
    case .getProducts:
      return "/products"
    case .getDetailProduct(id: let id):
      return "/products/\(id)"
    }
  }
  
  var header: HTTPHeaders {
    let headers = HTTPHeaders()
    return headers
  }
  
  var parameter: Encodable? {
    switch self {
    case .getProducts: return nil
    case .getDetailProduct(id: _): return nil
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .getProducts:
      return .get
    case .getDetailProduct(id: _):
      return .get
    }
  }
  
  var urlEncoding: URLEncoding {
    switch self {
    case .getProducts:
      return .queryString
    case .getDetailProduct(id: _):
      return .queryString
    }
  }
  
}
