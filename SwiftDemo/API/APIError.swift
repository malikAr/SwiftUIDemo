//
//  APIError.swift
//  SwiftDemo
//
//  Created by Arun on 06/12/21.
//

import Foundation
enum APIError: Error {
    case decodingError
    case httpError(Int)
    case unknown
}
