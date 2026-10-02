//
//  ProductDetailViewModel.swift
//  ios-coding-assignment-2026
//
//  Created by Park Kwonyong on 10/1/26.
//

import Observation

@Observable
final class ProductDetailViewModel {

  let productId: Int

  private(set) var state: LoadState<ProductResult> = .idle

  private let repository: ProductRepositoryProtocol

  init(repository: ProductRepositoryProtocol, productId: Int) {
    self.repository = repository
    self.productId = productId
  }

  func loadIfNeeded() async {
    guard case .idle = state else { return }
    await loadProductDetail()
  }

  func loadProductDetail() async {
    state = .loading

    let result = await repository.getDetailProduct(id: productId)

    switch result {
    case .success(let product):
      state = .loaded(product)

    case .failure(let error):
      state = .failed(error)
    }
  }
}
