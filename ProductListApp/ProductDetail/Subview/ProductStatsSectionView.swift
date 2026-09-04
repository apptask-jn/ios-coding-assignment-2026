import SwiftUI

struct ProductStatsSectionView: View {

  // MARK: Properties

  let product: Product


  // MARK: Layout

  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      LabeledContent("평점") {
        Text(self.product.rating, format: .number.precision(.fractionLength(1)))
      }
      LabeledContent("할인율") {
        Text(
          self.product.discountPercentage / 100,
          format: .percent.precision(.fractionLength(1))
        )
      }
      LabeledContent("재고") {
        Text(self.product.stock, format: .number)
      }
    }
    .font(.subheadline)
  }
}
