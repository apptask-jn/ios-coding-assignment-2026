import SwiftUI

struct ProductFavoriteButton: View {

  // MARK: Properties

  let productID: Product.ID
  @Environment(FavoriteStore.self) private var favoriteStore


  // MARK: Layout

  var body: some View {
    FavoriteButton(
      isFavorite: self.favoriteStore.contains(self.productID),
      toggle: { self.favoriteStore.toggle(self.productID) }
    )
  }
}
