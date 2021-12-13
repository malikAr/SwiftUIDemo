//
//  HomeViewModel.swift
//  SwiftDemo
//
//  Created by Arun on 06/12/21.
//

import Foundation
import Combine
import SwiftUI

class PhotoViewModel: ObservableObject,PhotoService
{
    var apiSession: APIService
    @Published var photoList = [PhotoModel]()
    @Published var loading = false

    
    var cancellables = Set<AnyCancellable>()
    
    init(apiSession: APIService = APISession()) {
        self.apiSession = apiSession
    }
    
    func GetPhotoList() {
        let cancellable = self.getPhotoList()
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    print("Handle error: \(error)")
                case .finished:
                    break
                }
                
            }) { (photo) in
                self.photoList = photo
        }
        cancellables.insert(cancellable)
    }
    
}
