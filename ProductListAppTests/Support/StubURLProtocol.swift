import Foundation
import os

final class StubURLProtocol: URLProtocol {

  struct Stub: Sendable {
    let statusCode: Int
    let body: Data
  }

  static let stub = OSAllocatedUnfairLock<Stub?>(initialState: nil)

  static func makeSession() -> URLSession {
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [StubURLProtocol.self]
    return URLSession(configuration: configuration)
  }

  static func stubHTTPResponse(statusCode: Int, body: String) {
    self.stub.withLock { $0 = Stub(statusCode: statusCode, body: Data(body.utf8)) }
  }

  static func stubNonHTTPResponse() {
    self.stub.withLock { $0 = nil }
  }

  override class func canInit(with request: URLRequest) -> Bool {
    true
  }

  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    request
  }

  override func startLoading() {
    guard let url = self.request.url else {
      self.client?.urlProtocol(self, didFailWithError: URLError(.badURL))
      return
    }

    guard let stub = Self.stub.withLock({ $0 }),
          let httpResponse = HTTPURLResponse(
            url: url,
            statusCode: stub.statusCode,
            httpVersion: "HTTP/1.1",
            headerFields: nil
          )
    else {
      let nonHTTPResponse = URLResponse(
        url: url,
        mimeType: nil,
        expectedContentLength: 0,
        textEncodingName: nil
      )
      self.client?.urlProtocol(self, didReceive: nonHTTPResponse, cacheStoragePolicy: .notAllowed)
      self.client?.urlProtocolDidFinishLoading(self)
      return
    }

    self.client?.urlProtocol(self, didReceive: httpResponse, cacheStoragePolicy: .notAllowed)
    self.client?.urlProtocol(self, didLoad: stub.body)
    self.client?.urlProtocolDidFinishLoading(self)
  }

  override func stopLoading() {}
}
