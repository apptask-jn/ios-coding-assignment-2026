//
//  ProductRepositoryProtocol.swift
//  ios-coding-assignment-2026
//
//  Created by Park Kwonyong on 10/1/26.
//

protocol ProductRepositoryProtocol {
  func getProducts() async -> Result<ProductResponseResult, NetworkError>
  func getDetailProduct(id: Int) async -> Result<ProductResult, NetworkError>
  
  func load() -> Set<Int>
  func save(_ ids: Set<Int>)
}
