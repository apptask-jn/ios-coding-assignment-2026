//
//  ProductListViewModel.swift
//  ios-coding-assignment-2026
//
//  Created by Park Kwonyong on 10/1/26.
//

import Observation

final class ProductListViewModel {
  private let repository: ProductRepositoryProtocol
  init(repository: ProductRepositoryProtocol) {
    self.repository = repository
  }
}
