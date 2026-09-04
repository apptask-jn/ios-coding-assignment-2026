import Testing

@testable import ProductListApp

struct ProductListLayoutModeTests {

  @Test
  func gridColumnsMatchTheColumnCount() {
    #expect(ProductListLayoutMode.oneColumn.columns.count == 1)
    #expect(ProductListLayoutMode.twoColumn.columns.count == 2)
  }

  @Test
  func togglingSwitchesBetweenOneAndTwoColumns() {
    #expect(ProductListLayoutMode.oneColumn.toggled == .twoColumn)
    #expect(ProductListLayoutMode.twoColumn.toggled == .oneColumn)
  }
}
