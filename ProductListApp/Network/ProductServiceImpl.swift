import Foundation

final class ProductServiceImpl: ProductService {

  private static let baseURL = URL(string: "https://dummyjson.com/products")!
  private let session: URLSession

  init(session: URLSession = .shared) {
    self.session = session
  }

  func fetchProducts() async throws -> [Product] {
    let response: ProductListResponse = try await self.get(from: Self.baseURL)
    return response.products
  }

  func fetchProduct(id: Int) async throws -> Product {
    try await self.get(from: Self.baseURL.appending(path: String(id)))
  }

  private func get<Response: Decodable>(from url: URL) async throws -> Response {
    let (data, response) = try await self.session.data(from: url)

    guard let httpResponse = response as? HTTPURLResponse else {
      throw ProductServiceError.invalidResponse
    }
    guard (200..<300).contains(httpResponse.statusCode) else {
      throw ProductServiceError.unsuccessfulStatusCode(httpResponse.statusCode)
    }

    return try JSONDecoder().decode(Response.self, from: data)
  }
}
