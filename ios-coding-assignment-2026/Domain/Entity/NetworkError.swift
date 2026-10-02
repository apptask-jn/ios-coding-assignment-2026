//
//  NetworkError.swift
//  ios-coding-assignment-2026
//
//  Created by Park Kwonyong on 10/1/26.
//

import Foundation

enum NetworkError: Error {
  case urlError
  case requestFailed(String)
  case dataNil
  case invalidResponse
  case failToDecode(String)
  case clientError(Int)
  case serverError(Int)
  case unknownStatus(Int)
  
  public var description: String {
    switch self {
    case .urlError: // url이 nil이거나 올바르지 않을 경우
      "URL이 올바르지 않습니다."
    case .requestFailed(let message): // api가 실패로 떨어질 경우
      "서버 요청 실패: \(message)"
    case .dataNil: // data가 nil일 경우
      "데이터가 없습니다."
    case .invalidResponse: // response가 nil일 경우
      "응답값이 유효하지 않습니다."
    case .failToDecode(let description): // json decode 에러
      "디코딩 에러: \(description)"
    case .serverError(let statusCode): // 3xx 서버 에러
      "서버 에러: \(statusCode)"
    case .clientError(let statusCode): // 4xx 클라이언트 에러
      "클라이언트 에러: \(statusCode)"
    case .unknownStatus(let statusCode): // 알려지지 않은 에러
      "그 외의 상태코드: \(statusCode)"
    }
  }
}
