import Foundation

enum LoadFailure: Equatable, Sendable {
  case network
  case notFound
  case unknown

  init(_ error: any Error) {
    if error is URLError {
      self = .network
    } else if error as? ProductServiceError == .unsuccessfulStatusCode(404) {
      self = .notFound
    } else {
      self = .unknown
    }
  }
}

extension LoadFailure {
  var message: String {
    switch self {
    case .network: "네트워크 연결을 확인한 뒤 다시 시도해 주세요."
    case .notFound: "존재하지 않는 상품이에요."
    case .unknown: "잠시 후 다시 시도해 주세요."
    }
  }

  var isRetryable: Bool {
    switch self {
    case .network, .unknown: true
    case .notFound: false
    }
  }
}
