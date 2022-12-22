//
//  ContentView.swift
//  TrainingApp
//
//  Created by tom montgomery on 12/21/22.
//

import SwiftUI

// Refactor > rename ContentView to HomeView so it all makes sense
struct HomeView: View {
    
    // as long as the modifier is in the parent view, define it here to access it on this view
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
