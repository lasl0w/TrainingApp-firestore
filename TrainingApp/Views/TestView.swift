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
    // Track selected answer with a state var - initialized as nil to help disable Submit button
    @State var selectedAnswerIndex:Int?
    // must be State b/c we need to modify it
    @State var numCorrect = 0
    // need Submitted state so we know when to grade AND to prevent them from changing their answer
    @State var submitted = false
    
    
    var body: some View {
        
        // TODO - The view won't render unless I add an empty text element.  why?  b/c the .onAppear was not firing.  must handle ELSE
        //Text("")
        if model.currentQuestion != nil {
            
            VStack {
                // Question Number
                // will get an 'appendInterpolation' error if you don't do nil coalescence.
                Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.questions.count ?? 0)")
                    .padding(.leading, 20)
                // Question
                CodeTextView()
                    .padding(.horizontal, 20)
                // on the lesson, it got it's data from model.lessonDescription, refactored to allow CodeTextView to render any styled content
                
                // Answers
                // use scrollview b/c answers might be long
                // use Vstack and Foreach b/c unknown amount of answers
                //
                
                ScrollView {
                    VStack {
                        ForEach (0..<model.currentQuestion!.answers.count, id: \.self) { index in
                            // put each in a button and use our Rectangle styled view
                            
                            // MAKE THE ZSTACK THE BUTTON LABEL so the entire width of the Rectangle button frame is clickable!!!
                            Button {
                                // Track the selected index
                                selectedAnswerIndex = index
                            } label: {
                                ZStack {
                                    
                                    if submitted == false {
                                        // allow free updates/changes to selectedAnswerIndex
                                        // use a ternary to cleanly (fewest lines) make it conditional
                                        RectangleButton(color: index == selectedAnswerIndex ? .gray: .white)
                                            .frame(height: 48)
                                    }
                                    else {
                                        // Answer has been submitted
                                        if index == selectedAnswerIndex && index == model.currentQuestion!.correctIndex {
                                            // CORRECT! show a green background
                                            RectangleButton(color: .green)
                                                .frame(height: 48)
                                        }
                                        else if index == selectedAnswerIndex && index != model.currentQuestion!.correctIndex {
                                            // WRONG! - show a red background (on the selected Answer
                                            RectangleButton(color: .red)
                                                .frame(height: 48)
                                        }
                                        else if index == model.currentQuestion!.correctIndex {
                                            // Let us highlight the correct answer for you - gotta learn
                                            RectangleButton(color: .green)
                                                .frame(height: 48)
                                        }
                                        else {
                                            RectangleButton(color: .white)
                                                .frame(height: 48)
                                        }
                                    }
                                   
                                    Text(model.currentQuestion!.answers[index])
                                }
                                //.padding() // separate each answer

                            }
                            .disabled(submitted)
                            // if it's true....then no cheating
                        }
                    }
                    .padding()
                    // mostly for left/right edges
                    .accentColor(.black)
                }
                // Submit - Button
                
                Button {
                    
                    // toggle submitted so they can't change their answer!
                    if submitted == true {
                        // Answer has already been submitted, move to the next question
                        model.nextQuestion()
                        
                        // reset local state properties
                        selectedAnswerIndex = nil
                        submitted = false
                    }
                    else {
                        // Submit the answer
                        submitted = true
                        
                        // check the answer and increment the counter if correct
                        if selectedAnswerIndex == model.currentQuestion!.correctIndex {
                            numCorrect += 1
                        }
                    }
                } label: {
                    ZStack {
                        RectangleButton(color: .green)
                            .frame(height: 48)
                        Text(buttonText)
                            .bold()
                            .foregroundColor(Color.white)
                            
                    }
                    
                    .padding()
                }
                .disabled(selectedAnswerIndex == nil)
                
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
    
    // use a COMPUTED PROPERTY for the submit button test
    var buttonText: String {
        // define the property type, then apply the logic with a trailing closure
        if submitted == true {
            if model.currentQuestionIndex + 1 == model.currentModule!.test.questions.count {
                // It's the last question
                return "Finish"
            }
            else {
                return "Next"
            }
             // or Finish
        }
        else {
            return "Submit"
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
            .environmentObject(ContentModel())
        // preview will crash hard without the EO!  lol, just gets the spinner
    }
}
