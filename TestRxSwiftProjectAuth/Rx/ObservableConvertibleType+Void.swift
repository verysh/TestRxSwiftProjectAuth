//
//  ObservableConvertibleType+Void.swift
//  TestRxSwiftProjectAuth
//
//  Created by 1 on 23.10.2022.
//

import RxCocoa
import RxSwift

extension ObservableConvertibleType where Element == Void {

  func asDriver() -> Driver<Element> {
    return self.asDriver(onErrorJustReturn: Void())
  }

}
