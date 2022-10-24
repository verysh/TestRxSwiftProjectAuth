//
//  BaseViewController.swift
//  TestRxSwiftProjectAuth
//
//  Created by 1 on 23.10.2022.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    
    // MARK: Rx
    var disposeBag = DisposeBag()
    
    // MARK: Layout Constraints
    private(set) var didSetupConstraints = false
    
    override func viewDidLoad() {
        self.view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        if !self.didSetupConstraints {
            self.setupConstraints()
            self.didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    func setupConstraints() {
        // Override point
    }
}
