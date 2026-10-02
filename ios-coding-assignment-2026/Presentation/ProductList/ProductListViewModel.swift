//
//  ProductListViewModel.swift
//  ios-coding-assignment-2026
//
//  Created by Park Kwonyong on 10/1/26.
//

import Foundation
import Observation

@Observable
final class ProductListViewModel {

  private(set) var state: LoadState<[ProductResult]> = .idle

  private let repository: ProductRepositoryProtocol

  init(repository: ProductRepositoryProtocol) {
    self.repository = repository
  }

  func loadIfNeeded() async {
    guard case .idle = state else { return }
    await loadProductList()
  }

  func loadProductList() async {
    state = .loading

    let result = await repository.getProducts()

    switch result {
    case .success(let response):
      state = .loaded(response.products)

    case .failure(let error):
      state = .failed(error)
    }
  }
}
