import SwiftUI

struct RootView: View {

  var body: some View {
    NavigationStack {
      ProductListView()
    }
  }
}

#Preview {
  RootView()
    .environment(FavoriteStore())
}
