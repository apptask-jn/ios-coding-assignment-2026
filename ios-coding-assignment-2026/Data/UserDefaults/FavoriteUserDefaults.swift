//
//  FavoriteUserDefaults.swift
//  ios-coding-assignment-2026
//
//  Created by Park Kwonyong on 10/1/26.
//

import Foundation

protocol FavoriteUserDefaultsProtocol: Sendable {
  func load() -> Set<Int>
  func toggle(_ id: Int) -> Set<Int>
}

struct FavoriteUserDefaults: FavoriteUserDefaultsProtocol, @unchecked Sendable {

  private let defaults: UserDefaults
  private let key: String

  init(defaults: UserDefaults = .standard, key: String = "favoriteProductIds") {
    self.defaults = defaults
    self.key = key
  }

  // MARK: - 읽기
  func load() -> Set<Int> {
    let stored = defaults.array(forKey: key) as? [Int] ?? []
    return Set(stored)
  }

  // MARK: - 토글
  func toggle(_ id: Int) -> Set<Int> {
    var ids = load()
    
    if ids.contains(id) {
      ids.remove(id)
    } else {
      ids.insert(id)
    }

    save(ids)
    return ids
  }

  // MARK: - 쓰기 (내부 전용)
  private func save(_ ids: Set<Int>) {
    defaults.set(ids.sorted(), forKey: key)
  }
}
