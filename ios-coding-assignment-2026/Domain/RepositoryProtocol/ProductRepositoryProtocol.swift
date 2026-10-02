//
//  ProductRepositoryProtocol.swift
//  ios-coding-assignment-2026
//
//  Created by Park Kwonyong on 10/1/26.
//

protocol ProductRepositoryProtocol {

  // MARK: - 원격 (DummyJSON API)
  func getProducts() async -> Result<ProductResponseResult, NetworkError>

  func getDetailProduct(id: Int) async -> Result<ProductResult, NetworkError>

  // MARK: - 로컬 (찜)
  func loadFavorites() -> Set<Int>
  func toggleFavorite(_ id: Int) -> Set<Int>
}
