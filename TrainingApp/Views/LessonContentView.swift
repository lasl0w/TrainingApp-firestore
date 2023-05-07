//
//  LessonContentView.swift
//  TrainingApp
//
//  Created by tom montgomery on 1/7/23.
//

import SwiftUI

struct LessonContentView: View {
    
    // if I just include the EO, I have a list of modules but don't know which one to show the lessons of!
    // therefore I need to either
    // A) pass the 'module' in using a NavigationLink
    //var module: Module
    // PROBLEM:  (A) it makes it harder to navigate back once you get further down in the view heirarchy
    
    
    // or B) Instead of passing the module through in the view heirarchy, keep track of the selected Module in the ViewModel
    @EnvironmentObject var model: ContentModel
    
    
    var body: some View {
        ScrollView {
            
            LazyVStack {
            
                // Confirm that currentModule is set
                if model.currentModule != nil {
                    // Force unwrap b/c we will check
                    // ForEach(model.currentModule!.content.lessons) { lesson in
                    // use .count instead of .lessons so you have the index readily avail
                    ForEach(0..<model.currentModule!.content.lessons.count) { index in
                        
                        // create and populate each card, pass in the index
                        NavigationLink(
                            destination: LessonDetailView()
                                .onAppear(perform: {model.beginLesson(index)}),
                            label: {LessonViewRow(index: index)}
                        )
                    }
                }
            }
            // change lesson list back to black
            .accentColor(.black)
            .padding()
            .navigationBarTitle("Learn \(model.currentModule?.category ?? "")")
            // use nil coalescing operator to assign to empty string if nil
            // TODO .navigationTitle vs. .navigationBarTitle.  what gives?
        }
    }
}

//struct LessonContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        LessonContentView()
//    }
//}
