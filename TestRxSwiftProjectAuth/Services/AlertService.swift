//
//  AlertService.swift
//  TestRxSwiftProjectAuth
//
//  Created by 1 on 23.10.2022.
//

import UIKit
import RxSwift
import URLNavigator

protocol AlertActionType {
  var title: String? { get }
    var style: UIAlertAction.Style { get }
}

extension AlertActionType {
    var style: UIAlertAction.Style {
    return .default
  }
}

protocol AlertServiceType: AnyObject {
  func show<Action: AlertActionType>(
    title: String?,
    message: String?,
    preferredStyle: UIAlertController.Style,
    actions: [Action]
  ) -> Observable<Action>
}

final class AlertService: BaseService, AlertServiceType {

  func show<Action: AlertActionType>(
    title: String?,
    message: String?,
    preferredStyle: UIAlertController.Style,
    actions: [Action]
  ) -> Observable<Action> {
    return Observable.create { observer in
      let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
      for action in actions {
        let alertAction = UIAlertAction(title: action.title, style: action.style) { _ in
          observer.onNext(action)
          observer.onCompleted()
        }
        alert.addAction(alertAction)
      }
      Navigator().present(alert)
      return Disposables.create {
        alert.dismiss(animated: true, completion: nil)
      }
    }
  }

}

