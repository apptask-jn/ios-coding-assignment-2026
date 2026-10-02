//
//  ProductDetailView.swift
//  ios-coding-assignment-2026
//
//  Created by Park Kwonyong on 10/1/26.
//

import SwiftUI

struct ProductDetailView: View {

  @State private var viewModel: ProductDetailViewModel

  init(container: AppContainer, productId: Int) {
    _viewModel = State(initialValue: container.makeProductDetailViewModel(productId: productId))
  }

  var body: some View {
    content
      .navigationTitle("상품 상세")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          FavoriteButton(productID: viewModel.productId)
        }
      }
      .task { await viewModel.loadIfNeeded() }
  }

  // MARK: - 상태별 화면
  @ViewBuilder
  private var content: some View {
    switch viewModel.state {
    case .idle, .loading:
      ProgressView()
        .frame(maxWidth: .infinity, maxHeight: .infinity)

    case .loaded(let product):
      detail(product)

    case .failed(let error):
      errorView(error)
    }
  }

  private func errorView(_ error: Error) -> some View {
    ContentUnavailableView {
      Label("상품 정보를 불러올 수 없습니다", systemImage: "wifi.exclamationmark")
    } description: {
      Text((error as? NetworkError)?.description ?? error.localizedDescription)
    } actions: {
      Button("다시 시도") {
        Task { await viewModel.loadProductDetail() }
      }
      .buttonStyle(.borderedProminent)
    }
  }

  // MARK: - 상세 본문
  private func detail(_ product: ProductResult) -> some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 20) {
        productImage(product)
        header(product)

        Divider()

        specifications(product)

        if !product.description.isEmpty {
          section("상품 설명") {
            Text(product.description)
              .font(.subheadline)
              .foregroundStyle(.secondary)
          }
        }

        if let reviews = product.reviews, !reviews.isEmpty {
          section("리뷰") {
            reviewList(reviews)
          }
        }
      }
      .padding(.bottom, 32)
    }
  }

  private func productImage(_ product: ProductResult) -> some View {
    AsyncImage(url: product.mainImageURL) { phase in
      switch phase {
      case .success(let image):
        image.resizable().scaledToFit()
      case .failure:
        Image(systemName: "photo")
          .font(.largeTitle)
          .foregroundStyle(.tertiary)
      default:
        ProgressView()
      }
    }
    .frame(maxWidth: .infinity)
    .frame(height: 280)
    .background(Color(.secondarySystemBackground))
  }

  private func header(_ product: ProductResult) -> some View {
    VStack(alignment: .leading, spacing: 8) {
      if let brand = product.brand {
        Text(brand)
          .font(.subheadline)
          .foregroundStyle(.secondary)
      }

      Text(product.title)
        .font(.title2.weight(.bold))

      priceRow(product)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal)
  }

  private func priceRow(_ product: ProductResult) -> some View {
    HStack(alignment: .firstTextBaseline, spacing: 8) {
      Text(product.formattedDiscountedPrice)
        .font(.title3.weight(.semibold))

      if product.hasDiscount {
        Text(product.formattedPrice)
          .font(.subheadline)
          .foregroundStyle(.secondary)
          .strikethrough()

        Text(product.formattedDiscountRate)
          .font(.caption.weight(.semibold))
          .foregroundStyle(.pink)
      }
    }
  }

  private func specifications(_ product: ProductResult) -> some View {
    VStack(spacing: 12) {
      specificationRow("평점") {
        HStack(spacing: 4) {
          Image(systemName: "star.fill")
            .foregroundStyle(.yellow)
          Text(product.formattedRating)
        }
      }

      specificationRow("재고") {
        Text(product.stockDescription)
      }
    }
    .padding(.horizontal)
  }

  private func reviewList(_ reviews: [ProductReview]) -> some View {
    VStack(spacing: 10) {
      ForEach(Array(reviews.prefix(3).enumerated()), id: \.offset) { _, review in
        reviewCard(review)
      }
    }
  }

  private func reviewCard(_ review: ProductReview) -> some View {
    VStack(alignment: .leading, spacing: 6) {
      HStack(spacing: 6) {
        Text(review.reviewerName)
          .font(.subheadline.weight(.semibold))

        Text("★ \(review.rating)")
          .font(.caption)
          .foregroundStyle(.secondary)
      }

      Text(review.comment)
        .font(.footnote)
        .foregroundStyle(.secondary)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(12)
    .background(Color(.secondarySystemBackground), in: .rect(cornerRadius: 10))
  }

  // MARK: - 조립 블록
  private func section<Content: View>(_ title: String,
                                      @ViewBuilder content: () -> Content) -> some View {
    VStack(alignment: .leading, spacing: 10) {
      Text(title)
        .font(.headline)
      content()
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal)
  }

  private func specificationRow<Value: View>(_ title: String,
                                             @ViewBuilder value: () -> Value) -> some View {
    HStack {
      Text(title)
        .foregroundStyle(.secondary)
      Spacer()
      value()
    }
    .font(.subheadline)
  }
}

#Preview {
  let container = AppContainer()

  NavigationStack {
    ProductDetailView(container: container, productId: 1)
  }
  .environment(container.favoriteStore)
}
