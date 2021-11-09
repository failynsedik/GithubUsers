//
//  JSONSchemaSupport.swift
//  GithubUsers
//
//  Created by Failyn Kaye Sedik on 11/10/21.
//

import Foundation

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
