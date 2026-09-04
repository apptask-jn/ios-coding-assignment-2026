import Foundation

struct ProductListResponse: Decodable, Sendable {
  let products: [Product]
  let total: Int
}
