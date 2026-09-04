import os

@testable import ProductListApp

final class StubProductService: ProductService {

  let products: [Product]
  let error: (any Error & Sendable)?

  private let fetchProductsCallCountLock = OSAllocatedUnfairLock(initialState: 0)
  private let fetchProductCallCountLock = OSAllocatedUnfairLock(initialState: 0)

  var fetchProductsCallCount: Int { self.fetchProductsCallCountLock.withLock { $0 } }
  var fetchProductCallCount: Int { self.fetchProductCallCountLock.withLock { $0 } }

  init(products: [Product] = [], error: (any Error & Sendable)? = nil) {
    self.products = products
    self.error = error
  }

  func fetchProducts() async throws -> [Product] {
    self.fetchProductsCallCountLock.withLock { $0 += 1 }
    if let error = self.error {
      throw error
    }
    return self.products
  }

  func fetchProduct(id: Int) async throws -> Product {
    self.fetchProductCallCountLock.withLock { $0 += 1 }
    if let error = self.error {
      throw error
    }
    guard let product = self.products.first(where: { $0.id == id }) else {
      throw ProductServiceError.unsuccessfulStatusCode(404)
    }
    return product
  }
}
