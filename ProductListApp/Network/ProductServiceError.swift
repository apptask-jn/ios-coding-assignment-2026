enum ProductServiceError: Error, Equatable {
  case invalidResponse
  case unsuccessfulStatusCode(Int)
}
