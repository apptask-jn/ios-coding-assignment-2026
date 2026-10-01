//
//  AppContainer.swift
//  ios-coding-assignment-2026
//
//  Created by Park Kwonyong on 10/1/26.
//

import Foundation

final class AppContainer {
  private lazy var productNetwork: ProductNetworkProtocol =
  ProductNetwork(manager: NetworkManager(session: ProductSession()))

  private lazy var productRepository: ProductRepositoryProtocol =
  ProductRepository(network: productNetwork, userDefaults: FavoriteUserDefaults())
  
  func makeProductListViewModel() -> ProductListViewModel {
    ProductListViewModel(repository: productRepository)
  }
}
