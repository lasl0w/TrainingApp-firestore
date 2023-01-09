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
                                
                                NavigationLink(destination: LessonContentView().onAppear(perform: { model.beginModule(module.id)}), label: {
                                    // Learning Card
                                    HomeViewRow(image: module.content.image, title: "Learn \(module.category)", description: module.content.description, count: "\(module.content.lessons.count) Lessons", time: module.content.time)
                                })
                                
                                

                                
                                // Test Card
                                HomeViewRow(image: module.test.image, title: "\(module.category) Test", description: module.test.description, count: "\(module.test.questions.count) Questions", time: module.test.time)

                                
                            }

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
        }

        


    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ContentModel())
        // must add the EO on the preview with an instance of the ContentModel in order for things to render
    }
}
