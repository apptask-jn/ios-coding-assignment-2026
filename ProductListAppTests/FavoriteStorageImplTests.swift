import Foundation
import Testing

@testable import ProductListApp

struct FavoriteStorageImplTests {

  @Test
  func loadsEmptySetWhenNothingSaved() throws {
    let suiteName = "FavoriteStorageImplTests-\(UUID().uuidString)"
    let defaults = try #require(UserDefaults(suiteName: suiteName))
    defer { defaults.removePersistentDomain(forName: suiteName) }

    #expect(FavoriteStorageImpl(defaults: defaults).loadFavoriteIDs().isEmpty)
  }

  @Test
  func loadsIDsSavedByAnotherInstance() throws {
    let suiteName = "FavoriteStorageImplTests-\(UUID().uuidString)"
    let defaults = try #require(UserDefaults(suiteName: suiteName))
    defer { defaults.removePersistentDomain(forName: suiteName) }

    FavoriteStorageImpl(defaults: defaults).save(favoriteIDs: [1, 3])

    #expect(FavoriteStorageImpl(defaults: defaults).loadFavoriteIDs() == [1, 3])
  }
}
