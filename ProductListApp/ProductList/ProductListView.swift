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

      case .loaded(let products, _):
        ProductGridView(
          products: products,
          prefetchTriggerID: self.viewModel.prefetchTriggerID,
          isLoadingMore: self.viewModel.isLoadingMore,
          loadNextPage: self.loadNextPage,
          layoutMode: self.$layoutMode
        )

      case .failed(let failure):
        ContentUnavailableView {
          Label("상품을 불러오지 못했어요", systemImage: "exclamationmark.triangle")
        } description: {
          Text(failure.message)
        } actions: {
          if failure.isRetryable {
            Button("다시 시도", action: self.retry)
              .buttonStyle(.borderedProminent)
          }
        }
      }
    }
    .navigationTitle("상품 목록")
    .navigationBarTitleDisplayMode(.large)
    .navigationDestination(for: Product.ID.self) { productID in
      ProductDetailView(productID: productID)
    }
    .task { await self.viewModel.load() }
  }
}

extension ProductListView {

  // MARK: Actions

  private func retry() {
    Task { await self.viewModel.load() }
  }

  private func loadNextPage() {
    Task { await self.viewModel.loadNextPage() }
  }
}

#Preview {
  NavigationStack {
    ProductListView()
  }
  .environment(FavoriteStore())
}
