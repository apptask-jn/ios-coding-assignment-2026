import Observation

@MainActor
@Observable
final class ProductListViewModel {

  enum State: Equatable {
    case loading
    case loaded([Product])
    case failed(LoadFailure)
  }

  private(set) var state: State = .loading

  private let service: any ProductService

  init(service: any ProductService = ProductServiceImpl()) {
    self.service = service
  }

  func load() async {
    if case .loaded = self.state { return }

    self.state = .loading

    do {
      self.state = .loaded(try await self.service.fetchProducts())
    } catch {
      self.state = .failed(LoadFailure(error))
    }
  }
}
