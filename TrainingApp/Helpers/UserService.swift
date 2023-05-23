//
//  UserService.swift
//  TrainingApp
//
//  Created by tom montgomery on 5/17/23.
//

import Foundation

// Our Singleton
class UserService {
    
    var user = User()
    
    // referenced outside.  confirms there can be only this one reference
    static var shared = UserService()
    
    // can't create an instance of this class outside of this, using 'private'.  this helps us keep it to a singleton.
    private init() {
        
    }
}
