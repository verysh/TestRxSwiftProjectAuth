//
//  TaskCell.swift
//  TestRxSwiftProjectAuth
//
//  Created by 1 on 23.10.2022.
//

import UIKit
import ReactorKit
import RxSwift
import ManualLayout

class TaskCell: BaseTableViewCell, View {
    typealias Reactor = TaskCellReactor
    

    // MARK: Constants

    struct Constant {
      static let titleLabelNumberOfLines = 2
    }

    struct Metric {
        static let cellPadding = 15.00
    }

    struct Font {
      static let titleLabel = UIFont.systemFont(ofSize: 14)
    }

    struct Color {
      static let titleLabelText = UIColor.black
    }


    // MARK: UI
    let titleLabel = UILabel().then { label in
        label.font = Font.titleLabel
        label.textColor = Color.titleLabelText
        label.numberOfLines = Constant.titleLabelNumberOfLines
    }
    

    // MARK: Initializing

    override func initialize() {
      self.contentView.addSubview(self.titleLabel)
    }


    // MARK: Binding

    func bind(reactor: Reactor) {
      self.titleLabel.text = reactor.currentState.title
      self.accessoryType = reactor.currentState.isDone ? .checkmark : .none
    }


    // MARK: Layout

    override func layoutSubviews() {
      super.layoutSubviews()

      self.titleLabel.top = Metric.cellPadding
      self.titleLabel.left = Metric.cellPadding
      self.titleLabel.width = self.contentView.width - Metric.cellPadding * 2
      self.titleLabel.sizeToFit()
    }


    // MARK: Cell Height
    class func height(fits width: CGFloat, reactor: Reactor) -> CGFloat {
      let height =  reactor.currentState.title.height(
        fits: width - CGFloat(Metric.cellPadding * 2),
        font: Font.titleLabel,
        maximumNumberOfLines: Constant.titleLabelNumberOfLines
      )
        return CGFloat(height + Metric.cellPadding * 2)
    }
}
