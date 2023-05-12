//
//  TestResultsView.swift
//  TrainingApp
//
//  Created by tom montgomery on 1/28/23.
//

import SwiftUI

struct TestResultsView: View {
    
    @EnvironmentObject var model: ContentModel
    
    // Need to pass this in, b/c it's local to the parent TestView
    var numCorrect: Int
    
    var resultHeading: String {
        
        // use the guard so the first time through (i.e. ProgressView() time), it won't unwrap a nil
        // better than coalescing in this case so we don't divide by zero!
        guard model.currentModule != nil else {
            return ""
        }
        
        let pct = Double(numCorrect) / Double(model.currentModule!.test.questions.count)
        
        if pct > 0.5 {
            return "Awesome!"
        }
        else if pct > 0.2 {
            return "Doing Great!"
        }
        else {
            return "Keep Learning..."
        }
    }
    
    var body: some View {
        VStack {
            
            Text(resultHeading)
            Spacer()
            // preview will crash if you force unwrap instead of nil coalesce
            Text("You got \(numCorrect) out of \(model.currentModule?.test.questions.count ?? 0) !")
            Spacer()
            // using the double-closure syntax b/c both the ACTION and LABEL require functions/code
            Button {
                // Send the user back to the home view
                // b/c it is the binding to the Nav selection:
                model.currentTestSeleced = nil
            } label: {
                ZStack {
                    RectangleButton(color: .green)
                        .frame(height: 48)
                    Text("Complete")
                        .bold()
                        .foregroundColor(.white)
                }

            }
            .padding()
            Spacer()
        }
    }
}

struct TestResultsView_Previews: PreviewProvider {
    static var previews: some View {
        TestResultsView(numCorrect: 2)
            .environmentObject(ContentModel())
    }
}
