import Foundation

final class FavoriteStorageImpl: FavoriteStorage {

  private enum Key {
    static let favoriteIDs = "favoriteProductIDs"
  }

  private let defaults: UserDefaults

  init(defaults: UserDefaults = .standard) {
    self.defaults = defaults
  }

  func loadFavoriteIDs() -> Set<Int> {
    guard let ids = self.defaults.array(forKey: Key.favoriteIDs) as? [Int] else {
      return []
    }
    return Set(ids)
  }

  func save(favoriteIDs: Set<Int>) {
    self.defaults.set(Array(favoriteIDs), forKey: Key.favoriteIDs)
  }
}
