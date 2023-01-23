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
    
    // Current Lesson - save the lesson in state to nav around easier.  The WHOLE thing, not just the Index
    @Published var currentLesson: Lesson?
    var currentLessonIndex = 0
    
    // Current lesson explanation
    @Published var lessonDescription = NSAttributedString()
    // use this type for webview / UItextview content for proper HTML/CSS handling
    
    // Current selected content and test
    @Published var currentLessonSelected: Int?
    
    var styleData: Data?
    
    
    // gets called any time we create an instance of ContentModel()
    // firstly/specifically when we create the .environmentObject in @main
    init() {
        
        getLocalData()
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
        lessonDescription = addStyling(currentLesson!.explanation)
    }
    
    func hasNextLesson() -> Bool {
        
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
            lessonDescription = addStyling(currentLesson!.explanation)
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
