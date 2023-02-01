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
    var semester: Semester = Semester(semesterName: "", yearId: "", id: "")
    var yearId: String = ""
    var semesterId: String = ""
    var isLoading = false
}
struct SemesterInfoView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var state: SemesterViewState = SemesterViewState()
    @EnvironmentObject private var mainViewModel: MainViewModel
    let semesterId: String
    
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                headerView.padding(.horizontal)
                Divider()
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                scrollView
                    .padding(.horizontal)
            }
            .padding(.top)
            .onAppear(perform: handleOnAppear)
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
            
        }.overlay {
            if state.courses.isEmpty && !state.isLoading {
                EmptyStateView(text: "No course added yet")
            }
            if state.isLoading {
                ProgressView()
            }
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
                NavigateAbleIcon {
                    EditCreateSemesterView(yearId: state.yearId, semesterId: state.semesterId)
                        .navigationBarBackButtonHidden()
                } label: {
                    drawImage("pencil.line")
                }
                drawImage("xmark").onTapGesture {
                    dismiss()
                }
            }
            Text(state.semesterName.capitalized)
                .font(.secondaryMedium)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
        }
    }
    
    private func drawImage(_ name: String) -> some View {
        Circle()
            .frame(width: 36)
            .foregroundColor(.gray.opacity(0.1))
            .overlay {
                Image(systemName: name)
                    .font(.system(size: 18).bold())
                    .foregroundColor(Color(uiColor: .secondaryLabel))
            }
    }
    
    private func handleOnAppear() {
        if let semester = mainViewModel.getSemesterById(semesterId) {
            state.semester = semester
            state.courses = []
            state.isLoading = true
            //the reason i delayed this was due to the fact that the state didn't wait for the data from our viewmodel
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                state.courses = semester.courses
                state.isLoading = false
            }
            state.totalCreditHours = semester.totalCreditHours
            state.semesterId = semester.id
            state.semesterName = semester.semesterName
            if let bestCourse = semester.bestCourse {
                state.bestCourse = bestCourse.courseName
            }
            if let currentYear = mainViewModel.getYearById(semester.yearId) {
                state.currentYearName = currentYear.yearName
                state.yearId = currentYear.id
            }
        }
    }
}

struct SemesterInfoView_Previews: PreviewProvider {
    private static var vm: MainViewModel = {
        let vm = MainViewModel()
        vm.upsertSemester(Year.years[0].semesters[0])
        return vm
    }()
    static var previews: some View {
        SemesterInfoView(semesterId: Year.years[0].semesters[0].id)
            .environmentObject(vm)
    }
}
