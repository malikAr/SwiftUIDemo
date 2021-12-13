//
//  APIService.swift
//  SwiftDemo
//
//  Created by Arun on 06/12/21.
//

import Foundation
import Combine
import UIKit

protocol APIService {
    func request<T: Decodable>(with builder: RequestBuilder) -> AnyPublisher<T, APIError>
}
