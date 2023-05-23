//
//  LaunchView.swift
//  TrainingApp
//
//  Created by tom montgomery on 5/11/23.
//

import SwiftUI

struct LaunchView: View {
    
    // assume user is not logged in at first
    // just b/c we default to false, doesn't mean they are logged out on launch!
    //@State var loggedIn = false
    // Needs to be published in the contentModel - used all over
    
    // need to know loggedIn
    @EnvironmentObject var model: ContentModel
    
    
    var body: some View {
        

        if model.loggedIn == false {
            // Show the log in or create account view
            LoginView()
                .onAppear {
                    // Check if the user is logged in or out
                    // happens so fast, they shouldn't see the form if they have an active session, it will flip loggedIn and re-render
                    model.checkLogin()
                }
        }
        else {
            
            // show the loggedIn view
            TabView {
                HomeView()
                    .tabItem {
                        VStack {
                            Image(systemName: "book")
                            Text("Learn")
                        }
                    }
                ProfileView()
                    .tabItem {
                        VStack {
                            Image(systemName: "person")
                            Text("Profile")
                        }
                    }
            }
            
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
