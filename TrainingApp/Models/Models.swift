//
//  Models.swift
//  TrainingApp
//
//  Created by tom montgomery on 12/26/22.
//

import Foundation

// Decodable so we can use the JSON decoder
// Identifiable so we can loop through it and show it in a list
struct Module : Decodable, Identifiable {
    
    // CHANGING to set initial values, to play well with firestore parsing and initial var setting
    // ALOWS us to create a Module() instance without passing in all the params so we can set them manually from firestore
    // so that we can see / show our work
    
    var id: String = ""
    var category: String = ""
    var content: Content = Content()
    var test: Test = Test()
    
}

struct Content : Decodable, Identifiable {
    
    var id: String = ""
    var image: String = ""
    var time: String = ""
    var description: String = ""
    var lessons: [Lesson] = [Lesson]()
    
}

struct Lesson : Decodable, Identifiable {
    
    var id: String = ""
    var title: String = ""
    var video: String = ""
    var duration: String = ""
    var explanation: String = ""
    
}

// The QUIZ part of the app
struct Test : Decodable, Identifiable {
    
    var id: String = ""
    var image: String = ""
    var time: String = ""
    var description: String = ""
    var questions: [Question] = [Question]()
}

struct Question : Identifiable, Decodable {
    var id: String = ""
    var content: String = ""
    var correctIndex: Int = 0
    var answers: [String] = [String]()
}

// Need a model representation for when we fetch the User document from firestore

class User {
    // struct is passed around by value.  It passes a copy of it.  Not by reference
    // use CLASS:  in this case, for a logged in user, we always want to be accessing the same object since we are tracking lastX
    // we will couple the class usage with our use of a singleton so we can always be sure.  Helper class UserService.
    var name: String = ""
    var lastModule: Int?
    var lastLesson: Int?
    var lastQuestion: Int?
}
