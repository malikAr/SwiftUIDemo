//
//  UserModel.swift
//  SwiftDemo
//
//  Created by Arun on 07/12/21.
//

import Foundation

struct LoginModel: Codable {
    let name:String
    let email:String
    let password:String
    let phoneNumber:String
    let birthDate:Date
}
