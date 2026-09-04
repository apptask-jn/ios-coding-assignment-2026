import Testing

@testable import ProductListApp

struct ProductListLayoutTests {

  @Test
  func gridColumnsMatchTheColumnCount() {
    #expect(ProductListLayout.oneColumn.columns.count == 1)
    #expect(ProductListLayout.twoColumn.columns.count == 2)
  }

  @Test
  func togglingSwitchesBetweenOneAndTwoColumns() {
    #expect(ProductListLayout.oneColumn.toggled == .twoColumn)
    #expect(ProductListLayout.twoColumn.toggled == .oneColumn)
  }
}
