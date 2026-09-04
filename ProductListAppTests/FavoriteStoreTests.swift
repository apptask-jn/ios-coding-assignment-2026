import Testing

@testable import ProductListApp

@MainActor
struct FavoriteStoreTests {

  @Test
  func restoresSavedIDsOnInit() {
    let store = FavoriteStore(storage: StubFavoriteStorage(favoriteIDs: [1, 3]))

    #expect(store.contains(1))
    #expect(store.contains(3))
    #expect(!store.contains(2))
  }

  @Test
  func toggleAddsProductThatIsNotFavorited() {
    let store = FavoriteStore(storage: StubFavoriteStorage())

    store.toggle(1)

    #expect(store.contains(1))
  }

  @Test
  func toggleRemovesProductThatIsAlreadyFavorited() {
    let store = FavoriteStore(storage: StubFavoriteStorage(favoriteIDs: [1]))

    store.toggle(1)

    #expect(!store.contains(1))
  }

  @Test
  func keepsFavoritesAcrossStoreInstances() {
    let storage = StubFavoriteStorage()
    FavoriteStore(storage: storage).toggle(1)

    let relaunchedStore = FavoriteStore(storage: storage)

    #expect(relaunchedStore.contains(1))
  }

  @Test
  func togglingOneProductDoesNotAffectAnother() {
    let store = FavoriteStore(storage: StubFavoriteStorage(favoriteIDs: [1]))

    store.toggle(2)

    #expect(store.contains(1))
    #expect(store.contains(2))
  }

  @Test
  func toggleSavesToStorageImmediately() {
    let storage = StubFavoriteStorage()
    let store = FavoriteStore(storage: storage)

    store.toggle(1)

    #expect(storage.loadFavoriteIDs() == [1])
  }
}
