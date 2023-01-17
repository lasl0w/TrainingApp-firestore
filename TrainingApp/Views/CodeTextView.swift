//
//  CodeTextView.swift
//  TrainingApp
//
//  Created by tom montgomery on 1/16/23.
//

import SwiftUI

struct CodeTextView: UIViewRepresentable {
    // use UIViewR protocol to use MapKit, Webkit and create UITextViews
    // must implement the required funcs to conform to the protocol
    
    @EnvironmentObject var model: ContentModel
    
    
    // in our case, we return a UITextView to have an HTML+CSS attributed string
    func makeUIView(context: Context) -> UITextView {
        
        let textView = UITextView()
        
        // Bizarre! the default is editable.... go figure
        textView.isEditable = false
        
        return textView
    }
    
    func updateUIView(_ textView: UITextView, context: Context) {
        // Set the attributed text for the lesson
        textView.attributedText = model.lessonDescription
        
        //Scroll back to the top - can't see the CGRect, just defines the area
        textView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
        // width:0 height: 0 doesn't work.  animated = true creates problems on really fast clicks
    }
    
    
}

struct CodeTextView_Previews: PreviewProvider {
    static var previews: some View {
        CodeTextView()
    }
}
