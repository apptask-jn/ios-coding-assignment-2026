import SwiftUI

struct ProductDetailView: View {

  // MARK: Properties

  let productID: Product.ID
  @State private var viewModel = ProductDetailViewModel()


  // MARK: Layout

  var body: some View {
    Group {
      switch self.viewModel.state {
      case .loading:
        ProgressView()

      case .loaded(let product):
        ProductDetailContentView(product: product)

      case .failed(let failure):
        ContentUnavailableView {
          Label("상품 정보를 불러오지 못했어요", systemImage: "exclamationmark.triangle")
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
    .navigationTitle("상품 상세")
    .navigationBarTitleDisplayMode(.inline)
    .task { await self.viewModel.load(id: self.productID) }
  }
}

extension ProductDetailView {

  // MARK: Actions

  private func retry() {
    Task { await self.viewModel.load(id: self.productID) }
  }
}
