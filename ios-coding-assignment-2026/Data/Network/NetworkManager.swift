//
//  NetworkManager.swift
//  ios-coding-assignment-2026
//
//  Created by Park Kwonyong on 10/1/26.
//

import Foundation
import Alamofire

protocol NetworkManagerProtocol {
  func requestAPIModule<T: Decodable>(api: APIProtocol) async -> Result<T, NetworkError>
}

class NetworkManager: NetworkManagerProtocol {
  private let session: SessionProtocol
  init(session: SessionProtocol) {
    self.session = session
  }
  
  private func makeURL(apiRouter: APIProtocol) -> (URL?, HTTPHeaders, Parameters?, HTTPMethod, URLEncoding) {
    return (URL(string: apiRouter.baseURL + apiRouter.url), apiRouter.header, apiRouter.parameter?.dictionary, apiRouter.method, apiRouter.urlEncoding)
  }
  
  func requestAPIModule<T: Decodable>(api: APIProtocol) async -> Result<T, NetworkError> {
    let (fullURL, header, parameter, method, encoding) = makeURL(apiRouter: api)
    
    guard let fullURL else { return .failure(.urlError) }
    let result = await session.request(fullURL, method: method, parameters: parameter, encoding: encoding, headers: header).serializingData().response
    
    if let error = result.error {
      print("url: \(result.request?.url?.absoluteString ?? ""), param: \(String(data: result.request?.httpBody ?? Data(), encoding: .utf8) ?? ""), res: \(error.errorDescription ?? "error") ")
      return .failure(.requestFailed(error.localizedDescription))
    }
    guard let data = result.data else { return .failure(.dataNil) }
    if let jsonString = String(data: data, encoding: .utf8) { print(jsonString) }
    guard let response = result.response else { return .failure(.invalidResponse) }
    print("url: \(result.request?.url?.absoluteString ?? ""), param: \(String(data: result.request?.httpBody ?? Data(), encoding: .utf8) ?? ""), res: \(String(data: data, encoding: .utf8) ?? "") ")
    if 200..<300 ~= response.statusCode {
      let decoder = JSONDecoder()
      do {
        let parsedData = try decoder.decode(T.self, from: data)
        return .success(parsedData)
      } catch {
        return .failure(.failToDecode(error.localizedDescription))
      }
    } else if 300..<400 ~= response.statusCode {
      return .failure(.invalidResponse)
    } else if 400..<500 ~= response.statusCode {
      return .failure(.clientError(response.statusCode))
    } else if 500..<600 ~= response.statusCode {
      return .failure(.serverError(response.statusCode))
    } else {
      return .failure(.unknownStatus(response.statusCode))
    }
  }
    
}
