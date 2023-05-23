//
//  LoginView.swift
//  TrainingApp
//
//  Created by tom montgomery on 5/11/23.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct LoginView: View {
    
    @EnvironmentObject var model: ContentModel
    
    @State var loginMode = Constants.LoginMode.login
    @State var email = ""
    @State var name = ""
    @State var password = ""
    @State var errorMessage: String? = nil
    
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
            // error - "extra argument in call"
            // Wrap the form in a GROUP so we don't hit the 10 element limit of the VStack.  Doesn't change any functionality
            Group {
                TextField("Email", text: $email)
                    
                if loginMode == Constants.LoginMode.createAccount {
                    TextField("Name", text: $name)
                }
                SecureField("Password", text: $password)
                
                if errorMessage != nil {
                    // show it
                    Text(errorMessage!)
                }
            }

            
            // Button
            Button {
                if loginMode == Constants.LoginMode.login {
                    // Log the user in
                    
                    Auth.auth().signIn(withEmail: email, password: password) { result, error in
                        // open up the closure
                        // check for errors
                        guard error == nil else {
                            errorMessage = error!.localizedDescription
                            return
                        }
                        // no error, clear the errorMessage
                        // TODO: what's the diff between self.errorMessage and errorMessage when assigning nil?
                        self.errorMessage = nil
                        
                        // fetch the user metadata
                        model.getUserData()
                        
                        // change the view to the loggedIn view
                        model.checkLogin()
                    }
                }
                else {
                    // Create a new account
                    Auth.auth().createUser(withEmail: email, password: password) { result, error in
                        // check for errors
                        guard error == nil else {
                            // oh no!
                            self.errorMessage = error?.localizedDescription
                            return
                        }
                        // clear error message
                        self.errorMessage = nil
                        
                        // save the first name
                        let db = Firestore.firestore()
                        let firebaseUser = Auth.auth().currentUser
                        // we know this is not nil, b/c the user created an account and the error == nil
                        let userRef = db.collection("users").document(firebaseUser!.uid)
                        userRef.setData(["name": name], merge: true)
                        
                        // Update the user metadata
                        let user = UserService.shared.user
                        user.name = name
                        
                        // Change the view to loggedIn view
                        model.checkLogin()
                        
                        // returns just this one reference to the user service - the singleton
                        //UserService.shared.user
                    }
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
