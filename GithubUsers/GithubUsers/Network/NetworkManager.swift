//
//  NetworkManager.swift
//  GithubUsers
//
//  Created by Failyn Kaye Sedik on 11/10/21.
//

import Moya
import PromiseKit

/// The manager for all network calls. Please do note that this can still be further improved if there are
/// more endpoints to be managed. This can be done by changing `UserAPI` to a generic value.
class NetworkManager {
    #if DEBUG
        let provider = MoyaProvider<UserAPI>(
            plugins: [
                NetworkLoggerPlugin(
                    configuration: NetworkLoggerPlugin.Configuration(
                        logOptions: .verbose
                    )
                ),
                NetworkDataCachingPlugin(),
            ]
        )
    #else
        let provider = MoyaProvider<UserAPI>(
            plugins: [NetworkDataCachingPlugin()]
        )
    #endif
}

extension NetworkManager {
    func request<T: Decodable>(target: UserAPI) -> Promise<T> {
        Promise { seal in
            provider.request(target) { result in
                switch result {
                case let .success(response):
                    do {
                        let results = try JSONDecoder().decode(T.self, from: response.data)
                        seal.fulfill(results)
                    } catch {
                        seal.reject(error)
                    }

                case let .failure(error):
                    seal.reject(error)
                }
            }
        }
    }
}
