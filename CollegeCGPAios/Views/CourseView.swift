//
//  CourseView.swift
//  CollegeCGPAios
//
//  Created by dremobaba on 2023/1/28.
//

import SwiftUI

struct CourseView: View {
    let course: Course
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(course.courseName)
                    .font(.primaryBold)
                Text("\(course.creditHours.twoDecimalStr) credit hours")
                    .font(.secondaryText)
            }
           Spacer()
            Text(course.grade.gradePoints)
                .font(.gradePoint)
                .foregroundColor(Color.blue)
                .frame(maxWidth: 50, alignment: .trailing)
        }
    }
}

struct CourseView_Previews: PreviewProvider {
    static var previews: some View {
        CourseView(course: Year.years[0].semesters[0].courses[0])
    }
}
