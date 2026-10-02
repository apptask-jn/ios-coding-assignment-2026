//
//  FavoriteStore.swift
//  ios-coding-assignment-2026
//
//  Created by Park Kwonyong on 10/2/26.
//

import Observation

/// 찜 상태의 **단일 소스**.
///
/// ## 왜 이 타입이 필요한가
/// 요구사항은 "목록과 상세의 찜 상태가 서로 동기화되어야 한다"다.
/// 만약 목록 ViewModel과 상세 ViewModel이 각각 `Set<Int>` 를 복사해 들고 있으면,
/// 상세에서 찜을 눌러 저장해도 목록이 들고 있는 복사본은 그대로여서 화면이 어긋난다.
///
/// 그래서 찜 집합을 들고 있는 객체를 **하나만** 만들고(`AppContainer`),
/// `.environment()` 로 흘려 목록 셀과 상세 툴바가 **같은 인스턴스를 관찰**하게 한다.
/// `@Observable` 이므로 한쪽에서 토글하면 다른 쪽이 자동으로 다시 그려진다.
/// 결과적으로 **두 화면 사이에 동기화 코드가 한 줄도 없다.**
///
/// ## 역할 경계
/// - **ViewModel** = 그 화면의 원격 데이터 로딩 상태 (`ProductListViewModel` / `ProductDetailViewModel`)
/// - **Store** = 화면에 종속되지 않는 공유 로컬 상태 (이 타입)
///
/// 찜을 ViewModel에 두면 `ProductListViewModel.toggleFavorite` 와
/// `ProductDetailViewModel.toggleFavorite` 가 생기는데 둘은 완전히 동일한 코드다.
/// "화면 종속성" 기준으로 가르면 그 중복이 사라진다.
///
/// ## `@MainActor` 인 이유
/// UI가 직접 관찰하고 토글은 즉시 반영돼야 한다. MainActor로 고정하면 락이 필요 없고,
/// 저장량이 정수 수십 개라 동기 저장으로 충분하다.
@MainActor
@Observable
final class FavoriteStore {

  /// 찜한 상품 ID 집합. 외부에서는 읽기만 가능하고 변경은 `toggle(_:)` 로만 일어난다.
  private(set) var favoriteIDs: Set<Int>

  private let repository: ProductRepositoryProtocol

  /// [영속화] 앱 시작 시 저장된 찜 상태를 복원한다.
  ///
  /// `AppContainer` 가 이 객체를 한 번만 만들기 때문에 UserDefaults 읽기도 앱 실행당 한 번이다.
  /// 이후에는 메모리의 `favoriteIDs` 를 보므로 화면을 오갈 때 디스크를 다시 읽지 않는다.
  init(repository: ProductRepositoryProtocol) {
    self.repository = repository
    self.favoriteIDs = repository.loadFavorites()
  }

  /// 찜 버튼이 하트 모양을 결정할 때 호출한다.
  func contains(_ productID: Int) -> Bool {
    favoriteIDs.contains(productID)
  }

  /// [찜 2/4] 찜 추가 / 해제.
  ///
  /// 실제 추가·해제 판단과 저장은 `FavoriteUserDefaults.toggle(_:)` 이 수행하고,
  /// 여기서는 그 결과를 메모리 상태에 반영한다.
  /// `favoriteIDs` 가 바뀌는 순간 `@Observable` 이 이 값을 읽고 있던 모든 화면을 갱신한다.
  ///
  /// 찜에 규칙(최대 개수 제한, 서버 동기화 등)이 생기면 전부 이 메서드 안으로 들어온다.
  /// 호출처(= 찜 버튼)는 바뀌지 않는다.
  func toggle(_ productID: Int) {
    favoriteIDs = repository.toggleFavorite(productID)
  }
}
