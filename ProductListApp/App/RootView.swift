import SwiftUI

struct RootView: View {

  var body: some View {
    NavigationStack {
      Text("Product List")
        .navigationTitle("상품")
    }
  }
}

#Preview {
  RootView()
}
