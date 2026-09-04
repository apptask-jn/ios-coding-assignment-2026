import Foundation
import Testing

@testable import ProductListApp

@Suite(.serialized)
struct ProductServiceImplTests {

  private let service = ProductServiceImpl(session: StubURLProtocol.makeSession())

  @Test
  func fetchProductsReturnsDecodedProducts() async throws {
    StubURLProtocol.stubHTTPResponse(statusCode: 200, body: ProductFixture.listResponse)

    let response = try await self.service.fetchProducts(skip: 0)

    #expect(response.products.map(\.id) == [1, 7])
    #expect(response.total == 194)
  }

  @Test
  func fetchProductsSendsLimitAndSkipQueryItems() async throws {
    StubURLProtocol.stubHTTPResponse(statusCode: 200, body: ProductFixture.listResponse)

    _ = try await self.service.fetchProducts(skip: 60)

    let url = try #require(StubURLProtocol.lastRequestURL.withLock { $0 })
    #expect(url.query() == "limit=30&skip=60")
  }

  @Test
  func fetchProductReturnsDecodedProduct() async throws {
    StubURLProtocol.stubHTTPResponse(statusCode: 200, body: ProductFixture.product)

    let product = try await self.service.fetchProduct(id: 1)

    #expect(product.title == "Essence Mascara Lash Princess")
  }

  @Test
  func fetchProductThrowsOnNotFound() async {
    StubURLProtocol.stubHTTPResponse(statusCode: 404, body: #"{"message":"not found"}"#)

    await #expect(throws: ProductServiceError.unsuccessfulStatusCode(404)) {
      try await self.service.fetchProduct(id: 9999)
    }
  }

  @Test
  func fetchProductsThrowsOnNonHTTPResponse() async {
    StubURLProtocol.stubNonHTTPResponse()

    await #expect(throws: ProductServiceError.invalidResponse) {
      try await self.service.fetchProducts(skip: 0)
    }
  }
}
