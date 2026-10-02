//
//  FavoriteButton.swift
//  ios-coding-assignment-2026
//
//  Created by Park Kwonyong on 10/2/26.
//

import SwiftUI

/// 찜 토글 버튼. **목록 셀과 상세 화면이 같은 버튼을 쓴다.**
///
/// 상품 ID만 받으면 동작한다 — 찜 여부는 `FavoriteStore` 에서 읽고, 토글도 Store에 맡긴다.
/// 그래서 이 버튼을 어디에 놓아도 상태가 어긋나지 않는다.
///
/// ## 왜 ViewModel을 거치지 않는가
/// 찜은 특정 화면의 상태가 아니라 앱 전역 공유 상태다. 화면별 ViewModel을 경유시키면
/// `ProductListViewModel.toggleFavorite` 와 `ProductDetailViewModel.toggleFavorite` 가 생기는데
/// 둘은 Store를 그대로 호출하는 동일한 코드다. Environment로 Store를 직접 읽어 그 중복을 없앤다.
struct FavoriteButton: View {

  let productID: Int

  /// `ProductApp` 에서 `.environment(container.favoriteStore)` 로 주입한 공유 Store.
  /// 목록 셀과 상세 툴바가 **같은 인스턴스**를 받는다.
  @Environment(FavoriteStore.self) private var store

  /// 하트를 채울지 비울지 결정하는 값. Store의 집합을 조회해 매번 합성한다.
  private var isFavorite: Bool {
    store.contains(productID)
  }

  var body: some View {
    Button {
      // [찜 1/4] 탭 → Store에 토글 요청.
      // Store가 저장소를 거쳐 상태를 바꾸면 @Observable 이 이 버튼과
      // 다른 화면의 버튼을 함께 다시 그린다.
      store.toggle(productID)
    } label: {
      Image(systemName: isFavorite ? "heart.fill" : "heart")
        .font(.title3)
        .foregroundStyle(isFavorite ? Color.pink : Color.secondary)
        // 아이콘만 두면 터치 영역이 좁아 44pt(HIG 최소 터치 영역)를 확보한다.
        .frame(width: 44, height: 44)
        .contentShape(.rect)
    }
    // .plain 이 아니면 셀 안에서 기본 버튼 배경·하이라이트가 그려진다.
    .buttonStyle(.plain)
    .accessibilityLabel(isFavorite ? "찜 해제" : "찜하기")
  }
}
