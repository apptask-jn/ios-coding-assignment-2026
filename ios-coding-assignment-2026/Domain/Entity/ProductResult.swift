//
//  ProductResult.swift
//  ios-coding-assignment-2026
//
//  Created by Park Kwonyong on 10/1/26.
//

import Foundation

struct ProductResponseResult: Decodable, Sendable {
  let products: [ProductResult]
  let total: Int
  let skip: Int
  let limit: Int
}

struct ProductResult: Decodable, Sendable, Identifiable {
  let id: Int
  let title: String
  let description: String

  let brand: String?

  let price: Double
  let discountPercentage: Double
  let rating: Double
  let stock: Int

  let availabilityStatus: String?
  let thumbnail: String?
  let images: [String]?
  let reviews: [ProductReview]?
}

// MARK: - 화면 표시용 파생 값
extension ProductResult {
  var thumbnailURL: URL? {
    guard let thumbnail else { return nil }
    return URL(string: thumbnail)
  }

  var mainImageURL: URL? {
    guard let first = images?.first, let url = URL(string: first) else { return thumbnailURL }
    return url
  }

  var discountedPrice: Double {
    price * (1 - discountPercentage / 100)
  }

  var hasDiscount: Bool {
    discountPercentage > 0
  }

  var formattedPrice: String {
    price.formatted(.currency(code: Self.currencyCode))
  }

  var formattedDiscountedPrice: String {
    discountedPrice.formatted(.currency(code: Self.currencyCode))
  }

  var formattedDiscountRate: String {
    discountPercentage.formatted(.number.precision(.fractionLength(0))) + "% 할인"
  }

  var formattedRating: String {
    rating.formatted(.number.precision(.fractionLength(2)))
  }

  var stockDescription: String {
    let count = "\(stock)개"
    guard let status = availabilityStatus, !status.isEmpty else { return count }
    return "\(count) · \(status)"
  }

  private static let currencyCode = "USD"
}

struct ProductReview: Decodable, Sendable {
  let reviewerName: String
  let rating: Int
  let comment: String
}
