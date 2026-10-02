//
//  ProductListView.swift
//  ios-coding-assignment-2026
//
//  Created by Park Kwonyong on 10/1/26.
//

import SwiftUI

struct ProductListView: View {

  @State private var viewModel: ProductListViewModel

  @AppStorage("productListLayout") private var layout: ProductListLayout = .list

  private let container: AppContainer

  init(container: AppContainer) {
    self.container = container
    _viewModel = State(initialValue: container.makeProductListViewModel())
  }

  var body: some View {
    content
      .navigationTitle("상품")
      .toolbar { layoutToggleButton }
      .task { await viewModel.loadIfNeeded() }
      .navigationDestination(for: Int.self) { productId in
        ProductDetailView(container: container, productId: productId)
      }
  }

  // MARK: - 상태별 화면
  @ViewBuilder
  private var content: some View {
    switch viewModel.state {
    case .idle, .loading:
      ProgressView("상품을 불러오는 중…")
        .frame(maxWidth: .infinity, maxHeight: .infinity)

    case .loaded(let products) where products.isEmpty:
      ContentUnavailableView("표시할 상품이 없습니다", systemImage: "shippingbox")

    case .loaded(let products):
      productGrid(products)

    case .failed(let error):
      errorView(error)
    }
  }

  private func productGrid(_ products: [ProductResult]) -> some View {
    ScrollView {
      LazyVGrid(columns: gridColumns, spacing: 12) {
        ForEach(products) { product in
          ProductCell(product: product, layout: layout)
        }
      }
      .padding(12)
      .animation(.snappy, value: layout)
    }
  }

  private var gridColumns: [GridItem] {
    Array(repeating: GridItem(.flexible(), spacing: 12), count: layout.columnCount)
  }

  private func errorView(_ error: Error) -> some View {
    ContentUnavailableView {
      Label("상품을 불러올 수 없습니다", systemImage: "wifi.exclamationmark")
    } description: {
      Text((error as? NetworkError)?.description ?? error.localizedDescription)
    } actions: {
      Button("다시 시도") {
        Task { await viewModel.loadProductList() }
      }
      .buttonStyle(.borderedProminent)
    }
  }

  // MARK: - 툴바
  @ToolbarContentBuilder
  private var layoutToggleButton: some ToolbarContent {
    ToolbarItem(placement: .topBarTrailing) {
      Button {
        layout = layout.toggled
      } label: {
        Image(systemName: layout.toggleSymbolName)
      }
      .accessibilityLabel(layout.toggleAccessibilityLabel)
    }
  }
}

// MARK: - 보기 방식
enum ProductListLayout: Int {
  case list = 1   // 1열 (리스트형)
  case grid = 2   // 2열 (그리드형)

  var columnCount: Int { rawValue }

  var toggled: ProductListLayout {
    self == .list ? .grid : .list
  }

  var toggleSymbolName: String {
    switch self {
    case .list: "square.grid.2x2"
    case .grid: "list.bullet"
    }
  }

  var toggleAccessibilityLabel: String {
    switch self {
    case .list: "2열 그리드로 보기"
    case .grid: "1열 리스트로 보기"
    }
  }
}

// MARK: - 목록 셀
struct ProductCell: View {

  let product: ProductResult
  let layout: ProductListLayout

  var body: some View {
    ZStack(alignment: .topTrailing) {
      NavigationLink(value: product.id) {
        cellContent
      }
      .buttonStyle(.plain)

      FavoriteButton(productID: product.id)
        .padding(4)
    }
  }

  // MARK: 셀 본문
  private var cellContent: some View {
    stackLayout {
      thumbnail
      information
    }
    .padding(8)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Color(.secondarySystemBackground), in: .rect(cornerRadius: 12))
    .contentShape(.rect)
  }

  private var stackLayout: AnyLayout {
    switch layout {
    case .list:
      AnyLayout(HStackLayout(alignment: .top, spacing: 12))
    case .grid:
      AnyLayout(VStackLayout(alignment: .leading, spacing: 8))
    }
  }

  private var thumbnail: some View {
    AsyncImage(url: product.thumbnailURL) { phase in
      switch phase {
      case .success(let image):
        image.resizable().scaledToFit()
      case .failure:
        Image(systemName: "photo").foregroundStyle(.tertiary)
      default:
        ProgressView()
      }
    }
    .frame(width: isList ? 96 : nil, height: isList ? 96 : nil)
    .frame(maxWidth: isList ? nil : .infinity)
    .aspectRatio(isList ? nil : 1, contentMode: .fit)
    .background(Color(.tertiarySystemBackground))
    .clipShape(.rect(cornerRadius: 8))
  }

  private var information: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(product.title)
        .font(.subheadline.weight(.semibold))
        .lineLimit(2, reservesSpace: layout == .grid)
        .multilineTextAlignment(.leading)

      if let brand = product.brand {
        Text(brand)
          .font(.caption)
          .foregroundStyle(.secondary)
          .lineLimit(1)
      }

      Text(product.formattedPrice)
        .font(.callout.weight(.semibold))
        .lineLimit(1)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.trailing, isList ? 44 : 0)
  }

  private var isList: Bool {
    layout == .list
  }
}

#Preview {
  let container = AppContainer()

  NavigationStack {
    ProductListView(container: container)
  }
  .environment(container.favoriteStore)
}
