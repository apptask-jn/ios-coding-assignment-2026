import SwiftUI

struct ProductListView: View {

  @Environment(FavoriteStore.self) private var favoriteStore

  @State private var model = ProductListViewModel()
  @State private var layout: ProductListLayout = .oneColumn

  var body: some View {
    Group {
      switch self.model.state {
      case .loading:
        ProgressView()

      case .loaded(let products):
        ScrollView {
          LazyVGrid(columns: self.layout.columns, spacing: ProductListLayout.itemSpacing) {
            ForEach(products) { product in
              ProductCell(
                product: product,
                layout: self.layout,
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
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button(self.layout.toggled.switchTitle, systemImage: self.layout.toggled.symbolName) {
          self.layout = self.layout.toggled
        }
      }
    }
    .task { await self.model.load() }
  }
}

#Preview {
  NavigationStack {
    ProductListView()
  }
  .environment(FavoriteStore())
}
