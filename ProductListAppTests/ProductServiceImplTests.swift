import Foundation
import Testing

@testable import ProductListApp

@Suite(.serialized)
struct ProductServiceImplTests {

  private let service = ProductServiceImpl(session: StubURLProtocol.makeSession())

  @Test
  func fetchProductsReturnsDecodedProducts() async throws {
    StubURLProtocol.stubHTTPResponse(statusCode: 200, body: ProductFixture.listResponse)

    let products = try await self.service.fetchProducts()

    #expect(products.map(\.id) == [1, 7])
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
      try await self.service.fetchProducts()
    }
  }
}
