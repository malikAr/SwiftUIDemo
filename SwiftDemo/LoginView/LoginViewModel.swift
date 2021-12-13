//
//  LoginViewModel.swift
//  SwiftDemo
//
//  Created by Arun on 06/12/21.
//

import Foundation
import SwiftUI
import Combine

enum PasswordStatus {
    case valid
    case empty
    case noMatch
    case notStrongEnough
}
enum EmailStatus {
    case emailValid
    case emailEmpty
    case emailWrong
}

enum PhoneNumberStatus {
    case phoneValid
    case phoneEmpty
    case phoneNotValid
}

enum FormStatus{
    case valid
    case userNameEmpty
    case userPassEmpty
    case userEmailEmpty
    case userPhoneNumberEmpty
    case userWrongPhone
    case userWrongPassword
    case userEmailNotValid
}


class LoginViewModel:ObservableObject{
    @Published var userName:String = ""
    @Published var email:String = ""
    @Published var password:String = ""
    @Published var phoneNumber:String = ""
    @Published var birthDate = Date()
    
    @Published var isValidUserCreate = false
    @Published var isEmailPassEmpty = false
    @Published var isEmailPassValid = false

  
    @Published var formMessage = ""


    var userModel = [LoginModel]()
    
    private var cancellables = Set<AnyCancellable>()
    
    
    init(){
        
        isEmailAndPasswordEmptyPublisher
            .receive(on: RunLoop.main)
            .assign(to: \ .isEmailPassEmpty , on: self)
            .store(in: &cancellables)
        
        isEmailAndPassValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \ .isEmailPassValid , on: self)
            .store(in: &cancellables)
        

        isFormValidPublisher
            .dropFirst()
            .receive(on:RunLoop.main)
            .map { message  in
                
                switch message {
                case .userWrongPhone:
                    return "Phone Number must be greator than 10 digit"
                case .userPassEmpty:
                    return "Password should not be Empty"
                case .userEmailEmpty:
                    return "Email should not be Empty"
                case .userEmailNotValid:
                    return "Email is not Valid"
                case .userWrongPassword:
                    return "Password must be 8 character"
                case .userPhoneNumberEmpty:
                    return "Phone Number should not be Empty"
                case .userNameEmpty:
                    return "User Name should not be Empty"
                case .valid:
                    return "Valid"
                
                }
                
            }
            .assign(to: \.formMessage , on: self)
            .store(in: &cancellables)
        

             
    }
   
    
}


extension LoginViewModel{
    
