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
    
    var id: Int
    var category: String
    var content: Content
    var test: Test
    
}

struct Content : Decodable, Identifiable {
    
    var id: Int
    var image: String
    var time: String
    var description: String
    var lessons: [Lesson]
    
}

struct Lesson : Decodable, Identifiable {
    
    var id: Int
    var title: String
    var video: String
    var duration: String
    var explanation: String
    
}

struct Test : Decodable, Identifiable {
    
    var id: Int
    var image: String
    var time: String
    var description: String
    var questions: [Question]
}

struct Question : Identifiable, Decodable {
    var id: Int
    var content: String
    var correctIndex: Int
    var answers: [String]   
}
