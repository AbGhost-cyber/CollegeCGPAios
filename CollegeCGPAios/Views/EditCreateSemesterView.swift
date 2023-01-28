//
//  EditCreateSemesterView.swift
//  CollegeCGPAios
//
//  Created by dremobaba on 2023/1/28.
//

import SwiftUI
struct YearViewState {
    var year: Year = Year(id: "", yearName: "")
}
struct EditCreateSemesterView: View {
    @EnvironmentObject private var viewmodel: MainViewModel
    
    @State private var state: YearViewState = YearViewState()
    @Environment(\.dismiss) private var dismiss
    @State private var showAddCourse = false
    
    
    var body: some View {
            VStack {
                HStack {
                    CustomIconBackground(systemName: "xmark") {
                        dismiss()
                    }
                    Spacer()
                    Text("Create Semester")
                        .font(.primaryLarge)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    Spacer()
                    CustomIconBackground(systemName: "checkmark") {
                        dismiss()
                    }
                }
                Section {
                    TextField("Input semester name", text: $state.year.yearName)
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
                }.padding(.top)
                
                ScrollView {

                }.overlay(alignment: .bottomTrailing) {
                    FloatingActionButton() {
                        showAddCourse = true
                    }
                }
            }
            .sheet(isPresented: $showAddCourse) {
                CreateCourseView()
            }
            .padding()
            .onAppear {
                if let year = viewmodel.currentYear {
                    state.year = year
                }
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
