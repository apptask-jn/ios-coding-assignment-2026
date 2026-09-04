@testable import ProductListApp

final class StubFavoriteStorage: FavoriteStorage {

  private var favoriteIDs: Set<Int>

  init(favoriteIDs: Set<Int> = []) {
    self.favoriteIDs = favoriteIDs
  }

  func loadFavoriteIDs() -> Set<Int> {
    self.favoriteIDs
  }

  func save(favoriteIDs: Set<Int>) {
    self.favoriteIDs = favoriteIDs
  }
}
