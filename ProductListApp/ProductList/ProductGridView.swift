import SwiftUI

struct ProductGridView: View {

  // MARK: Properties

  let products: [Product]

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
          }
        }
      }
      .padding()
    }
  }
}

#Preview {
  @Previewable @State var layoutMode: ProductListLayoutMode = .oneColumn
  ProductGridView(products: [], layoutMode: $layoutMode)
    .environment(FavoriteStore())
}
