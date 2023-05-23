//
//  TrainingAppApp.swift
//  TrainingApp
//
//  Created by tom montgomery on 12/21/22.
//

import SwiftUI
import FirebaseCore

@main
struct TrainingApp: App {
    
    init() {
        // Firebase Project = Training App
        FirebaseApp.configure()
    }
    
    
    
    var body: some Scene {
        WindowGroup {
            LaunchView()
                .environmentObject(ContentModel())
            // set to top level
            // can create right from the start, even when ContentModel is an empty class (as part of project setup)
        }
    }
}
