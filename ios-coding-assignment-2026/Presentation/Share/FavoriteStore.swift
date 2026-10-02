//
//  FavoriteStore.swift
//  ios-coding-assignment-2026
//
//  Created by Park Kwonyong on 10/2/26.
//

import Observation

@MainActor
@Observable
final class FavoriteStore {

  private(set) var favoriteIDs: Set<Int>

  private let repository: ProductRepositoryProtocol

  init(repository: ProductRepositoryProtocol) {
    self.repository = repository
    self.favoriteIDs = repository.loadFavorites()
  }

  func contains(_ productID: Int) -> Bool {
    favoriteIDs.contains(productID)
  }

  func toggle(_ productID: Int) {
    favoriteIDs = repository.toggleFavorite(productID)
  }
}
