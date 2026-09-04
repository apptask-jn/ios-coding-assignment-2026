import SwiftUI

struct ProductCell: View {

  private enum Metric {
    static let thumbnailSize: CGFloat = 88
    static let contentSpacing: CGFloat = 12
    static let textSpacing: CGFloat = 4
    static let cornerRadius: CGFloat = 16
  }

  let product: Product
  let isFavorite: Bool
  let toggleFavorite: () -> Void

  var body: some View {
    HStack(alignment: .top, spacing: Metric.contentSpacing) {
      AsyncImage(url: self.product.thumbnailURL) { image in
        image
          .resizable()
          .scaledToFit()
      } placeholder: {
        ProgressView()
      }
      .frame(width: Metric.thumbnailSize, height: Metric.thumbnailSize)

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

      Spacer(minLength: 0)

      FavoriteButton(isFavorite: self.isFavorite, toggle: self.toggleFavorite)
    }
    .padding()
    .background(.background.secondary, in: .rect(cornerRadius: Metric.cornerRadius))
  }
}
