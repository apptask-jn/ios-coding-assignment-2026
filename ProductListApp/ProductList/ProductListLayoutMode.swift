import SwiftUI

enum ProductListLayoutMode {

  static let itemSpacing: CGFloat = 16

  case oneColumn
  case twoColumn
}

extension ProductListLayoutMode {
  var columnCount: Int {
    switch self {
    case .oneColumn: 1
    case .twoColumn: 2
    }
  }

  var columns: [GridItem] {
    Array(repeating: GridItem(.flexible(), spacing: Self.itemSpacing), count: self.columnCount)
  }

  var toggled: ProductListLayoutMode {
    switch self {
    case .oneColumn: .twoColumn
    case .twoColumn: .oneColumn
    }
  }

  var switchTitle: String {
    switch self {
    case .oneColumn: "1열로 보기"
    case .twoColumn: "2열로 보기"
    }
  }

  var symbolName: String {
    switch self {
    case .oneColumn: "rectangle.grid.1x2"
    case .twoColumn: "square.grid.2x2"
    }
  }
}
