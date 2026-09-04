import SwiftUI

struct ProductDescriptionSectionView: View {

  // MARK: Constants

  private enum Metric {
    static let textSpacing: CGFloat = 6
  }


  // MARK: Properties

  let description: String


  // MARK: Layout

  var body: some View {
    VStack(alignment: .leading, spacing: Metric.textSpacing) {
      Text("상품 설명")
        .font(.headline)

      Text(self.description)
        .foregroundStyle(.secondary)
    }
  }
}
