protocol ProductService: Sendable {
  func fetchProducts(skip: Int) async throws -> ProductListResponse
  func fetchProduct(id: Int) async throws -> Product
}
