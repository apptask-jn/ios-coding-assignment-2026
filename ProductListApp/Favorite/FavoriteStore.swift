import Observation

@MainActor
@Observable
final class FavoriteStore {

  private var favoriteIDs: Set<Int>
  private let storage: any FavoriteStorage

  init(storage: any FavoriteStorage = FavoriteStorageImpl()) {
    self.storage = storage
    self.favoriteIDs = storage.loadFavoriteIDs()
  }

  func contains(_ productID: Int) -> Bool {
    self.favoriteIDs.contains(productID)
  }

  func toggle(_ productID: Int) {
    if self.favoriteIDs.contains(productID) {
      self.favoriteIDs.remove(productID)
    } else {
      self.favoriteIDs.insert(productID)
    }
    self.storage.save(favoriteIDs: self.favoriteIDs)
  }
}
