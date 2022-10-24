//
//  LoginViewModel.swift
//  TestRxSwiftProjectAuth
//
//  Created by 1 on 21.10.2022.
//

import RxSwift
import RxCocoa
import RxSwiftUtilities

struct LoginViewModel {
    
    let activityIndicator = ActivityIndicator()
    
    let usernameBGColor: Driver<UIColor>
    let passwordBGColor: Driver<UIColor>
    let credentialsValid: Driver<Bool>
    
    init(usernameText: Driver<String>, passwordText: Driver<String>) {
        
        let usernameValid = usernameText
            .distinctUntilChanged()
            .throttle(RxTimeInterval.milliseconds(300))
            .map { $0.utf8.count > 3 }
        
        let passwordValid = passwordText
            .distinctUntilChanged()
            .throttle(RxTimeInterval.milliseconds(300))
            .map { $0.utf8.count > 3 }
        
        usernameBGColor = usernameValid
            .map { $0 ? BG_COLOR : UIColor.white }
        
        passwordBGColor = passwordValid
            .map { $0 ? BG_COLOR : UIColor.white }
        
        credentialsValid = Driver.combineLatest(usernameValid, passwordValid) { $0 && $1 }
        
    }
    
    func login(_ username: String, password: String) -> Observable<AutenticationStatus> {
        return AuthManager.sharedManager.login(username, password: password)
    }
    
}



