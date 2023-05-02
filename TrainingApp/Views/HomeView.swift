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
    
    // FIRESTORE - refactor tag to use .hash, because it's an Int and can be used to distinguish the module that was tapped
    
    var body: some View {
        
        // Put the whole thing in a NavView
        NavigationView {
            VStack(alignment: .leading) {
                Text("What do you want to do today?")
                    .padding(.leading, 20)
                
                // List of cards is a scrollview
                ScrollView {
                    
                    // Load cards only as we need them
                    LazyVStack {
                        
                        // create each card with a ForEach specific to view creation
                        ForEach (model.modules) { module in
                            
                            // wrap in VS to get a little extra spacing between cards
                            VStack(spacing:20) {
                                
                                // .onAppear does not fire until AFTER LessonContentView is rendered
                                NavigationLink(
                                    destination: LessonContentView().onAppear(perform: { model.beginModule(module.id)
                                        //print(model.currentLessonSelected)
                                    }),
                                    tag: module.id.hash,
                                    selection: $model.currentLessonSelected,
                                    // selection must be a BINDING so it can read and write
                                    label: {
                                    // Learning Card
                                    HomeViewRow(image: module.content.image, title: "Learn \(module.category)", description: module.content.description, count: "\(module.content.lessons.count) Lessons", time: module.content.time)
                                })
                                // similar to BEGIN_MODULE when a user clicks on a test, BUT we have to have a function that both sets the current module based on what the user clicked AND sets the current question so they go right into the quiz
                                // use .onAppear to 'interrupt' and run the func right when the view is called
                                
                                // Using the same module.id tag as above is OK b/c we are tracking the selection with a different param
                                NavigationLink(
                                    destination:
                                        TestView()
                                        .onAppear(perform: {
                                        model.beginTest(module.id)
                                        }),
                                    // Note the indent clarity above
                                    tag: module.id.hash,
                                    selection: $model.currentTestSeleced,
                                    
                                    label: {
                                        // Test Card
                                        HomeViewRow(image: module.test.image, title: "\(module.category) Test", description: module.test.description, count: "\(module.test.questions.count) Questions", time: module.test.time)

                                    })
                                // The label above could be explicit like it is OR it could be defined as a trailing closure
                            }
                            .padding(.bottom, 10)

                        }
                        
                    }
                    .accentColor(.black)
                    // counteract the NavLink blue default
                    .padding()
                    // add padding on the LazyV to accomodate .aspectRatio()
                }
            }
            .navigationTitle("Get Started")
            // Add the .navTitle on the VStack
            // Use .onChange to reset the selection on the Lesson NavLink
            //.onChange(of: model.currentLessonSelected) { changedValue in
            //    if changedValue == nil {
            //        model.currentModule = nil
            //    }
        }
        .navigationViewStyle(.stack)
        // must set the view style, post XCODE 13 in order to prevent the view from going back to prev automatically
    }
    }

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ContentModel())
        // must add the EO on the preview with an instance of the ContentModel in order for things to render
    }
}
