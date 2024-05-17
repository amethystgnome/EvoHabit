//
//  AuthenticationView.swift
//  EvoHabit
//
//  Created by Aubrianna Sample on 5/16/24.
//

import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State private var isLogin = true
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack {
            if isLogin {
                Text("Login")
                    .font(.largeTitle)
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                if let error = authViewModel.authError {
                    Text(error).foregroundColor(.red)
                }
                Button("Login") {
                    authViewModel.login(email: email, password: password)
                }
                .padding()
            } else {
                Text("Sign Up")
                    .font(.largeTitle)
                TextField("Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                if let error = authViewModel.authError {
                    Text(error).foregroundColor(.red)
                }
                Button("Sign Up") {
                    authViewModel.signUp(name: name, email: email, password: password)
                }
                .padding()
            }
            Button(isLogin ? "Switch to Sign Up" : "Switch to Login") {
                isLogin.toggle()
            }
        }
        .padding()
    }
}




