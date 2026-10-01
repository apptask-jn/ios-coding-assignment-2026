//
//  ProductDetailView.swift
//  ios-coding-assignment-2026
//
//  Created by Park Kwonyong on 10/1/26.
//

import SwiftUI

struct ProductDetailView: View {
  
  @State private var viewModel: ProductDetailViewModel
  
  private let container: AppContainer
  init(container: AppContainer, productId: Int) {
    self.container = container
    _viewModel = State(initialValue: container.makeProductDetailViewModel(productId: productId))
  }

  var body: some View {
    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
  }
}

#Preview {
  ProductDetailView(container: AppContainer(), productId: 1)
}
