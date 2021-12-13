//
//  Model.swift
//  SwiftDemo
//
//  Created by Arun on 06/12/21.
//

import Foundation

struct PhotoModel: Codable, Identifiable ,Hashable{
    let id:Int
    let title: String
    let url:String
    let thumbnailUrl: String
}
