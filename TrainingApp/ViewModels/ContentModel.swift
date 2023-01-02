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
    var styleData: Data?
    
    // gets called any time we create an instance of ContentModel()
    // firstly/specifically when we create the .environmentObject in @main
    init() {
        
        getLocalData()
    }
    
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
}
