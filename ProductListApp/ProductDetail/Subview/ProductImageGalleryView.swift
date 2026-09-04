import Kingfisher
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
          KFImage(url)
            .placeholder { ProgressView() }
            .onFailureView { Image(systemName: "photo").foregroundStyle(.secondary) }
            .resizable()
            .scaledToFit()
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
