//
//  ProductSession.swift
//  ios-coding-assignment-2026
//
//  Created by Park Kwonyong on 10/1/26.
//

import Foundation
import Alamofire

class ProductSession: SessionProtocol {
  private var session: Session
  init() {
    let config = URLSessionConfiguration.default
    config.requestCachePolicy = .returnCacheDataElseLoad
    self.session = Session(configuration: config)
  }
  
  func request(_ convertible: any URLConvertible,
               method: HTTPMethod = .get,
               parameters: Parameters? = nil,
               encoding: any ParameterEncoding = URLEncoding.default,
               headers: HTTPHeaders? = nil) -> DataRequest {
    session.request(convertible, method: method, parameters: parameters, encoding: encoding, headers: headers)
  }
}
