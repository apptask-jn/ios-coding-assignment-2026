import SwiftUI

struct ProductListView: View {

  // MARK: Properties

  @Environment(FavoriteStore.self) private var favoriteStore
  @State private var viewModel = ProductListViewModel()
  @State private var layoutMode: ProductListLayoutMode = .oneColumn


  // MARK: Layout

  var body: some View {
    Group {
      switch self.viewModel.state {
      case .loading:
        ProgressView()

      case .loaded(let products):
        ScrollView {
          LazyVGrid(columns: self.layoutMode.columns, spacing: ProductListLayoutMode.itemSpacing) {
            ForEach(products) { product in
              ProductCell(
                product: product,
                layoutMode: self.layoutMode,
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
            Task { await self.viewModel.load() }
          }
          .buttonStyle(.borderedProminent)
        }
      }
    }
    .navigationTitle("상품 목록")
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button(
          self.layoutMode.toggled.switchTitle,
          systemImage: self.layoutMode.toggled.symbolName
        ) {
          self.layoutMode = self.layoutMode.toggled
        }
      }
    }
    .task { await self.viewModel.load() }
  }
}

#Preview {
  NavigationStack {
    ProductListView()
  }
  .environment(FavoriteStore())
}
