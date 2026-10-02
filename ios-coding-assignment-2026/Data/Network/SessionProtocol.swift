//
//  SessionProtocol.swift
//  ios-coding-assignment-2026
//
//  Created by Park Kwonyong on 10/1/26.
//

import Alamofire

protocol SessionProtocol {
  func request(_ convertible: any URLConvertible,
               method: HTTPMethod,
               parameters: Parameters?,
               encoding: any ParameterEncoding,
               headers: HTTPHeaders?) -> DataRequest
}
