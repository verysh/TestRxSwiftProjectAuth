//
//  ModelType.swift
//  TestRxSwiftProjectAuth
//
//  Created by 1 on 23.10.2022.
//

import Then

protocol Identifiable {
  associatedtype Identifier: Equatable
  var id: Identifier { get }
}

protocol ModelType: Then {
}

extension Collection where Self.Iterator.Element: Identifiable {

  func index(of element: Self.Iterator.Element) -> Self.Index? {
      return self.firstIndex { $0.id == element.id }
  }

}
