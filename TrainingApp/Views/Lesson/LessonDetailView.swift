//
//  LessonDetailView.swift
//  TrainingApp
//
//  Created by tom montgomery on 1/9/23.
//

import SwiftUI
import AVKit
// had to add AVkit in General settings > Frameworks first

struct LessonDetailView: View {
    
    // gotta access the EO here too! but which lesson do we show....
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        //now that we have access to the EO and the .onAppear has run, we can read the currentLesson
        let lesson = model.currentLesson
        // Use Optional Chaining here b/c there is a chance that the lesson will be nil
        // use nil coalescing operator.  and parens so it gets evaluated before the string concat
        let url = URL(string: Constants.videoHostUrl + (lesson?.video ?? ""))
        
        // URL prefix:  https://codewithchris.github.io/learningJSON
        // with AVkit imported, can use the VideoPlayer
        
        // 3 vert elements, so use a VStack
        VStack {
            // only show video if we get a valid URL
            if url != nil {
                // wrap in the IF check, so we can safely unwrap
                VideoPlayer(player: AVPlayer(url: url!))
                    .cornerRadius(10)
            }
            
            // Description - new UIKit UITextView element
            CodeTextView()
            
            // Next lesson button
            
            // only show IF there is a next lesson
            if model.hasNextLesson() {
                // placeholder button has closures >>> action: {} and label: {Text("Next Lesson")}
                Button(action: {
                    model.nextLesson()
                    
                }, label: {
                    ZStack {
                        RectangleButton(color: Color.green)
                            .frame(height: 48)
                        
                        // we are checking for .hasNextLesson, so we should be able to safely access the properties
                        Text("Next Lesson: \(model.currentModule!.content.lessons[model.currentLessonIndex + 1].title)")
                            .foregroundColor(Color.white)
                            .bold()
                            
                    }

                })
                // BUTTON STYLING - OPT 1 (simple, single use) == add padding(), background color, drop shadow and corner radius HERE on the Button()
                // problem - it works for a button, but not reusable
                // BUTTON STYLING - OPT 2 (reusable component) == do ZStack + Rectangle() with foregroundColor, frame, etc as the label
            }
            else {
                // Show the Comlete button
                Button(action: {
                    // send them back to the home view
                    model.currentLessonSelected = nil
                    
                }, label: {
                    ZStack {
                        
                        RectangleButton(color: Color.green)
                            .frame(height: 48)
  
                        
                        // we are checking for .hasNextLesson, so we should be able to safely access the properties
                        Text("Complete")
                            .foregroundColor(Color.white)
                            .bold()
                            
                    }

                })
                
                // Zoom them back to the HomeView!
                
            }

        }
        .padding()
        .navigationBarTitle(lesson?.title ?? "")
    }
}

struct LessonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LessonDetailView()
    }
}