    private var isUserNameEmptyPublisher: AnyPublisher<Bool, Never> {
        $userName
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                return input == ""            }
            .eraseToAnyPublisher()
    }

    private var isEmailIDValidPublisher: AnyPublisher<Bool, Never> {
        $email
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                return self.isValidEmail(email: input)
            }
            .eraseToAnyPublisher()
    }
    
    private var isEmailIDEmptyPublisher: AnyPublisher<Bool, Never> {
        $email
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                return input == ""
            }
            .eraseToAnyPublisher()
     }

        
    private var isPasswordEmptyPublisher: AnyPublisher<Bool, Never> {
        $password
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { password in
                return password == ""
            }
            .eraseToAnyPublisher()
    }

   private func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
       
         let result = emailPred.evaluate(with: email)
    
        return result
    }
        

    private var isPasswordStrongEnoughPublisher: AnyPublisher<Bool, Never> {
        $password
            .removeDuplicates()
            .map { password in
                return password.count >= 8
            }
            .eraseToAnyPublisher()
    }
    
    
    
     var isPasswordValidPublisher: AnyPublisher<PasswordStatus, Never> {
        Publishers.CombineLatest(isPasswordEmptyPublisher, isPasswordStrongEnoughPublisher)
            .map { passwordIsEmpty, passwordIsStrongEnough in
            if (passwordIsEmpty) {
                return .empty
            }
            else if (!passwordIsStrongEnough) {
                return .notStrongEnough
            }
            else {
                return .valid
            }
        }
        .eraseToAnyPublisher()
    }
    
    var isEmailValidPublisher: AnyPublisher<EmailStatus, Never> {
       Publishers.CombineLatest(isEmailIDEmptyPublisher, isEmailIDValidPublisher)
            .map { emailIsEmpty, emailIsValid in
                if (emailIsEmpty) {
                    return .emailEmpty
                }
                else if(emailIsValid){
                    return .emailValid
                }
                else
                {
                    return .emailWrong
                }
            }
       .eraseToAnyPublisher()
   }
    private var isEmailAndPasswordEmptyPublisher:AnyPublisher<Bool,Never>
    {
        Publishers.CombineLatest(isPasswordEmptyPublisher , isEmailIDEmptyPublisher)
            .map { passwordEmpty, emailEmpty in
                if (passwordEmpty || emailEmpty)
                {
                    return true
                }
                else
                {
                    return false
                }
            }
            .eraseToAnyPublisher()
    }
    

    
    
   private var isEmailAndPassValidPublisher: AnyPublisher<Bool, Never> {
       Publishers.CombineLatest(isEmailIDValidPublisher,isPasswordStrongEnoughPublisher)
           .map { emailValid, passwordValid in
               if (emailValid && passwordValid)
               {
                   return true
               }
               else
               {
                   return false
               }
           }
       .eraseToAnyPublisher()
   }
    
    
    private var isPhoneNumberEmpty: AnyPublisher<Bool, Never> {
        $phoneNumber
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                return input == ""            }
            .eraseToAnyPublisher()
    }
    
    private var isPhoneNumberNotValid: AnyPublisher<Bool, Never> {
        $phoneNumber
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                return input.count > 9
                
            }
            .eraseToAnyPublisher()
    }
    
    
    private var isPhoneNumberValidPublisher: AnyPublisher<PhoneNumberStatus, Never> {
        Publishers.CombineLatest(isPhoneNumberEmpty,isPhoneNumberNotValid)
            .map{ phoneNumberEmpty, phoneNumberNotValid in
                
                if phoneNumberEmpty{
                    return .phoneEmpty
                }
                else if (!phoneNumberNotValid)
                {
                    return .phoneNotValid
                }
                else
                {
                    return .phoneValid
                }
              
            }
        
            .eraseToAnyPublisher()
    }

   private  var isFormValidPublisher: AnyPublisher<FormStatus, Never> {
        Publishers.CombineLatest4(isUserNameEmptyPublisher, isPasswordValidPublisher,isEmailValidPublisher,isPhoneNumberValidPublisher)
            .map { userNameIsValid, passwordIsValid , emailIsValid , phoneIsValid in
                if (userNameIsValid) {
                    return .userNameEmpty
                }
                else if (passwordIsValid == .notStrongEnough) {
                    return .userWrongPassword
                }
                else if (passwordIsValid == .empty) {
                    return .userPassEmpty
                }
                else if (emailIsValid == .emailWrong) {
                    return .userEmailNotValid
                }
                else if (emailIsValid == .emailEmpty) {
                    return .userEmailEmpty
                }
                else if (phoneIsValid == .phoneNotValid) {
                    return .userWrongPhone
                }
                else if (phoneIsValid == .phoneEmpty) {
                    return .userPhoneNumberEmpty
                }
                else {
                    return .valid
                }
                
             }
           .eraseToAnyPublisher()
    }
}


extension LoginViewModel{
    
    func saveUser(){
        let user = LoginModel(name: userName, email: email, password: password, phoneNumber: phoneNumber, birthDate: birthDate)
        userModel.append(user)
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(userModel)
            UserDefaults.standard.set(data, forKey: "Users")

        } catch let error{
            print("Unable to Encode Array of Notes (\(error))")
        }
       
    }
    
    
    func getUser() -> [LoginModel]{
        if let data = UserDefaults.standard.data(forKey: "Users") {
            do {
                let decoder = JSONDecoder()
                let notes = try decoder.decode([LoginModel].self, from: data)
                return notes
            } catch let error{
                print("Unable to Decode Notes (\(error))")
            }
        }
        
        return []
    }
    
    
    func validUserCredential() -> Bool
    {
        var result:Bool = false
        let objarray = getUser()
        print("Saved user is \(objarray)")
        if objarray.contains(where: {( $0.email == email ) && ($0.password == password)}) {
            result = true
        } else {
        }
        return result
    }
    
}
