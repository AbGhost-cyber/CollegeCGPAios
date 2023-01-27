//
//  EditCreateSemesterView.swift
//  CollegeCGPAios
//
//  Created by dremobaba on 2023/1/27.
//

import SwiftUI

struct SemesterState {
    var courses: [Course] = []
    var semesterName: String = ""
}
struct EditCreateSemesterView: View {
    private var semester: Semester? = nil
    @State private var state: SemesterState = SemesterState()
    
    init(semester: Semester? = nil) {
        self.semester = semester
    }
    
    var body: some View {
        VStack {
            Text(state.semesterName)
        }
        .onAppear {
            if let semester = semester {
                state.semesterName = semester.semesterName
                state.courses = semester.courses
            }
        }
    }
}

struct EditCreateSemesterView_Previews: PreviewProvider {
    static var previews: some View {
        EditCreateSemesterView()
    }
}
