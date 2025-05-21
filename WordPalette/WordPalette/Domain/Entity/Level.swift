//
//  WordLevel.swift
//  WordPalette
//
//  Created by iOS study on 5/21/25.
//

enum Level: String {
  case beginner = "초급"
  case intermediate = "중급"
  case advanced = "고급"

  init?(korean: String) {
    self.init(rawValue: korean)
  }
}
