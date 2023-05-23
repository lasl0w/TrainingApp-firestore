//
//  ProfileView.swift
//  TrainingApp
//
//  Created by tom montgomery on 5/11/23.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        Button {
            // don't care about catching the error right now.  proper is a do/try/catch block
            try! Auth.auth().signOut()
            
            // Change to loggedOut view
            model.checkLogin()
            
        } label: {
            Text("Sign Out")
        }

        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
