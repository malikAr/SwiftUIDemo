//
//  LoginView.swift
//  SwiftDemo
//
//  Created by Arun on 06/12/21.
//

import SwiftUI
import Combine

struct LoginView: View {
    @ObservedObject var viewModel = LoginViewModel()
    @State var isLoginMode = true
    @State var showAlert: Bool = false
    @State var alertMessage: String = ""
    
    @State private var isLoginValid: Bool = false
    @State private var shouldShowLoginAlert: Bool = false
    @State private var shouldShowSignUpAlert: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    Picker(selection: $isLoginMode, label: Text("Picker here")) {
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    if !isLoginMode {
                        Button {
                            
                        } label: {
                            Image(systemName: "person.fill")
                                .font(.system(size: 64))
                                .padding()
                        }
                    }
                    
                    
                    Group {
                        if !isLoginMode{
                            TextField("UserName", text: $viewModel.userName)
                                .keyboardType(.namePhonePad)
                                .autocapitalization(.none)
                                .cornerRadius(5)
                            TextField("Email", text: $viewModel.email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .cornerRadius(5)
                            SecureField("Password", text: $viewModel.password)
                                .keyboardType(.default)
                                .cornerRadius(5)
                            TextField("PhoneNumber", text: $viewModel.phoneNumber)
                                .keyboardType(.numberPad)
                                .autocapitalization(.none)
                                .cornerRadius(5)
                            
                            DatePicker("BirthDate", selection: $viewModel.birthDate, displayedComponents: .date).datePickerStyle(.automatic)
                            
                        }
                        else
                        {
                            TextField("Email", text: $viewModel.email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .background(Color.white)
                                .cornerRadius(5)
                            
                            SecureField("Password", text: $viewModel.password)
                                .cornerRadius(5)
                            
                        }
                    }
                    .padding(12)
                    .background(Color.white)
                    
                    if !isLoginMode{
                        Spacer()
                        Button {
                           signUp()
                        } label: {
                            HStack {
                                Spacer()
                                Text("Create Account")
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .font(.system(size: 14, weight: .semibold))
                                Spacer()
                            }.background(Color.blue)
                            
                        } .cornerRadius(10)

                        Button {
                            
                        } label: {
                            HStack {
                                Spacer()
                                Text("Reset")
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .font(.system(size: 14, weight: .semibold))
                                Spacer()
                            }.background(Color.blue)
                            
                        } .cornerRadius(10)
                    }
                    else
                    {
                        NavigationLink(destination: HomeView(),
                                       isActive: self.$isLoginValid) {
                            Text("Log In")
                                .onTapGesture {
                                    logIn()
                                }
                        }
                        .navigationBarBackButtonHidden(true)
                        .clipped()
                        .frame(width: 300, height: 40, alignment: .center)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .padding(.vertical, 10)
                        .font(.system(size: 15, weight: .bold)).padding()
                        .cornerRadius(20)

                    }
                }
                .padding()
            }
            .navigationTitle(isLoginMode ? "Log In" : "Create Account")
            .alert(isPresented: $shouldShowLoginAlert) {
                Alert(title: Text(self.alertMessage))
            }
            .background(Color(.init(white: 0, alpha: 0.05))
                            .ignoresSafeArea())
        }
        .navigationViewStyle(.stack)
    }
    
    private func resetDetail(){
        
    }
    
    
    private func signUp(){
        
        if viewModel.formMessage.elementsEqual("Valid"){
            if !viewModel.validUserCredential()
            {
            viewModel.saveUser()
            self.shouldShowLoginAlert = false
            self.alertMessage = "User saved Successfully."
            }
            else
            {
                self.shouldShowLoginAlert = true
                self.alertMessage = "user Already Exist."
            }
        }
        else
        {
            self.shouldShowLoginAlert = true
            self.alertMessage = viewModel.formMessage
        }
       
    }
    
    
    private func logIn() {
        if viewModel.isEmailPassEmpty{
            self.shouldShowLoginAlert = true //trigger Alert
            self.alertMessage =  " Emailid or Password can't be Empty"
        }
        else
        {
            self.shouldShowLoginAlert = false
            if viewModel.isEmailPassValid {
                if  !viewModel.validUserCredential()
                {
                    self.shouldShowLoginAlert = true
                    self.alertMessage =  "Invalid User credentials"
                }
                else
                {
                    self.isLoginValid = true
                    self.shouldShowLoginAlert = false
                }
            }
            else
            {
                self.shouldShowLoginAlert = true
                self.alertMessage =  "Email and Password is not Valid"
                
            }
            
        }

    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
