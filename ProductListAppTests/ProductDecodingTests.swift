import Foundation
import Testing

@testable import ProductListApp

struct ProductDecodingTests {

  @Test
  func decodesFieldsUsedByTheUI() throws {
    let product = try JSONDecoder().decode(
      Product.self,
      from: Data(ProductFixture.product.utf8)
    )

    #expect(product.id == 1)
    #expect(product.title == "Essence Mascara Lash Princess")
    #expect(product.category == "beauty")
    #expect(product.brand == "Essence")
    #expect(product.price == 9.99)
    #expect(product.discountPercentage == 10.48)
    #expect(product.rating == 2.56)
    #expect(product.stock == 99)
  }

  @Test
  func mapsImageKeysToURLProperties() throws {
    let product = try JSONDecoder().decode(
      Product.self,
      from: Data(ProductFixture.product.utf8)
    )

    let expectedThumbnail = URL(
      string: "https://cdn.dummyjson.com/p/beauty/mascara/thumbnail.webp"
    )
    let expectedImage = URL(string: "https://cdn.dummyjson.com/p/beauty/mascara/1.webp")

    #expect(product.thumbnailURL == expectedThumbnail)
    #expect(product.imageURLs.count == 1)
    #expect(product.imageURLs.first == expectedImage)
  }

  @Test
  func decodesProductMissingBrand() throws {
    let product = try JSONDecoder().decode(
      Product.self,
      from: Data(ProductFixture.productWithoutBrand.utf8)
    )

    #expect(product.brand == nil)
    #expect(product.title == "Chicken Meat")
  }

  @Test
  func decodesProductsFromListEnvelope() throws {
    let response = try JSONDecoder().decode(
      ProductListResponse.self,
      from: Data(ProductFixture.listResponse.utf8)
    )

    #expect(response.products.map(\.id) == [1, 7])
  }
}
