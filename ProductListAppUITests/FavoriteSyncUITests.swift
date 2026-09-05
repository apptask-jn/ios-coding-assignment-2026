import XCTest

@MainActor
final class FavoriteSyncUITests: XCTestCase {

  // MARK: Constants

  private enum Timeout {
    static let listLoad: TimeInterval = 30
    static let stateChange: TimeInterval = 5
  }

  private enum ProductID {
    static let first = 1
  }


  // MARK: Tests

  func testFavoriteToggledInListIsReflectedInDetailAndBack() {
    let app = XCUIApplication()
    app.launch()

    let listFavorite = app.buttons["list-favorite-\(ProductID.first)"]
    XCTAssertTrue(
      listFavorite.waitForExistence(timeout: Timeout.listLoad),
      "상품 목록을 불러오지 못했습니다. 네트워크 연결을 확인해 주세요."
    )

    let initialLabel = listFavorite.label
    let toggledLabel = initialLabel == "찜하기" ? "찜 해제" : "찜하기"

    listFavorite.tap()
    self.assertLabel(toggledLabel, on: listFavorite, "목록에서 찜을 눌러도 버튼 상태가 바뀌지 않았습니다.")

    app.buttons["product-cell-\(ProductID.first)"].tap()

    let detailFavorite = app.buttons["detail-favorite-\(ProductID.first)"]
    XCTAssertTrue(
      detailFavorite.waitForExistence(timeout: Timeout.listLoad),
      "상품 상세를 불러오지 못했습니다."
    )
    self.assertLabel(
      toggledLabel,
      on: detailFavorite,
      "목록에서 바꾼 찜 상태가 상세에 반영되지 않았습니다."
    )

    detailFavorite.tap()
    self.assertLabel(
      initialLabel,
      on: detailFavorite,
      "상세에서 찜을 눌러도 버튼 상태가 바뀌지 않았습니다."
    )

    app.navigationBars["상품 상세"].buttons.firstMatch.tap()
    XCTAssertTrue(
      app.navigationBars["상품 목록"].waitForExistence(timeout: Timeout.stateChange),
      "목록으로 돌아오지 못했습니다."
    )
    self.assertLabel(
      initialLabel,
      on: listFavorite,
      "상세에서 바꾼 찜 상태가 목록에 반영되지 않았습니다."
    )
  }
}

extension FavoriteSyncUITests {

  // MARK: Assertions

  private func assertLabel(_ expected: String, on element: XCUIElement, _ message: String) {
    let matched = self.expectation(
      for: NSPredicate(format: "label == %@", expected),
      evaluatedWith: element
    )
    XCTAssertEqual(
      XCTWaiter().wait(for: [matched], timeout: Timeout.stateChange),
      .completed,
      message
    )
  }
}
