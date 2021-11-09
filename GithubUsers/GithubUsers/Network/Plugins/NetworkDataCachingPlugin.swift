//
//  NetworkDataCachingPlugin.swift
//  GithubUsers
//
//  Created by Failyn Kaye Sedik on 11/10/21.
//

import Moya

protocol CachePolicyGettable {
    var cachePolicy: URLRequest.CachePolicy { get }
}

final class NetworkDataCachingPlugin: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        if let cacheableTarget = target as? CachePolicyGettable {
            var mutableRequest = request
            mutableRequest.cachePolicy = cacheableTarget.cachePolicy
            return mutableRequest
        }

        return request
    }
}
