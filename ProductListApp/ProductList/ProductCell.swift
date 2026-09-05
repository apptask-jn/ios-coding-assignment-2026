import Kingfisher
import SwiftUI

struct ProductCell: View {

  // MARK: Constants

  private enum Metric {
    static let compactThumbnailWidth: CGFloat = 88
    static let compactThumbnailHeight: CGFloat = 88
    static let regularThumbnailHeight: CGFloat = 140
    static let contentSpacing: CGFloat = 12
    static let textSpacing: CGFloat = 4
    static let cornerRadius: CGFloat = 16
    static let contentPadding: CGFloat = 16
    static let favoriteButtonInset: CGFloat = 4
    static let favoriteButtonReservedWidth =
      FavoriteButton.touchTargetSize + favoriteButtonInset - contentPadding
  }


  // MARK: Properties

  let product: Product
  let layoutMode: ProductListLayoutMode


  // MARK: Layout

  var body: some View {
    NavigationLink(value: self.product.id) {
      self.stackLayout {
        KFImage(self.product.thumbnailURL)
          .placeholder { ProgressView() }
          .onFailureView { Image(systemName: "photo").foregroundStyle(.secondary) }
          .resizable()
          .scaledToFit()
          .frame(
            maxWidth: self.thumbnailMaxWidth,
            minHeight: self.thumbnailHeight,
            maxHeight: self.thumbnailHeight
          )

        VStack(alignment: .leading, spacing: Metric.textSpacing) {
          Text(self.product.category.capitalized)
            .font(.caption)
            .foregroundStyle(.secondary)

          Text(self.product.title)
            .font(.headline)
            .lineLimit(2)

          Text(self.product.price, format: .currency(code: "USD"))
            .font(.subheadline)
            .bold()
        }
        .padding(.trailing, self.textTrailingPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
      }
      .padding(Metric.contentPadding)
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      .contentShape(.rect)
    }
    .buttonStyle(.plain)
    .accessibilityIdentifier("product-cell-\(self.product.id)")
    .overlay(alignment: self.favoriteAlignment) {
      ProductFavoriteButton(productID: self.product.id)
        .padding(self.favoriteButtonPadding)
        .accessibilityIdentifier("list-favorite-\(self.product.id)")
    }
    .background(.background.secondary, in: .rect(cornerRadius: Metric.cornerRadius))
  }
}

extension ProductCell {

  // MARK: UI Properties

  private var stackLayout: AnyLayout {
    switch self.layoutMode {
    case .oneColumn:
      AnyLayout(HStackLayout(alignment: .top, spacing: Metric.contentSpacing))
    case .twoColumn:
      AnyLayout(VStackLayout(alignment: .leading, spacing: Metric.contentSpacing))
    }
  }

  private var favoriteAlignment: Alignment {
    switch self.layoutMode {
    case .oneColumn: .trailing
    case .twoColumn: .topTrailing
    }
  }

  private var favoriteButtonPadding: EdgeInsets {
    switch self.layoutMode {
    case .oneColumn:
      EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: Metric.favoriteButtonInset)
    case .twoColumn:
      EdgeInsets(
        top: Metric.contentPadding + Metric.regularThumbnailHeight
          - FavoriteButton.touchTargetSize / 2,
        leading: 0,
        bottom: 0,
        trailing: Metric.favoriteButtonInset
      )
    }
  }

  private var textTrailingPadding: CGFloat {
    switch self.layoutMode {
    case .oneColumn: Metric.favoriteButtonReservedWidth
    case .twoColumn: 0
    }
  }

  private var thumbnailMaxWidth: CGFloat {
    switch self.layoutMode {
    case .oneColumn: Metric.compactThumbnailWidth
    case .twoColumn: .infinity
    }
  }

  private var thumbnailHeight: CGFloat {
    switch self.layoutMode {
    case .oneColumn: Metric.compactThumbnailHeight
    case .twoColumn: Metric.regularThumbnailHeight
    }
  }
}
