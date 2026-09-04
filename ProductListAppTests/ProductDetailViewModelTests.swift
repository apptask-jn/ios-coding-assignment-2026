import Foundation
import Testing

@testable import ProductListApp

@MainActor
struct ProductDetailViewModelTests {

  @Test
  func startsInLoadingStateBeforeLoading() {
    let viewModel = ProductDetailViewModel(service: StubProductService())

    #expect(viewModel.state == .loading)
  }

  @Test
  func loadPublishesTheProductWithTheRequestedID() async throws {
    let product = try ProductFixture.decodedProduct()
    let viewModel = ProductDetailViewModel(service: StubProductService(products: [product]))

    await viewModel.load(id: product.id)

    #expect(viewModel.state == .loaded(product))
  }

  @Test
  func loadPublishesFailureMessageWhenTheProductIsMissing() async throws {
    let product = try ProductFixture.decodedProduct()
    let viewModel = ProductDetailViewModel(service: StubProductService(products: [product]))

    await viewModel.load(id: product.id + 1)

    #expect(viewModel.state == .failed(.notFound))
  }

  @Test
  func loadPublishesNetworkMessageWhenConnectionFails() async {
    let viewModel = ProductDetailViewModel(
      service: StubProductService(error: URLError(.notConnectedToInternet))
    )

    await viewModel.load(id: 1)

    #expect(viewModel.state == .failed(.network))
  }

  @Test
  func loadRefetchesEveryTimeItIsCalled() async throws {
    let product = try ProductFixture.decodedProduct()
    let service = StubProductService(products: [product])
    let viewModel = ProductDetailViewModel(service: service)

    await viewModel.load(id: product.id)
    await viewModel.load(id: product.id)

    #expect(service.fetchProductCallCount == 2)
  }
}
