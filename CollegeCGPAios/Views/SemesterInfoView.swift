//
//  EditCreateSemesterView.swift
//  CollegeCGPAios
//
//  Created by dremobaba on 2023/1/27.
//

import SwiftUI

struct SemesterViewState {
    var semesterName: String = ""
    var courses: [Course] = []
    var currentYearName: String = ""
    var totalCreditHours: Float = 0.0
    var bestCourse: String = ""
}
struct SemesterInfoView: View {
    private var semester: Semester? = nil
    @Environment(\.dismiss) private var dismiss
    @State private var state: SemesterViewState = SemesterViewState()
    @EnvironmentObject private var mainViewModel: MainViewModel
    
    init(semester: Semester? = nil) {
        self.semester = semester
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerView.padding(.horizontal)
            Divider()
                .padding(.vertical, 8)
                .padding(.horizontal)
            scrollView
                .padding(.horizontal)
        }
        .padding(.top)
        .onAppear {
            if let semester = semester {
                state.semesterName = semester.semesterName
                state.courses = semester.courses
                state.totalCreditHours = semester.totalCreditHours
                if let bestCourse = semester.bestCourse {
                    state.bestCourse = bestCourse.courseName
                }
            }
            if let currentYear = mainViewModel.currentYear {
                state.currentYearName = currentYear.yearName
            }
        }
    }
    
    private var scrollView: some View {
        ScrollView(showsIndicators: false) {
            extraDataInfo
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 8)
            Divider()
                .padding(.vertical, 8)
            Text("All Courses")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.primaryLarge)
                .padding(.bottom)
           courseListView
               
        }
    }
    
    
    private var courseListView: some View {
        ForEach(Array(state.courses.enumerated()), id: \.element) { index, course in
            CourseView(course: course)
            let lastIndex = state.courses.count - 1
            Divider().opacity(index == lastIndex ? 0 : 1)
        }
    }

    
    
    
    private var extraDataInfo: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Total courses for this semester: ")
                    .font(.secondaryMedium)
                    .foregroundColor(Color(uiColor: .secondaryLabel))
                Text("\(state.courses.count)")
                    .font(.primaryBold)
            }
            HStack {
                Text("Total credit hours for this semester :")
                    .font(.secondaryMedium)
                    .foregroundColor(Color(uiColor: .secondaryLabel))
                Text(state.totalCreditHours.twoDecimalStr)
                    .font(.primaryBold)
            }
            HStack {
                Text("You did better in this course 🥳 :")
                    .font(.secondaryMedium)
                    .foregroundColor(Color(uiColor: .secondaryLabel))
                Text(state.bestCourse)
                    .font(.primaryBold)
                    .frame(maxWidth: 120, maxHeight: 120)
                    .lineLimit(2)
            }
        }
    }
    
    private var headerView: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .lastTextBaseline) {
                Text(state.currentYearName.capitalized)
                    .font(.primaryLarge)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                Spacer()
                if !state.currentYearName.isEmpty {
                    CustomIconBackground(systemName: "pencil.line") {
                        
                    }
                }
                CustomIconBackground(systemName: "xmark") {
                    dismiss()
                }
            }
            Text(state.semesterName.capitalized)
                .font(.secondaryMedium)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
        }
    }
}

struct SemesterInfoView_Previews: PreviewProvider {
    private static var vm: MainViewModel = {
        let vm = MainViewModel()
        return vm
    }()
    static var previews: some View {
        SemesterInfoView(semester: Year.years[0].semesters[0])
            .environmentObject(vm)
    }
}
