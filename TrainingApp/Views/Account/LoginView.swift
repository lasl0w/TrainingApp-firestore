//
//  LoginView.swift
//  TrainingApp
//
//  Created by tom montgomery on 5/11/23.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    
    @EnvironmentObject var model: ContentModel
    
    @State var loginMode = Constants.LoginMode.login
    @State var email = ""
    @State var name = ""
    @State var password = ""
    @State var errorMessage: String = ""
    
    // Computed property for button text
    var buttonText: String {
        if loginMode == Constants.LoginMode.login {
            return "Login"
        }
        else {
            return "Signup"
        }
    }
    
    var body: some View {
        Text("Hello, World - I'm logged in!")
        
        VStack(spacing: 10) {
            
            Spacer()
            // Logo
            Image(systemName: "book")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 150)
            // Title
            Text("LearnZilla")
                .font(.title)
            
            Spacer()
            // Picker
            Picker(selection: $loginMode, label: Text("Hey")) {
                Text("Login")
                    .tag(Constants.LoginMode.login)
                Text("Sign up")
                    .tag(Constants.LoginMode.createAccount)
                
            }
            .pickerStyle(SegmentedPickerStyle())
            
            // Form
            TextField("Email", text: $email)
                
            if loginMode == Constants.LoginMode.createAccount {
                TextField("Name", text: $name)
            }
            SecureField("Password", text: $password)
            
            // Button
            Button {
                if loginMode == Constants.LoginMode.login {
                    // Log the user in
                    
                    Auth.auth().signIn(withEmail: email, password: password) { result, error in
                        // open up the closure
                        // check for errors
                        guard error == nil else {
                            return
                        }
                        
                    }
                }
                else {
                    // Create a new account
                }
            } label: {
                // custom button
                ZStack {
                    Rectangle()
                        .foregroundColor(.blue)
                        .frame(height: 40)
                        .cornerRadius(10)
                    Text(buttonText)
                        .foregroundColor(.white)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 40)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        // even though it's a text field style, you can apply it at the VStack / container level
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
