//
//  TaskEditViewController.swift
//  TestRxSwiftProjectAuth
//
//  Created by 1 on 23.10.2022.
//

import UIKit
import ReactorKit
import RxSwift
import SnapKit

final class TaskEditViewController: BaseViewController, View {
    
    // MARK: Constants
    struct Metric {
        static let padding = 15
        static let titleInputCornerRadius = 5
        static let titleInputBorderWidth = 1 / UIScreen.main.scale
    }
    
    struct Font {
        static let titleLabel = UIFont.systemFont(ofSize: 14)
    }
    
    struct Color {
        static let titleInputBorder = UIColor.lightGray
    }
    
    // MARK: UI
    let cancelButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
    let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
    let titleInput = UITextField().then {
        $0.autocorrectionType = .no
        $0.borderStyle = .roundedRect
        $0.font = Font.titleLabel
        $0.placeholder = "Do something..."
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.navigationItem.leftBarButtonItem = self.cancelButtonItem
        self.navigationItem.rightBarButtonItem = self.doneButtonItem
        self.reactor = reactor
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.titleInput)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.titleInput.becomeFirstResponder()
    }
    
    override func setupConstraints() {
        self.titleInput.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(Metric.padding)
            make.left.equalTo(Metric.padding)
            make.right.equalTo(-Metric.padding)
        }
    }
    
    // MARK: Binding
    func bind(reactor: TaskEditViewReactor) {
        // Action
        self.cancelButtonItem.rx.tap
            .map { Reactor.Action.cancel }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.doneButtonItem.rx.tap
            .map { Reactor.Action.submit }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.titleInput.rx.text
            .compactMap { $0 }
            .skip(1)
            .map(Reactor.Action.updateTaskTitle)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // State
        reactor.state.asObservable().map { $0.title }
            .distinctUntilChanged()
            .bind(to: self.navigationItem.rx.title)
            .disposed(by: self.disposeBag)
        
        reactor.state.asObservable().map { $0.taskTitle }
            .distinctUntilChanged()
            .bind(to: self.titleInput.rx.text)
            .disposed(by: self.disposeBag)
        
        reactor.state.asObservable().map { $0.canSubmit }
            .distinctUntilChanged()
            .bind(to: self.doneButtonItem.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        reactor.state.asObservable().map { $0.isDismissed }
            .distinctUntilChanged()
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
    }
}
