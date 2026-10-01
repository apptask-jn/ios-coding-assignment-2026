//
//  FavoriteUserDefaults.swift
//  ios-coding-assignment-2026
//
//  Created by Park Kwonyong on 10/1/26.
//

import Foundation

protocol FavoriteUserDefaultsProtocol: Sendable {
  func load() -> Set<Int>
  func save(_ ids: Set<Int>)
}

struct FavoriteUserDefaults: FavoriteUserDefaultsProtocol {

  private let defaults: UserDefaults
  private let key: String

  init(defaults: UserDefaults = .standard, key: String = "favoriteProductIds") {
    self.defaults = defaults
    self.key = key
  }

  func load() -> Set<Int> {
    let stored = defaults.array(forKey: key) as? [Int] ?? []
    return Set(stored)
  }

  func save(_ ids: Set<Int>) {
    defaults.set(ids.sorted(), forKey: key)
  }
}
