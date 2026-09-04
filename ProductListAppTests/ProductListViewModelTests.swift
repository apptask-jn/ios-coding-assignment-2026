import Foundation
import Testing

@testable import ProductListApp

@MainActor
struct ProductListViewModelTests {

  @Test
  func startsInLoadingStateBeforeLoading() {
    let viewModel = ProductListViewModel(service: StubProductService())

    #expect(viewModel.state == .loading)
  }

  @Test
  func loadPublishesFetchedProducts() async throws {
    let product = try ProductFixture.decodedProduct()
    let viewModel = ProductListViewModel(service: StubProductService(products: [product]))

    await viewModel.load()

    #expect(viewModel.state == .loaded([product]))
  }

  @Test
  func loadPublishesNetworkMessageWhenConnectionFails() async {
    let viewModel = ProductListViewModel(
      service: StubProductService(error: URLError(.notConnectedToInternet))
    )

    await viewModel.load()

    #expect(viewModel.state == .failed(.network))
  }

  @Test
  func loadPublishesUnknownMessageWhenServerRespondsWithError() async {
    let viewModel = ProductListViewModel(
      service: StubProductService(error: ProductServiceError.unsuccessfulStatusCode(500))
    )

    await viewModel.load()

    #expect(viewModel.state == .failed(.unknown))
  }

  @Test
  func loadSkipsRefetchWhenAlreadyLoaded() async throws {
    let product = try ProductFixture.decodedProduct()
    let service = StubProductService(products: [product])
    let viewModel = ProductListViewModel(service: service)

    await viewModel.load()
    await viewModel.load()

    #expect(service.fetchProductsCallCount == 1)
  }
}
