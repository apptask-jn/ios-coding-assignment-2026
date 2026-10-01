//
//  ProductApp.swift
//  ProductApp
//
//  Created by Park Kwonyong on 10/1/26.
//

import SwiftUI

@main
struct ProductApp: App {
  
  @State private var container = AppContainer()

  var body: some Scene {
    WindowGroup {
      RootView(container: container)
    }
  }
}
