import SwiftUI

struct FavoriteButton: View {

  // MARK: Constants

  nonisolated static let touchTargetSize: CGFloat = 44


  // MARK: Properties

  let isFavorite: Bool
  let toggle: () -> Void


  // MARK: Layout

  var body: some View {
    Button(
      self.isFavorite ? "찜 해제" : "찜하기",
      systemImage: self.isFavorite ? "heart.fill" : "heart",
      action: self.toggle
    )
    .labelStyle(.iconOnly)
    .font(.title3)
    .foregroundStyle(self.isFavorite ? Color.red : .secondary)
    .buttonStyle(.plain)
    .frame(minWidth: Self.touchTargetSize, minHeight: Self.touchTargetSize)
    .contentShape(.rect)
  }
}

#Preview {
  VStack {
    FavoriteButton(isFavorite: true, toggle: {})
    FavoriteButton(isFavorite: false, toggle: {})
  }
}
