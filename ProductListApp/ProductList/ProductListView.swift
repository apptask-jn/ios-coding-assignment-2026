import SwiftUI

struct ProductListView: View {

  // MARK: Properties

  @State private var viewModel = ProductListViewModel()
  @State private var layoutMode: ProductListLayoutMode = .oneColumn


  // MARK: Layout

  var body: some View {
    Group {
      switch self.viewModel.state {
      case .loading:
        ProgressView()

      case .loaded(let products):
        ProductGridView(products: products, layoutMode: self.$layoutMode)

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
    .task { await self.viewModel.load() }
  }
}

#Preview {
  NavigationStack {
    ProductListView()
  }
  .environment(FavoriteStore())
}
