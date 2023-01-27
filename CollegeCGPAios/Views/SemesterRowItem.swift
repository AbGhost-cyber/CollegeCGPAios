//
//  SemesterRowItem.swift
//  CollegeCGPAios
//
//  Created by dremobaba on 2023/1/26.
//

import SwiftUI

struct SemesterRowItem: View {
    let semester: Semester
    var onClick: ((Semester)->Void)? = nil
    var body: some View {
        Button {
            onClick?(semester)
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(semester.semesterName.capitalized)
                        .font(.primaryBold)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.primary)
                        
                    Text(semester.threeCourseNames)
                        .font(.subheadline)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color(uiColor: .secondaryLabel))
                }
                Spacer()
                GPAProgressBar(gpa: semester.gpa)
            }
        }
    }
}

struct SemesterRowItem_Previews: PreviewProvider {
    static var previews: some View {
        SemesterRowItem(semester: Year.years[0].semesters[0])
    }
}
