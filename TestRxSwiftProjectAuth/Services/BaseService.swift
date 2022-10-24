//
//  BaseService.swift
//  TestRxSwiftProjectAuth
//
//  Created by 1 on 23.10.2022.
//

class BaseService {
  unowned let provider: ServiceProviderType

  init(provider: ServiceProviderType) {
    self.provider = provider
  }
}
