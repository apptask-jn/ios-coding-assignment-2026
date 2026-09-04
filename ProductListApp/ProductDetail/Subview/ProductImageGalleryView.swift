import SwiftUI

struct ProductImageGalleryView: View {

  // MARK: Constants

  private enum Metric {
    static let height: CGFloat = 300
  }


  // MARK: Properties

  let imageURLs: [URL]


  // MARK: Layout

  var body: some View {
    ScrollView(.horizontal) {
      LazyHStack(spacing: 0) {
        ForEach(self.imageURLs, id: \.self) { url in
          AsyncImage(url: url) { image in
            image
              .resizable()
              .scaledToFit()
          } placeholder: {
            ProgressView()
          }
          .containerRelativeFrame(.horizontal)
        }
      }
      .scrollTargetLayout()
    }
    .scrollTargetBehavior(.viewAligned)
    .scrollIndicators(.hidden)
    .frame(height: Metric.height)
  }
}
