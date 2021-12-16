//
//  APIEndPoint.swift
//  SwiftDemo
//
//  Created by Arun on 07/12/21.
//

import Foundation

enum PhotoEndPoint {
    case PhotoList
}

extension PhotoEndPoint: RequestBuilder {
    
    var urlRequest: URLRequest {
        switch self {
        case .PhotoList:
            guard let url = URL(string: "https://jsonplaceholder.typicode.com/photos")
                else {preconditionFailure("Invalid URL format ")}
            let request = URLRequest(url: url)
            return request
        
        }
        
    }
}
