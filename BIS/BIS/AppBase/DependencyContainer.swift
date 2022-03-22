//
//  DependencyContainer.swift
//  BIS
//
//  Created by TSSIOS on 29/07/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Alamofire
import Foundation
import Moya
import Swinject

class DependencyInjector {

    static var container: Container = {
        let container = Container()

        //Register components
        container.register(CoreDataManager.self, factory: { _ in
            return CoreDataManager()
        }).inObjectScope(.container)

        container.register(MoyaProvider<OpenAPI>.self, factory: { _ in
             #if DEBUG
            return MoyaProvider<OpenAPI>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
            #else
            return MoyaProvider<OpenAPI>()
            #endif
        }).inObjectScope(.container)

        container.register(NetworkingManager.self, factory: { _ in
            return NetworkingManager()
        }).inObjectScope(.container)

        container.register(BiometricAuthentication.self, factory: { _ in
            return BiometricAuthentication()
        }).inObjectScope(.graph)

        return container
    }()

}

// MARK: - Access methods
extension DependencyInjector {

    static func send<T>(_ value: T, withKey key: String) {
        self.container.register(T.self, name: key) { _ -> T in
            return value
        }
    }

    static func get<T>(key: String? = nil) -> T? {
        return self.container.resolve(T.self, name: key)
    }

    static func get<T, P>(arg: P, key: String? = nil) -> T? {
        return self.container.resolve(T.self, name: key, argument: arg)
    }
}
