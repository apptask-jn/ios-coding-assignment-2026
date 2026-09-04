import Foundation

struct Product: Decodable, Identifiable, Equatable, Sendable {

  let id: Int
  let title: String
  let description: String
  let category: String
  let brand: String?
  let price: Double
  let discountPercentage: Double
  let rating: Double
  let stock: Int
  let thumbnailURL: URL
  let imageURLs: [URL]

  private enum CodingKeys: String, CodingKey {
    case id
    case title
    case description
    case category
    case brand
    case price
    case discountPercentage
    case rating
    case stock
    case thumbnailURL = "thumbnail"
    case imageURLs = "images"
  }
}
