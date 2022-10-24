//
//  ViewController.swift
//  TestRxSwiftProjectAuth
//
//  Created by 1 on 13.09.2022.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileViewController: UIViewController {

    private let disposeBag = DisposeBag()
    private let viewModel = ViewControllerViewModel()
    
    private var loginNavigationController: LoginNavigationController?
    private var loginController: LoginViewController?

    @IBOutlet weak private(set) var logoutButton: UIButton!
    @IBOutlet weak private(set) var avatar: UIImageView!
    @IBOutlet weak private(set) var name: UILabel!
    @IBOutlet weak private(set) var mobile: UILabel!
    @IBOutlet weak private(set) var email: UILabel!
    @IBOutlet weak private(set) var note: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.title = "My Profile"
        
        viewModel.loginStatus
            .drive(onNext: { [unowned self] status in
                switch status {
                case .none:
                    fallthrough
                case .error(_):
                    self.showLogin()
                case .user(let user):
                    self.showAccess(user)
                }
            })
            .disposed(by: disposeBag)
        
        logoutButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.viewModel.logout()
            })
            .disposed(by: disposeBag)
    }
    
    private func showLogin() {
        guard loginNavigationController != nil else {
            loginNavigationController = UIStoryboard.loginNC
            loginController = loginNavigationController?.loginController
            loginController?.isModalInPresentation = true
            present(loginNavigationController!, animated: true, completion: nil)
            return
        }
        
    }
    
    private func showAccess(_ username: String) {
        
        dismiss(animated: true) { [unowned self] in
            self.loginController = nil
            self.loginNavigationController = nil
        }
    }
}


