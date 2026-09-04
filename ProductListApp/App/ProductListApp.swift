import SwiftUI

@main
struct ProductListApp: App {

  @State private var favoriteStore = FavoriteStore()

  var body: some Scene {
    WindowGroup {
      RootView()
        .environment(self.favoriteStore)
    }
  }
}
