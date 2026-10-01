//
//  ProductDetailViewModel.swift
//  ios-coding-assignment-2026
//
//  Created by Park Kwonyong on 10/1/26.
//

import Observation

@Observable
final class ProductDetailViewModel {
  private let repository: ProductRepositoryProtocol
  let productId: Int
  init(repository: ProductRepositoryProtocol, productId: Int) {
    self.repository = repository
    self.productId = productId
  }
}
