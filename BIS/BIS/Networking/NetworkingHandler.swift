//
//  NetworkingHandler.swift
//  BIS
//
//  Created by TSSIOS on 27/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation
import Moya
import Alamofire

struct NetworkRequestResult {
    let success: Bool
    let status: Int
    let data: Data?
    let extraData: AnyObject?
}

protocol HasHttp {
    var networkingAgent: NetworkingHandling { get }
}

protocol NetworkingHandling {
    var isReachable: Bool { get }
    func request(_ endpoint: OpenAPI, response: ((Result<Data, Error>) -> Void)?)
    var publicProvider: MoyaProvider<OpenAPI> { get }
//    var privateProvider: MoyaProvider<UserSafeAPI> { get }
}

class NetworkingHandler: NetworkingHandling {

    func request(_ endpoint: OpenAPI, response: ((Result<Data, Error>) -> Void)?) {
        self.request(endpoint) { result in
            response?(result)
        }
    }

    var isReachable: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }

    private lazy var session: Alamofire.Session = {
        let evaluators: [String: ServerTrustEvaluating] = [
            "dev.tss-digital.com": PinnedCertificatesTrustEvaluator() // all default parameters
        ]
        let configuration = URLSessionConfiguration.default
        return Alamofire.Session(
            configuration: configuration,
            serverTrustManager: ServerTrustManager(evaluators: evaluators)
        )
    }()

    lazy var publicProvider: MoyaProvider<OpenAPI> = {
        return MoyaProvider<OpenAPI>(session: session)
    }()

    private func request(_ endpoint: OpenAPI, handler: @escaping (Swift.Result<Data, Error>) -> Void) {
           publicProvider.request(endpoint) { result in
               switch result {
               case .success(let response):
                   do {
                       let filteredResponse = try response.filterSuccessfulStatusCodes()
                       handler(.success(filteredResponse.data))
                   } catch {
                       handler(.failure(DefaultError.status(code: response.statusCode)))
                   }
               case .failure(let error):
                   switch error {
                   case .statusCode(let response):
                       handler(.failure(DefaultError.status(code: response.statusCode)))
                   default:
                       handler(.failure(DebugError(message: "Unexpected Error")))
                   }
               }
           }
       }
}
