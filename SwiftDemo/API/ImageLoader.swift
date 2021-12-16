//
//  ImageLoader.swift
//  SwiftDemo
//
//  Created by Arun on 16/12/21.
//

import Foundation
import UIKit
import Combine

class ImageLoader:ObservableObject,PhotoService{
    var apiSession: APIService
    var cancellables = Set<AnyCancellable>()
    @Published var image: UIImage? = nil
    @Published var thumbnailImage: UIImage? = nil
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false

    init()
    {
        self.apiSession = APISession()
    }
    
    
    func getThumbnail(urlString: String) {
        let cancellable = apiSession.requestImage(with: urlString)
            .sink(receiveCompletion: { (result) in
                print(result)
            }) { (image) in
                self.thumbnailImage = image
        }
        
        cancellables.insert(cancellable)
    }
    
    
    func getImage(urlString: String) {
        let cancellable = apiSession.requestImage(with: urlString)
            .sink(receiveCompletion: { (result) in
                print(result)
            }) { (image) in
                self.image = image
        }
        
        cancellables.insert(cancellable)
    }

    
}
