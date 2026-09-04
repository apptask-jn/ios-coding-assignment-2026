protocol FavoriteStorage {
  func loadFavoriteIDs() -> Set<Int>
  func save(favoriteIDs: Set<Int>)
}
