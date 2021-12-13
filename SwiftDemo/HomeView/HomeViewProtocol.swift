//
//  HomeViewProtocol.swift
//  SwiftDemo
//
//  Created by Arun on 07/12/21.
//

import Foundation

import Combine
import UIKit

protocol PhotoService {
    var apiSession: APIService {get}
    
    func getPhotoList() -> AnyPublisher<[PhotoModel], APIError>
}

extension PhotoService {
    
    func getPhotoList() -> AnyPublisher<[PhotoModel], APIError> {
        return apiSession.request(with: PhotoEndPoint.PhotoList)
            .eraseToAnyPublisher()
    }
    
    
}
