import Observation

@MainActor
@Observable
final class ProductDetailViewModel {

  enum State: Equatable {
    case loading
    case loaded(Product)
    case failed(LoadFailure)
  }

  private(set) var state: State = .loading
  private let service: any ProductService

  init(service: any ProductService = ProductServiceImpl()) {
    self.service = service
  }

  func load(id: Product.ID) async {
    self.state = .loading

    do {
      self.state = .loaded(try await self.service.fetchProduct(id: id))
    } catch {
      self.state = .failed(LoadFailure(error))
    }
  }
}
