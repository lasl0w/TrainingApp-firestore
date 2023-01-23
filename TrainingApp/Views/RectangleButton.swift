//
//  RectangleButton.swift
//  TrainingApp
//
//  Created by tom montgomery on 1/22/23.
//

import SwiftUI

struct RectangleButton: View {
    
    // allow a color to be passed in, but set a default
    var color = Color.white
    
    var body: some View {
        
        // even though it's a small thing....make this reusable to:
        // 1)  call it whenever we need it
        // 2)  change it once, apply changes globally
        Rectangle()
            //.frame(height: 48) --- setting the frame on the view call instead
            .foregroundColor(color)
        // set foreground, not background on Rectangle() based buttons!!!
            .cornerRadius(10)
            .shadow(radius: 5)
            //.padding() // brought off the edges nicely, but apply to whole vstack
    }
}

struct RectangleButton_Previews: PreviewProvider {
    static var previews: some View {
        RectangleButton()
    }
}
