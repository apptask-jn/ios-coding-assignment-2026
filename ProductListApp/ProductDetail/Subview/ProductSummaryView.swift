import SwiftUI

struct ProductSummaryView: View {

  // MARK: Constants

  private enum Metric {
    static let textSpacing: CGFloat = 6
  }


  // MARK: Properties

  let product: Product


  // MARK: Layout

  var body: some View {
    VStack(alignment: .leading, spacing: Metric.textSpacing) {
      Text(self.headline)
        .font(.subheadline)
        .foregroundStyle(.secondary)

      Text(self.product.title)
        .font(.title2)
        .bold()

      HStack {
        Text(self.product.price, format: .currency(code: "USD"))
          .font(.title3)
          .bold()

        Spacer()

        ProductFavoriteButton(productID: self.product.id)
      }
    }
  }
}

extension ProductSummaryView {

  // MARK: Formatting

  private var headline: String {
    guard let brand = self.product.brand else {
      return self.product.category.capitalized
    }
    return "\(self.product.category.capitalized) · \(brand)"
  }
}
