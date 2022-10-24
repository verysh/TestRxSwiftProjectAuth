//
//  TaskCellReactor.swift
//  TestRxSwiftProjectAuth
//
//  Created by 1 on 23.10.2022.
//

import ReactorKit
import RxCocoa
import RxSwift

class TaskCellReactor: Reactor {
    typealias Action = NoAction

    let initialState: Task

    init(task: Task) {
      self.initialState = task
    }
}
