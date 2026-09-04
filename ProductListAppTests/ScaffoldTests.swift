import Testing

@testable import ProductListApp

/// 테스트 타깃이 앱 모듈을 정상적으로 링크하는지 확인하는 스캐폴드 테스트.
/// 실제 로직 테스트가 추가되면 제거한다.
struct ScaffoldTests {

  @Test
  func testHostLinksAppModule() {
    let rootViewTypeName = String(describing: RootView.self)
    #expect(rootViewTypeName == "RootView")
  }
}
