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
    
    func notValid() -> Bool {
        return name.isEmpty
    }
}
struct CreateCourseView: View {
    @State private var state: CourseState = CourseState()
    @EnvironmentObject private var viewmodel: MainViewModel
    let hoursList: [Float] = Array(stride(from: 1.0, to: 6.5, by: 0.5))
    @Environment(\.dismiss) private var dismiss
    
    var course: Course? = nil
    
    init(course: Course? = nil) {
        self.course = course
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
                        dismiss()
                    }.font(.primaryBold)
                }.disabled(state.notValid())
            }
        }
        .background(Color(uiColor: .systemBackground))
        .navigationTitle("Create Course")
        .onAppear {
            if let course = course {
                state.name = course.courseName
                state.creditHours = course.creditHours
                state.grade = course.grade
                state.id = course.id
            }
            if let semester = viewmodel.currentSemester {
                print(semester.semesterName)
            }else {
                print("null")
            }
        }
    }
    
    func saveCourse() {
        if var semester = viewmodel.currentSemester {
            if state.id.isEmpty {
                //insert new
                state.id = UUID().uuidString
                let course = Course(courseName: state.name, creditHours: state.creditHours, grade: state.grade, semesterId: semester.id, id: state.id)
                semester.courses.append(course)
            } else {
                //update
                if let courseIndex = semester.courses.firstIndex(where: {$0.id == state.id}) {
                    let course = Course(courseName: state.name, creditHours: state.creditHours, grade: state.grade, semesterId: semester.id, id: state.id)
                    semester.courses[courseIndex] = course
                }
            }
            viewmodel.upsertSemester()
            dismiss()
        }
    }
}

struct CreateCourseView_Previews: PreviewProvider {
    private static var vm: MainViewModel = {
        let vm = MainViewModel()
        return vm
    }()
    static var previews: some View {
        CreateCourseView()
            .environmentObject(vm)
    }
}
