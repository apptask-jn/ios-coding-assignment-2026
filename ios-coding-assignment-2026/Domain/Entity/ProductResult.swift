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

struct ProductResult: Decodable, Sendable {
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

struct ProductReview: Decodable, Sendable {
  let reviewerName: String
  let rating: Int
  let comment: String
}
