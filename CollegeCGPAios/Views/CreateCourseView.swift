//
//  CreateCourseView.swift
//  CollegeCGPAios
//
//  Created by dremobaba on 2023/1/28.
//

import SwiftUI
struct CourseState {
    var name: String = ""
    var grade: Grade = .Aplus
    var creditHours: Float = 1.0
    var id: String = ""
    var isNew = false
    
    func notValid() -> Bool {
        return name.isEmpty
    }
}
struct CreateCourseView: View {
    @State private var state: CourseState = CourseState()
    @EnvironmentObject private var viewmodel: MainViewModel
    let hoursList: [Float] = Array(stride(from: 1.0, to: 6.5, by: 0.5))
    @Environment(\.dismiss) private var dismiss
    let semesterId: String
    var courseId: String? = nil
    
    init (semesterId: String, courseId: String? = nil) {
        self.semesterId = semesterId
        self.courseId = courseId
    }
    
    var body: some View {
        VStack {
            Form {
                Section {
                    TextField("input course name", text: $state.name)
                        .font(.secondaryMedium)
                } footer: {
                    Text("for a better chart data please use a unique name or append numbers if courses are repeated in this semester.")
                        .font(.listHeaderText)
                }
                Picker("Select Course Grade", selection: $state.grade) {
                    ForEach(Grade.allCases, id: \.self) { grade in
                        Text(grade.gradePoints)
                            .font(.secondaryText)
                    }
                }.font(.primaryBold)
                Picker("Select Credit Hours", selection: $state.creditHours) {
                    ForEach(hoursList, id: \.self) { value in
                        Text(value.oneDecimalStr)
                    }
                }.font(.primaryBold)
                
                Section {
                    Button("Save") {
                      saveCourse()
                    }.font(.primaryBold)
                }.disabled(state.notValid())
            }
        }
        .background(Color(uiColor: .systemBackground))
        .navigationTitle(state.isNew ? "Create Course": "Edit Course")
        .onAppear {
            state.isNew = courseId == nil
            if viewmodel.getSemesterById(semesterId) != nil {
                // course exist, this is an edit op
                if let id = courseId, let course = viewmodel.getCourseById(id) {
                    state.name = course.courseName
                    state.creditHours = course.creditHours
                    state.grade = course.grade
                    state.id = course.id
                } else {
                    state.id = UUID().uuidString
                }
            }
        }
    }
    private func saveCourse() {
        let course = Course(courseName: state.name,
                            creditHours: state.creditHours,
                            grade: state.grade,
                            semesterId: semesterId, id: state.id)
        viewmodel.upsertCourse(course)
        dismiss()
    }
}

struct CreateCourseView_Previews: PreviewProvider {
    private static var vm: MainViewModel = {
        let vm = MainViewModel()
        return vm
    }()
    static var previews: some View {
        CreateCourseView(semesterId: Year.years[0].semesters[0].id)
            .environmentObject(vm)
    }
}
