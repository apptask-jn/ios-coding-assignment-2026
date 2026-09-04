import os

@testable import ProductListApp

final class StubProductService: ProductService {

  let products: [Product]
  let pageSize: Int
  let error: (any Error & Sendable)?
  let failsFromSkip: Int

  private let requestedSkipsLock = OSAllocatedUnfairLock<[Int]>(initialState: [])
  private let fetchProductCallCountLock = OSAllocatedUnfairLock(initialState: 0)

  var requestedSkips: [Int] { self.requestedSkipsLock.withLock { $0 } }
  var fetchProductsCallCount: Int { self.requestedSkips.count }
  var fetchProductCallCount: Int { self.fetchProductCallCountLock.withLock { $0 } }

  init(
    products: [Product] = [],
    pageSize: Int = 30,
    error: (any Error & Sendable)? = nil,
    failsFromSkip: Int = 0
  ) {
    self.products = products
    self.pageSize = pageSize
    self.error = error
    self.failsFromSkip = failsFromSkip
  }

  func fetchProducts(skip: Int) async throws -> ProductListResponse {
    self.requestedSkipsLock.withLock { $0.append(skip) }
    await Task.yield()

    if let error = self.error, skip >= self.failsFromSkip {
      throw error
    }
    return ProductListResponse(
      products: Array(self.products.dropFirst(skip).prefix(self.pageSize)),
      total: self.products.count
    )
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
