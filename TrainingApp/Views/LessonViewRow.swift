//
//  LessonViewRow.swift
//  TrainingApp
//
//  Created by tom montgomery on 1/8/23.
//

import SwiftUI

struct LessonViewRow: View {
    // The EO passes it in, without having to pass it in!
    // create the EO so we can have access to model
    @EnvironmentObject var model: ContentModel
    var index: Int
    
    var body: some View {
        
        // force unwrap here.  we are already sure it's not nil
        let lesson = model.currentModule!.content.lessons[index]
        
        // Lesson Card
        // make the cards left aligned, then add padding/spacers as needed
        ZStack (alignment: .leading) {
            
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .frame(height: 66, alignment: .center)
            // frame width can span the whole thing
            
            HStack(spacing: 30) {
                Text(String(index + 1))
                    .bold()
                
                
                VStack(alignment: .leading) {
                    Text(lesson.title)
                        .bold()
                    Text(lesson.duration)
                    
                }
            }
            // padding between horizontal elements, mostly to push it off the left edge
            .padding()
        }
        .padding(.bottom, 5)
        // separate each card a bit with padding
    }
}

//struct LessonViewRow_Previews: PreviewProvider {
//    static var previews: some View {
//        LessonViewRow()
//    }
//}
