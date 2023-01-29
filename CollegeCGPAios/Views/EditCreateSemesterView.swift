//
//  EditCreateSemesterView.swift
//  CollegeCGPAios
//
//  Created by dremobaba on 2023/1/28.
//

import SwiftUI
import SwiftUITooltip

struct YearViewState {
    var year: Year = Year(id: "", yearName: "")
    var showAddCourse = false
    var showToolTip = true
    var showCancelDialog = false
    var currentSemester = Semester(semesterName: "", yearId: "", id: "")
    var semesterName: String = ""
    var courses: [Course] = []
    var isNew = false
}
struct EditCreateSemesterView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viewmodel: MainViewModel
    
    var tooltipConfig = DefaultTooltipConfig()
    
    @State private var state: YearViewState = YearViewState()
   
    
    
    init() {
        self.tooltipConfig.enableAnimation = true
        self.tooltipConfig.animationTime = 1
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    //MARK: cancel button
                    CustomIconBackground(systemName: "xmark") {
                        state.showCancelDialog = true
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
                    }.disabled(state.semesterName.isEmpty)
                }.padding([.horizontal, .top], 10)
                Section {
                    TextField("Input semester name", text: $state.semesterName)
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
                ScrollView {
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
                    NavigateAbleIcon {
                        if !state.semesterName.isEmpty {
                            CreateCourseView()
                                .presentationDetents([.large])
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .symbolRenderingMode(.palette)
                            .font(.system(size: 50))
                            .foregroundStyle(.white, .purple)
                            //.foregroundColor(.purple)
                            .shadow(color: .gray, radius: 0.2, x: 1, y: 1)
                            .padding()
                    }
                    .tooltip(state.showToolTip, side: .left) {
                        Text("Click here to add a course")
                            .font(.secondaryMedium)
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
                    viewmodel.currentYear = nil
                    dismiss()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Going back without saving will ignore changes")
                    .font(.secondaryMedium)
            }
            .onAppear {
                if let year = viewmodel.currentYear {
                    state.year = year
                    state.currentSemester.yearId = year.id
                }
                if let semester = viewmodel.currentSemester {
                    state.currentSemester = semester
                    state.semesterName = semester.semesterName
                }
                state.isNew = viewmodel.currentSemester == nil
                runToolTipVisibility()
            }
        }
    }
    
    func upsertSemester(shouldClearCache: Bool = false) {
        var semester = state.currentSemester
        if semester.id.isEmpty {
            semester.id = UUID().uuidString
        }
        semester.semesterName = state.semesterName
        //update to viewmodel
        viewmodel.currentSemester = semester
        viewmodel.upsertSemester()
        if shouldClearCache {
            viewmodel.clearCache()
            dismiss()
        }
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
                EditCreateSemesterView()
                    .preferredColorScheme(.dark)
                    .previewDisplayName("Dark theme")
                    .environmentObject(vm)
                
                EditCreateSemesterView()
                    .preferredColorScheme(.light)
                    .previewDisplayName("White theme")
                    .environmentObject(vm)
            }
        }
    }
}
