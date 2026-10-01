//
//  ProductNetwork.swift
//  ios-coding-assignment-2026
//
//  Created by Park Kwonyong on 10/1/26.
//

import Foundation
import Alamofire

protocol ProductNetworkProtocol {
  func getProducts() async -> Result<ProductResponseResult, NetworkError>
  func getDetailProduct(id: Int) async -> Result<ProductResult, NetworkError>
}

final class ProductNetwork: ProductNetworkProtocol {
  private let manager: NetworkManagerProtocol
  init(manager: NetworkManagerProtocol) {
    self.manager = manager
  }
  func getProducts() async -> Result<ProductResponseResult, NetworkError> {
    return await manager.requestAPIModule(api: ProductAPI.getProducts)
  }
  func getDetailProduct(id: Int) async -> Result<ProductResult, NetworkError> {
    return await manager.requestAPIModule(api: ProductAPI.getDetailProduct(id: id))
  }
}
