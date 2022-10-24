//
//  Types.swift
//  TestRxSwiftProjectAuth
//
//  Created by 1 on 23.10.2022.
//

struct UserDefaultsKey<T> {
    typealias Key<T> = UserDefaultsKey<T>
    let key: String
}

extension UserDefaultsKey: ExpressibleByStringLiteral {
    public init(unicodeScalarLiteral value: StringLiteralType) {
        self.init(key: value)
    }
    
    public init(extendedGraphemeClusterLiteral value: StringLiteralType) {
        self.init(key: value)
    }
    
    public init(stringLiteral value: StringLiteralType) {
        self.init(key: value)
    }
}

