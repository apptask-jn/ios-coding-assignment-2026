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

    #expect(viewModel.state == .loaded([product], hasMore: false))
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

  @Test
  func loadNextPageAppendsTheFollowingPage() async throws {
    let products = try ProductFixture.decodedProducts(count: 60)
    let service = StubProductService(products: products, pageSize: 30)
    let viewModel = ProductListViewModel(service: service)

    await viewModel.load()
    await viewModel.loadNextPage()

    #expect(viewModel.state == .loaded(products, hasMore: false))
    #expect(service.requestedSkips == [0, 30])
  }

  @Test
  func loadNextPageStopsAfterTheLastPage() async throws {
    let products = try ProductFixture.decodedProducts(count: 60)
    let service = StubProductService(products: products, pageSize: 30)
    let viewModel = ProductListViewModel(service: service)

    await viewModel.load()
    await viewModel.loadNextPage()
    await viewModel.loadNextPage()

    #expect(service.requestedSkips == [0, 30])
  }

  @Test
  func concurrentLoadNextPageFetchesOnlyOnce() async throws {
    let products = try ProductFixture.decodedProducts(count: 90)
    let service = StubProductService(products: products, pageSize: 30)
    let viewModel = ProductListViewModel(service: service)
    await viewModel.load()

    async let first: Void = viewModel.loadNextPage()
    async let second: Void = viewModel.loadNextPage()
    _ = await (first, second)

    #expect(service.requestedSkips == [0, 30])
  }

  @Test
  func loadNextPageKeepsLoadedProductsWhenItFails() async throws {
    let products = try ProductFixture.decodedProducts(count: 60)
    let service = StubProductService(
      products: products,
      pageSize: 30,
      error: URLError(.timedOut),
      failsFromSkip: 30
    )
    let viewModel = ProductListViewModel(service: service)

    await viewModel.load()
    await viewModel.loadNextPage()

    #expect(viewModel.state == .loaded(Array(products.prefix(30)), hasMore: true))
    #expect(!viewModel.isLoadingMore)
  }

  @Test
  func prefetchTriggerIDPointsToTheCellBeforeTheEnd() async throws {
    let products = try ProductFixture.decodedProducts(count: 60)
    let service = StubProductService(products: products, pageSize: 30)
    let viewModel = ProductListViewModel(service: service)

    await viewModel.load()

    #expect(viewModel.prefetchTriggerID == products[22].id)

    await viewModel.loadNextPage()

    #expect(viewModel.prefetchTriggerID == nil)
  }
}
