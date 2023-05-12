//
//  HomeViewRow.swift
//  TrainingApp
//
//  Created by tom montgomery on 1/6/23.
//

import SwiftUI

struct HomeViewRow: View {
    
    // pass everything in
    var image: String
    var title: String
    var description: String
    var count: String
    var time: String
    
    var body: some View {

        // Home View Cards - each card will sit atop a rectangle
        ZStack {
            // nice styled background
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .aspectRatio(CGSize(width: 335, height: 175), contentMode: .fit)
            // use aspectRatio instead of .frame in this case to optimize for different screen sizes
                //.frame(width: 335, height: 175)
            
            // all of the elements on top of the rectangle
            HStack {
                
                // Course Image
                Image(image)
                    .resizable()
                    .frame(width: 116, height: 116)
                    .clipShape(Circle())
                // yay clipShape!
                Spacer()
                VStack(alignment: .leading, spacing: 10){
                    // left align the whole VStack
                    // course name  (Headline)
                    Text(title)
                        .bold()
                    // course description
                    Text(description)
                        .padding(.bottom, 20)
                        .font(.caption)
                    // padding to create the necessary space in addition to the spacing on the parent VStack
                    // Icons - in the VStack
                    HStack {
                        // # of lessons
                        Image(systemName: "text.book.closed")
                            .resizable()
                            .frame(width: 15, height: 15)
                        Text(count)
                            //.font(.caption)  was too big, it wrapped
                            .font(Font.system(size: 10))
                        Spacer()
                        // time (duration)
                        Image(systemName: "clock")
                            .resizable()
                            .frame(width: 15, height: 15)
                        Text(time)
                            .font(Font.system(size: 10))
                            
                    }
                    
                }
                .padding(.leading, 20)
                
                
            }
            .padding(.horizontal, 20)
            // Add padding to parent HStack to push back on the Spacer() a bit
            
        }
        
    }
}

struct HomeViewRow_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewRow(image: "swift", title: "Learn Swift", description: "An intro to Swift Programming", count: "10 Lessons", time: "3 Hours")
    }
}
