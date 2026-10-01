//
//  RootView.swift
//  ios-coding-assignment-2026
//
//  Created by Park Kwonyong on 10/1/26.
//

import SwiftUI

struct RootView: View {
  
  let container: AppContainer
  
  var body: some View {
    ProductListView(container: container)
  }
}
