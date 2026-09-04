import SwiftUI

struct ProductDetailContentView: View {

  // MARK: Constants

  private enum Metric {
    static let sectionSpacing: CGFloat = 20
  }


  // MARK: Properties

  let product: Product


  // MARK: Layout

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: Metric.sectionSpacing) {
        ProductImageGalleryView(imageURLs: self.product.imageURLs)
        ProductSummaryView(product: self.product)
        Divider()
        ProductStatsSectionView(product: self.product)
        Divider()
        ProductDescriptionSectionView(description: self.product.description)
      }
      .padding()
    }
  }
}
