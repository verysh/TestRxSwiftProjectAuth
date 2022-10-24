//
//  ViewControllerViewModel.swift
//  TestRxSwiftProjectAuth
//
//  Created by 1 on 21.10.2022.
//

import RxSwift
import RxCocoa


struct ViewControllerViewModel {
    
    let loginStatus = AuthManager.sharedManager.status.asDriver().asDriver(onErrorJustReturn: .none)
    
    func logout() {
        AuthManager.sharedManager.logout()
    }
    
}
