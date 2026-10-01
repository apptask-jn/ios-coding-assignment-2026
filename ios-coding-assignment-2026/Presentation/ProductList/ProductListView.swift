//
//  ProductListView.swift
//  ios-coding-assignment-2026
//
//  Created by Park Kwonyong on 10/1/26.
//

import SwiftUI

struct ProductListView: View {
  
  @State private var viewModel: ProductListViewModel
  
  private let container: AppContainer
  init(container: AppContainer) {
    self.container = container
    _viewModel = State(initialValue: container.makeProductListViewModel())
  }
  
  var body: some View {
    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
  }
}

#Preview {
  ProductListView(container: AppContainer())
}
