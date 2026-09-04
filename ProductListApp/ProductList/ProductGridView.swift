import SwiftUI

struct ProductGridView: View {

  // MARK: Properties

  let products: [Product]
  let prefetchTriggerID: Product.ID?
  let isLoadingMore: Bool
  let loadNextPage: () -> Void
  @Binding var layoutMode: ProductListLayoutMode


  // MARK: Layout

  var body: some View {
    ScrollView {
      VStack(spacing: ProductListLayoutMode.itemSpacing) {
        HStack {
          Spacer()
          ProductListLayoutModeToggleButton(layoutMode: self.$layoutMode)
        }

        LazyVGrid(columns: self.layoutMode.columns, spacing: ProductListLayoutMode.itemSpacing) {
          ForEach(self.products) { product in
            ProductCell(product: product, layoutMode: self.layoutMode)
              .onAppear { self.loadNextPageIfNeeded(for: product) }
          }
        }

        if self.isLoadingMore {
          ProgressView()
        }
      }
      .padding()
    }
  }
}

extension ProductGridView {

  // MARK: Actions

  private func loadNextPageIfNeeded(for product: Product) {
    guard product.id == self.prefetchTriggerID else { return }
    self.loadNextPage()
  }
}

#Preview {
  @Previewable @State var layoutMode: ProductListLayoutMode = .oneColumn
  ProductGridView(
    products: [],
    prefetchTriggerID: nil,
    isLoadingMore: false,
    loadNextPage: {},
    layoutMode: $layoutMode
  )
  .environment(FavoriteStore())
}
