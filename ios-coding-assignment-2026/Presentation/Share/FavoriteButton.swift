//
//  FavoriteButton.swift
//  ios-coding-assignment-2026
//
//  Created by Park Kwonyong on 10/2/26.
//

import SwiftUI

struct FavoriteButton: View {

  let productID: Int

  @Environment(FavoriteStore.self) private var store

  private var isFavorite: Bool {
    store.contains(productID)
  }

  var body: some View {
    Button {
      store.toggle(productID)
    } label: {
      Image(systemName: isFavorite ? "heart.fill" : "heart")
        .font(.title3)
        .foregroundStyle(isFavorite ? Color.pink : Color.secondary)
        .frame(width: 44, height: 44)
        .contentShape(.rect)
    }
    .buttonStyle(.plain)
    .accessibilityLabel(isFavorite ? "찜 해제" : "찜하기")
  }
}
