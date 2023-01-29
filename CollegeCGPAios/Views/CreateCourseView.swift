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
    
    func notValid() -> Bool {
        return name.isEmpty
    }
}
struct CreateCourseView: View {
  @State private var state: CourseState = CourseState()
    let hoursList: [Float] = Array(stride(from: 1.0, to: 6.5, by: 0.5))
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
                       
                    }.font(.primaryBold)
                }.disabled(state.notValid())
            }
        }
        .background(Color(uiColor: .systemBackground))
        .navigationTitle("Create Course")
    }
}

struct CreateCourseView_Previews: PreviewProvider {
    static var previews: some View {
        CreateCourseView()
    }
}
