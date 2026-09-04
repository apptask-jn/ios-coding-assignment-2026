import SwiftUI

struct ProductListLayoutModeToggleButton: View {

  // MARK: Properties

  @Binding var layoutMode: ProductListLayoutMode


  // MARK: Layout

  var body: some View {
    Button(self.layoutMode.toggled.switchTitle, systemImage: self.layoutMode.toggled.symbolName) {
      self.layoutMode = self.layoutMode.toggled
    }
    .labelStyle(.iconOnly)
    .foregroundStyle(.secondary)
    .buttonStyle(.plain)
    .frame(minWidth: 44, minHeight: 44)
    .contentShape(.rect)
  }
}

#Preview {
  @Previewable @State var layoutMode: ProductListLayoutMode = .oneColumn
  ProductListLayoutModeToggleButton(layoutMode: $layoutMode)
}
