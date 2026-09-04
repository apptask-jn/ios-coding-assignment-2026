protocol ProductService: Sendable {
  func fetchProducts() async throws -> [Product]
  func fetchProduct(id: Int) async throws -> Product
}
