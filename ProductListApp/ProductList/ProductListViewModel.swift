import Observation

@MainActor
@Observable
final class ProductListViewModel {

  enum State: Equatable {
    case loading
    case loaded([Product], hasMore: Bool)
    case failed(LoadFailure)
  }

  private enum Paging {
    static let prefetchThreshold = 8
  }

  private(set) var state: State = .loading

  private(set) var isLoadingMore = false

  private let service: any ProductService

  init(service: any ProductService = ProductServiceImpl()) {
    self.service = service
  }

  var prefetchTriggerID: Product.ID? {
    guard case .loaded(let products, hasMore: true) = self.state, !products.isEmpty else {
      return nil
    }
    return products[max(0, products.count - Paging.prefetchThreshold)].id
  }

  func load() async {
    if case .loaded = self.state { return }

    self.state = .loading

    do {
      let response = try await self.service.fetchProducts(skip: 0)
      self.state = .loaded(response.products, hasMore: response.products.count < response.total)
    } catch {
      self.state = .failed(LoadFailure(error))
    }
  }

  func loadNextPage() async {
    guard case .loaded(let products, hasMore: true) = self.state, !self.isLoadingMore else {
      return
    }

    self.isLoadingMore = true
    defer { self.isLoadingMore = false }

    guard let response = try? await self.service.fetchProducts(skip: products.count) else {
      return
    }

    let merged = products + response.products
    self.state = .loaded(merged, hasMore: merged.count < response.total)
  }
}
