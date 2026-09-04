import SwiftUI

struct ProductListView: View {

  private enum Metric {
    static let itemSpacing: CGFloat = 16
  }

  @Environment(FavoriteStore.self) private var favoriteStore

  @State private var model = ProductListViewModel()

  var body: some View {
    Group {
      switch self.model.state {
      case .loading:
        ProgressView()

      case .loaded(let products):
        ScrollView {
          LazyVGrid(columns: [GridItem(.flexible())], spacing: Metric.itemSpacing) {
            ForEach(products) { product in
              ProductCell(
                product: product,
                isFavorite: self.favoriteStore.contains(product.id),
                toggleFavorite: { self.favoriteStore.toggle(product.id) }
              )
            }
          }
          .padding()
        }

      case .failed(let failure):
        ContentUnavailableView {
          Label("상품을 불러오지 못했어요", systemImage: "exclamationmark.triangle")
        } description: {
          Text(failure.message)
        } actions: {
          Button("다시 시도") {
            Task { await self.model.load() }
          }
          .buttonStyle(.borderedProminent)
        }
      }
    }
    .navigationTitle("상품 목록")
    .task { await self.model.load() }
  }
}

#Preview {
  NavigationStack {
    ProductListView()
  }
  .environment(FavoriteStore())
}
