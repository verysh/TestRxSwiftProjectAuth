//
//  Extensions.swift
//  TestRxSwiftProjectAuth
//
//  Created by 1 on 24.10.2022.
//

import UIKit

extension UIStoryboard {
    static var mainStoryboard: UIStoryboard? {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    static var loginNC: LoginNavigationController? {
        return UIStoryboard.mainStoryboard?.instantiateViewController(withIdentifier: "LoginNC") as? LoginNavigationController
    }
    static var profileVC: ProfileViewController? {
        return UIStoryboard.mainStoryboard?.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileViewController
    }
    static var taskListVC: TaskListViewController? {
        return UIStoryboard.mainStoryboard?.instantiateViewController(withIdentifier: "TaskListVC") as? TaskListViewController
    }
    static var taskEditVC: TaskEditViewController? {
        return UIStoryboard.mainStoryboard?.instantiateViewController(withIdentifier: "TaskEditVC") as? TaskEditViewController
    }
}
