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
  
  func loadProductList() async {
    state = .loading
    let result = await repository.getProducts()
    switch result {
    case .success(let res):
      state = .loaded(res.products)
    case .failure(let error):
      print(error.localizedDescription)
      state = .failed(error)
    }
  }
    
}
