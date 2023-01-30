//
//  EditCreateSemesterView.swift
//  CollegeCGPAios
//
//  Created by dremobaba on 2023/1/28.
//

import SwiftUI
import SwiftUITooltip

struct YearViewState {
    var showAddCourse = false
    var showToolTip = true
    var showCancelDialog = false
    var currentSemester = Semester(semesterName: "", yearId: "", id: "")
    var semesterName: String = ""
    var isNew = false
    var courses: [Course] = []
    var semesterId: String = ""
}
struct EditCreateSemesterView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viewmodel: MainViewModel
    var tooltipConfig = DefaultTooltipConfig()
    @State private var state: YearViewState = YearViewState()
    
    private var yearId: String
    var semesterId: String? = nil
    @State private var semesterIdCopy: String?
    
    
    
    init(yearId: String, semesterId: String? = nil) {
        self.tooltipConfig.enableAnimation = true
        self.tooltipConfig.animationTime = 1
        self.yearId = yearId
        self.semesterId = semesterId
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    //MARK: cancel button
                    CustomIconBackground(systemName: "xmark") {
                        if state.semesterName.isEmpty {
                            state.showCancelDialog = true
                        } else{
                            dismiss()
                        }
                    }
                    Spacer()
                    Text(state.isNew ? "Create Semester" : "Edit Semester")
                        .font(.primaryLarge)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    Spacer()
                    //MARK: create semester button
                    CustomIconBackground(systemName: "checkmark") {
                        upsertSemester()
                        dismiss()
                    }
                    .disabled(state.semesterName.isEmpty)
                }
                .padding([.horizontal, .top], 10)
                
                Section {
                    TextField("Input semester name", text: $state.semesterName, onCommit: {
                        print("committed: \(state.semesterName)")
                    })
                        .onChange(of: state.semesterName, perform: { newValue in
                            if !newValue.isEmpty {
                                runToolTipVisibility()
                            }
                        })
                        
                        .font(.secondaryMedium)
                        .frame(height: 50)
                        .padding(.horizontal)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.primary)
                        }
                } footer: {
                    Text("endeavor to keep the semester name unique else the data will be overidden in chart.")
                        .font(.chartAnnotation)
                }
                .padding(.top)
                .padding(.horizontal, 10)
                ScrollView(showsIndicators: false) {
                    Text("All Courses")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.primaryLarge)
                        .padding(.bottom, 10)
                    //MARK: course list
                    ForEach(state.courses) { course in
                        CourseView(course: course)
                            .padding(.vertical, 10)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .overlay(alignment: .bottomTrailing) {
                    if !state.semesterName.isEmpty {
                        NavigateAbleIcon {
                            CreateCourseView(semesterId: state.semesterId)
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .symbolRenderingMode(.palette)
                                .font(.system(size: 50))
                                .foregroundStyle(.white, .purple)
                                .shadow(color: .gray, radius: 0.2, x: 1, y: 1)
                                .padding()
                        }
                        .simultaneousGesture(TapGesture().onEnded({ _ in
                            upsertSemester()
                            semesterIdCopy = state.semesterId
                        }))
                        .tooltip(state.showToolTip, side: .left) {
                            Text("Click here to add a course")
                                .font(.secondaryMedium)
                        }
                    }
                    
                }
                .overlay {
                    if state.courses.isEmpty {
                        Text("No course added yet")
                            .font(.emptyChart)
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                    }
                }
            }
            .confirmationDialog("Cancel Operation?", isPresented: $state.showCancelDialog) {
                Button("Proceed", role: .destructive) {
                    //TODO: delete year, it will look ugly without semesters
                    dismiss()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Going back without saving will ignore changes")
                    .font(.secondaryMedium)
            }
            .onAppear {
                state.isNew = semesterId == nil
                if viewmodel.getYearById(yearId) != nil {
                    // semester exist, this is an edit op
                    let copyOfSemesterId = semesterId ?? semesterIdCopy
                    if let id = copyOfSemesterId, let semester = viewmodel.getSemesterById(id) {
                        state.courses = semester.courses
                        state.semesterName = semester.semesterName
                        state.currentSemester = semester
                        state.semesterId = semester.id
                    }else {
                        state.semesterId = UUID().uuidString
                    }
                }
            }
        }
    }
    
    func upsertSemester() {
        let id = state.semesterId
        var semester = Semester(semesterName: state.semesterName, yearId: yearId, id: id)
        semester.courses = state.courses
        viewmodel.upsertSemester(semester)
    }
    
    func runToolTipVisibility() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            state.showToolTip = false
        }
    }
    
    struct EditCreateSemesterView_Previews: PreviewProvider {
        private static var vm: MainViewModel = {
            let vm = MainViewModel()
            return vm
        }()
        
        static var previews: some View {
            Group {
                EditCreateSemesterView(yearId: Year.years[0].id)
                    .preferredColorScheme(.dark)
                    .previewDisplayName("Dark theme")
                    .environmentObject(vm)
                
                EditCreateSemesterView(yearId: Year.years[0].id)
                    .preferredColorScheme(.light)
                    .previewDisplayName("White theme")
                    .environmentObject(vm)
            }
        }
    }
}
