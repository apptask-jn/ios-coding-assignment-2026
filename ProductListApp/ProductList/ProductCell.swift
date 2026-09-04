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
  }


  // MARK: Properties

  let product: Product
  let layoutMode: ProductListLayoutMode
  let isFavorite: Bool
  let toggleFavorite: () -> Void


  // MARK: Layout

  var body: some View {
    self.stackLayout {
      AsyncImage(url: self.product.thumbnailURL) { image in
        image
          .resizable()
          .scaledToFit()
      } placeholder: {
        ProgressView()
      }
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
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .overlay(alignment: self.favoriteAlignment) {
      FavoriteButton(isFavorite: self.isFavorite, toggle: self.toggleFavorite)
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
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
    case .twoColumn: .bottomTrailing
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
