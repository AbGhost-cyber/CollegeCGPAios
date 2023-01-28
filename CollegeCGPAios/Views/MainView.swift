//
//  ContentView.swift
//  CollegeCGPAios
//
//  Created by dremobaba on 2023/1/26.
//

import SwiftUI

enum SheetAction: Identifiable {
    case viewCourses(Semester)
    case addSemester
    
    var id: Int {
        switch self {
        case .viewCourses(_):
            return 1
        case .addSemester:
            return 2
        }
    }
}
struct MainView: View {
    let tabData = ["Year", "Semester", "Course"]
    @State private var activeSheet: SheetAction?
    @State private var showAlert: Bool = false
    @State private var yearName: String = ""
    
    @EnvironmentObject private var mainViewModel: MainViewModel
    
    
    var body: some View {
        VStack {
            HeaderView(title: "Academic Tracker") { which in
                if which == "Add" {
                    showAlert = true
                    mainViewModel.currentYear = nil
                }else {
                    //TODO: enable search
                }
            }
            ScrollView(showsIndicators: false) {
                SegmentedPicker(selectedTab: $mainViewModel.currentTab, data: tabData)
                    .padding(.top)
                MyChartView(data: mainViewModel.currentChartData, options: $mainViewModel.currentOption, selectedBarValue: $mainViewModel.selectedBarValue)
                    .frame(minHeight: 250)
                    .padding([.top, .leading, .trailing])
                    .animation(.easeInOut, value: mainViewModel.currentTab)
                if !mainViewModel.selectedBarValue.isEmpty {
                    HStack {
                        Text("Selected \(mainViewModel.currentTab): ")
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                            .font(.secondaryText)
                        Text(mainViewModel.selectedBarValue)
                            .font(.secondaryBold)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom)
                }
                HStack {
                    Text("Recent Semesters")
                        .font(.primaryBold)
                    Spacer()
                    Button {
                        
                    } label: {
                        Text("View All")
                            .font(.primaryBold)
                        Image(systemName: "chevron.right")
                            .font(.caption)
                    }
                }.padding(.bottom)
                
                //MARK: semester list & year section
                ForEach(Year.years.prefix(2)) { year in
                    Section {
                        VStack {
                            ForEach(Array(year.semesters.enumerated().prefix(2)), id: \.element) { index, semester in
                                SemesterRowItem(semester: semester) { semester in
                                    mainViewModel.currentYear = year
                                    activeSheet = .viewCourses(semester)
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                Divider()
                                    .opacity(index == 1 ? 0 : 1)
                            }
                        }
                        .background(RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3)))
                        .padding(.bottom, 10)
                    } header: {
                        let header = "\(year.yearName.uppercased()), CGPA: \(year.cgpa.twoDecimalStr)"
                        Text(header)
                            .font(.listHeaderText)
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                            .padding(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                case .viewCourses(let semester): SemesterInfoView(semester: semester)
                        .presentationDetents([.height(560), .large])
                        .environmentObject(mainViewModel)
                case .addSemester:
                    EditCreateSemesterView()
                }
            }
            .alert("Create Year", isPresented: $showAlert) {
                TextField("what academic year?", text: $yearName)
                    .font(.primaryBold)
                
                Button("Proceed", action: {
                    guard !self.yearName.isEmpty else {
                        return
                    }
                    mainViewModel.currentYear = Year(id: UUID().uuidString, yearName: self.yearName)
                   // mainViewModel.saveProgress()
                    activeSheet = .addSemester
                })
                Button("Cancel", role: .cancel, action: {})
            } message: {
                Text("endeavor to keep the year name unique else the data will be overidden in chart.")
                    .font(.chartAnnotation)
            }
            
        }
        .onAppear {
            mainViewModel.currentTab = tabData[0]
        }
        .padding()
    }
    
}

struct MainView_Previews: PreviewProvider {
    private static var vm: MainViewModel = {
        let vm = MainViewModel()
        return vm
    }()
    static var previews: some View {
        MainView()
            .environmentObject(vm)
    }
}
