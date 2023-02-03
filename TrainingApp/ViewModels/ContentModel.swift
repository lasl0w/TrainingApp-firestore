//
//  ContentModel.swift
//  TrainingApp
//
//  Created by tom montgomery on 12/21/22.
//

import Foundation

class ContentModel: ObservableObject {
    
    // Initialize with an empty array of modules
    // since it's publishedd, whatever view code is using it will know when it emits
    @Published var modules = [Module]()
    
    // Current module - keep track so we can nav around easier.  Published so any UI view that depends on it will update appropriately when we swap it out
    // Might be nil if a user hasn't selected a module yet
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    
    // Current Lesson - save the lesson in state to nav around easier.  The WHOLE thing, not just the Index.
    @Published var currentLesson: Lesson?
    var currentLessonIndex = 0
    // Current Question - just like we did to keep track of our current lesson
    // Update the currentQuestion and our Quiz view triggers to update all the elements, advancing the user to the next question
    @Published var currentQuestion: Question?
    var currentQuestionIndex = 0
    
    // Current lesson explanation OR question content
    @Published var styledContent = NSAttributedString()
    // use this type for webview / UItextview content for proper HTML/CSS handling
    
    // Current selected content and test
    @Published var currentLessonSelected: Int?
    @Published var currentTestSeleced: Int?
    
    var styleData: Data?
    
    
    // gets called any time we create an instance of ContentModel()
    // firstly/specifically when we create the .environmentObject in @main
    init() {
        
        // parse local json data
        getLocalData()
        
        // download remote data then parse it
        getRemoteData()
    }
    
    // MARK: - Data methods
    
    func getLocalData() {
        
        // get a URL to the JSON file
        let jsonURL = Bundle.main.url(forResource: "data", withExtension: "json")
        
        // read file into a data object
        do {
            // Data() throws, so must be in a do/try/catch
            let jsonData = try Data(contentsOf: jsonURL!)

            // try to decode the JSON into an array of Module(s)
            let jsonDecoder = JSONDecoder()
            let modules = try jsonDecoder.decode([Module].self, from: jsonData)
            
            // if successful, Assign parsed modules to modules property
            self.modules = modules
        }
        catch {
                print("jsonURL path failed.  couldn't parse local data")
        }
        
        // Parse the style data
        let styleURL = Bundle.main.url(forResource: "style", withExtension: "html")
        
        do {
            // read the file into the data object
            let styleData = try Data(contentsOf: styleURL!)
            
            self.styleData = styleData
        }
        catch {
            // Log error
            print("Couldn't parse the style data")
        }
    }
    
    func getRemoteData() {
        // THREADING - Main vs. Background
        // 1)  Main thread needs to "maintain it's freedom" and is responsible for updating the UI
        // 2)  Background execution thread does the fetching
        // 2a) best practice to not use the background thread to update the UI, instead wrap it in a dispatchQueue
        // 2b) may need to add self. to hep specify for the DispatchQueue
        
        
        // String path
        let urlString = "https://lasl0w.github.io/training-data/data2.json"
        // Create URL object
        let url = URL(string: urlString)
        // might fail.  "guard" is like "ensure X to move on"
        guard url != nil else {
            // guard body must return or throw
            // Couldn't create a URL, return nothing
            return
        }
        // Create a URLRequest object
        let request = URLRequest(url: url!)
        
        // Get the session and kick off the task
        // .shared is a special singleton call.   No parens needed.
        let session = URLSession.shared
        
        // returns a URLSessionDataTask object
        // use a closure instead of the completionHandler syntax.  It says - 'the closure is the completion handler'
        let dataTask = session.dataTask(with: request) { (data, response, error ) in
            // Define the Completion Handler here:
            
            // Check if there is an error
            guard error == nil else {
                //there was an error - bail
                return
            }
            
            // handle the response
            do {
                // Create the jsonDecoder
                let decoder = JSONDecoder()
                // Decode - point to what MODEL?  make me some [MODULES] baby!
                let modules = try decoder.decode([Module].self, from: data!)
                
                // append to the Modules
                // self.modules += modules
                // SELF here refers to the WHOLE CONTENTMODEL CLASS
                
                // THREADING ISSUE above - BETTER TO USE A DispatchQueue
                DispatchQueue.main.async {
                    // assign it to the main thread to take care of it when it gets a chance
                    self.modules += modules
                }
            }
            catch {
                // couldn't parse json
                return
            }
           
            
            
        }
        // Actually makes the call, which invokes the above completion handler
        dataTask.resume()
        

    }
    
