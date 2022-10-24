//
//  LoginNavigationController.swift
//  TestRxSwiftProjectAuth
//
//  Created by 1 on 21.10.2022.
//

import UIKit

let BG_COLOR = UIColor(red: 229/255, green: 229/255, blue: 234/255, alpha: 1)

class LoginNavigationController: UINavigationController {

    var loginController: LoginViewController? {
        return _loginController()
    }
    
    fileprivate func _loginController() -> LoginViewController? {
        return viewControllers.first as? LoginViewController
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        navigationBar.barTintColor =  BG_COLOR
    }
}
