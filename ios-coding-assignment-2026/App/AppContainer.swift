//
//  AppContainer.swift
//  ios-coding-assignment-2026
//
//  Created by Park Kwonyong on 10/1/26.
//

import Foundation

@MainActor
final class AppContainer {
  // MARK: - Data 계층
  private lazy var productNetwork: ProductNetworkProtocol =
  ProductNetwork(manager: NetworkManager(session: ProductSession()))
  private lazy var productRepository: ProductRepositoryProtocol =
  ProductRepository(network: productNetwork, userDefaults: FavoriteUserDefaults())

  // MARK: - 공유 상태
  lazy var favoriteStore: FavoriteStore =
  FavoriteStore(repository: productRepository)

  // MARK: - ViewModel 팩토리
  func makeProductListViewModel() -> ProductListViewModel {
    ProductListViewModel(repository: productRepository)
  }
  /// [상세 2/3] 목록에서 넘겨받은 상품 ID로 상세 ViewModel을 만든다.
  func makeProductDetailViewModel(productId: Int) -> ProductDetailViewModel {
    ProductDetailViewModel(repository: productRepository, productId: productId)
  }
}
