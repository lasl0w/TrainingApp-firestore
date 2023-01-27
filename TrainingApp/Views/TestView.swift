//
//  TestView.swift
//  TrainingApp
//
//  Created by tom montgomery on 1/24/23.
//

import SwiftUI

struct TestView: View {
    
    // how do we know what Quiz was clicked and where we are? the EO!
    @EnvironmentObject var model: ContentModel
    
    
    var body: some View {
        
        // TODO - The view won't render unless I add an empty text element.  why?  b/c the .onAppear was not firing.  must handle ELSE
        //Text("")
        if model.currentQuestion != nil {
            
            VStack {
                // Question Number
                // will get an 'appendInterpolation' error if you don't do nil coalescence.
                Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.questions.count ?? 0)")
                // Question
                CodeTextView()
                // on the lesson, it got it's data from model.lessonDescription
                
                // Answers
                
                // Button
                
            }
            .navigationBarTitle("\(model.currentModule?.category ?? "") Test")
        }
        else {
            // Test hasn't loaded yet
            //Text("")
            ProgressView()
            //any element in here triggers the .onAppear.
        }
    
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
