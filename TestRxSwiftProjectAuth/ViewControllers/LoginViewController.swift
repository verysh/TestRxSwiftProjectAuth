//
//  LoginViewController.swift
//  TestRxSwiftProjectAuth
//
//  Created by 1 on 21.10.2022.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UITableViewController {
    
    @IBOutlet weak private(set) var usernameTextField: UITextField!
    @IBOutlet weak private(set) var passwordTextField: UITextField!
    @IBOutlet weak private(set)var enterButton: UIButton!
    @IBOutlet weak private(set) var activityIndicator: UIActivityIndicatorView!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        let gr = UITapGestureRecognizer()
        gr.numberOfTapsRequired = 1
        tableView.addGestureRecognizer(gr)
        gr.rx.event.asObservable()
            .subscribe(onNext: { [unowned self] _ in
                self.hideKeyboard()
            })
            .disposed(by: disposeBag)
            
        
        let viewModel = LoginViewModel(usernameText: usernameTextField.rx.text.orEmpty.asDriver(),
            passwordText: passwordTextField.rx.text.orEmpty.asDriver())
        
        viewModel.usernameBGColor
            .drive(onNext: { [unowned self] color in
                UIView.animate(withDuration: 0.2) {
                    self.usernameTextField.superview?.backgroundColor = color
                }
            })
            .disposed(by: disposeBag)
        
        
        viewModel.passwordBGColor
            .drive(onNext: { [unowned self] color in
                UIView.animate(withDuration: 0.2) {
                    self.passwordTextField.superview?.backgroundColor = color
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.credentialsValid
            .drive(onNext: { [unowned self] valid in
                self.enterButton.isEnabled = valid
            })
            .disposed(by: disposeBag)
        
        enterButton.rx.tap
            .withLatestFrom(viewModel.credentialsValid)
            .filter { $0 }
            .flatMapLatest { [unowned self] valid -> Observable<AutenticationStatus> in
                viewModel.login(self.usernameTextField.text!, password: self.passwordTextField.text!)
                    .trackActivity(viewModel.activityIndicator)
                    .observe(on: SerialDispatchQueueScheduler(qos: .userInteractive))
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] autenticationStatus in
                switch autenticationStatus {
                case .none:
                    break
                case .user(_):
                    break
                case .error(let error):
                    self.showError(error)
                }
                AuthManager.sharedManager.status.accept(autenticationStatus)
            })
            .disposed(by: disposeBag)
        
        
        viewModel.activityIndicator
            .distinctUntilChanged()
            .drive(onNext: { [unowned self] active in
                self.hideKeyboard()
                self.activityIndicator.isHidden = !active
                self.enterButton.isEnabled = !active
            })
            .disposed(by: disposeBag)
        
    }
    
    fileprivate func hideKeyboard() {
        self.usernameTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
    
    fileprivate func showError(_ error: AutenticationError) {
        let title: String
        let message: String
        
        switch error {
        case .server, .badReponse:
            title = "An error occuried"
            message = "Server error"
        case .badCredentials:
            title = "Bad credentials"
            message = "This user don't exist"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === usernameTextField {
            passwordTextField.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        return false
    }
    
}
