//
//  ServiceProvider.swift
//  TestRxSwiftProjectAuth
//
//  Created by 1 on 23.10.2022.
//

protocol ServiceProviderType: AnyObject {
  var userDefaultsService: UserDefaultsServiceType { get }
  var alertService: AlertServiceType { get }
  var taskService: TaskServiceType { get }
}

final class ServiceProvider: ServiceProviderType {
  lazy var userDefaultsService: UserDefaultsServiceType = UserDefaultsService(provider: self)
  lazy var alertService: AlertServiceType = AlertService(provider: self)
  lazy var taskService: TaskServiceType = TaskService(provider: self)
}