    // MARK: - Module navigation methods
    
    // omit the argument label with the _ in front of the arg, to make it easier when calling
    func beginModule(_ moduleid:Int) {
        
        // Find the index for this module ID
        for index in 0..<modules.count {
            if modules[index].id == moduleid {
                // Found the matching module
                currentModuleIndex = index
                break
            }
        }
        
        // Set the current module
        currentModule = modules[currentModuleIndex]
    }
    
    func beginLesson(_ lessonIndex:Int) {
        
        // check that it is in range
        if lessonIndex < currentModule!.content.lessons.count {
            currentLessonIndex = lessonIndex
        }
        else {
            currentLessonIndex = 0
        }
        
        // set the current lesson
        currentLesson = currentModule!.content.lessons[currentLessonIndex]
        // any value (and view) that relies on the currentLesson will be notified when we assign this as it's published and emits
        styledContent = addStyling(currentLesson!.explanation)
    }
    
    func hasNextLesson() -> Bool {
        
        guard currentModule != nil else {
            return false
        }
        
        // core logic - verbose definition
//        if currentLessonIndex + 1 < currentModule!.content.lessons.count {
//            return true
//        }
//        else {
//            return false
//        }
        
        // Shorthand of the above. 
        return (currentLessonIndex + 1 < currentModule!.content.lessons.count)
    }
    
    func nextLesson() {
        
        // Advance the lesson
        currentLessonIndex += 1
        
        // check that it is within current range
        if currentLessonIndex < currentModule!.content.lessons.count {
            // Set the current lesson property
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            styledContent = addStyling(currentLesson!.explanation)
        }
        else {
            // Shit is weird!  just Reset the lesson state
            currentLessonIndex = 0
            currentLesson = nil
            // order might matter.  reset index first
            // is it possible to hit this?  Would it drop you back at the top of the view heirarchy? YES
            // changing currentLesson will change all views dependent on it
        }
        

    }
    
    // MARK: Quiz Functions
    
    func beginTest(_ moduleId:Int) {
        
        // Set the current module
        beginModule(moduleId)
        print("Current Question Index: " + String(currentQuestionIndex))
        // Set the current question - use optional chaining (?), must also coalesce
        // if there are questions, set the current question to the first one
        if currentModule?.test.questions.count ?? 0 > 0 {
            // now we can safely unwrap
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            print("Current Question Index: " + String(currentQuestionIndex))
            // Set the question content and convert the String to an NSAttributedString
            styledContent = addStyling(currentQuestion!.content)
        }
        
    }
    
    func nextQuestion() {
        
        // Advance the question index
        currentQuestionIndex += 1
        
        // Check that it's within range
        if currentQuestionIndex < currentModule!.test.questions.count {
            // Set the currentQuestion and the styledContent
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            styledContent = addStyling(currentQuestion!.content)
            
        }
        else {
            // If not, reset the properties.  Time to show the results view
            currentQuestionIndex = 0
            currentQuestion = nil
        }
        
    }
    
    // MARK: - Code Styling
    
    // Need a helper function to set our rich lesson 'explanation' content
    private func addStyling(_ htmlString: String) -> NSAttributedString {
        
    // https://www.hackingwithswift.com/example-code/system/how-to-convert-html-to-an-nsattributedstring
        // basic tut ^^^
        // TODO: - do it as a one-off tut
        
        var resultString = NSAttributedString()
        var data = Data()
        
        // Add the styling data (from the very beginning of parsing)
        if styleData != nil {
            data.append(styleData!)
        }
        
        
        // Add the html data
        // since data is a Data() object, need to do type conversion
        data.append(Data(htmlString.utf8))
        
        // Convert to attributed string - NSAttributedString throws
        
        // TECHNIQUE 1 - No error response / handling
        // the try? suppresses the error
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            
            // big IF, then do the code block
            resultString = attributedString
        }
        
        // TECHNIQUE 2 - catch and handle the error
        // do we need to handle it, correct it or show a message to the user?  If yes, then do T2
//        do {
//
//            let attributedString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
//
//                resultString = attributedString
//        }
//        catch {
//            print("couldn't turn html into an attributed string")
//        }
        return resultString
        
        // THEN... set the lessonDescription in beginLesson() AND nextLesson so that emits/updates too
    }
}
