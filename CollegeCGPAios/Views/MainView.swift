//
//  ContentView.swift
//  CollegeCGPAios
//
//  Created by dremobaba on 2023/1/26.
//

import SwiftUI

enum SheetAction: Identifiable {
    case viewCourses(semesterId: String)
    case addSemester(yearId: String)
    
    var id: Int {
        switch self {
        case .viewCourses(_):
            return 1
        case .addSemester(_):
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
        NavigationView {
            VStack {
                    HeaderView(title: "Academic Tracker") { which in
                        if which == "Add" {
                            showAlert = true
                        }else {
                            //TODO: enable search
                        }
                    }
                    ScrollView(showsIndicators: false) {
                        //MARK: Picker
                        SegmentedPicker(selectedTab: $mainViewModel.currentTab, data: tabData)
                            .padding(.top)
                        //MARK: Chart view
                        MyChartView(data: mainViewModel.currentChartData, options: $mainViewModel.currentOption, selectedChartMark: $mainViewModel.selectedChartMark)
                            .frame(minHeight: 250)
                            .padding([.top, .leading, .trailing])
                            .animation(.easeInOut, value: mainViewModel.currentTab)
                        
                        //MARK: selected bar value
                        if !mainViewModel.selectedChartMark.name.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Highlighted \(mainViewModel.currentTab): ")
                                        .foregroundColor(Color(uiColor: .secondaryLabel))
                                        .font(.secondaryText)
                                        .lineLimit(1)
                                    Text(mainViewModel.selectedChartMark.name)
                                        .font(.secondaryBold)
                                }
                                HStack {
                                    Text("\(mainViewModel.currentOption.yLabel): ")
                                        .foregroundColor(Color(uiColor: .secondaryLabel))
                                        .font(.secondaryText)
                                        .lineLimit(1)
                                    if mainViewModel.currentOption.type == "Course" {
                                        Text(mainViewModel.selectedChartMark.value.convertToGradePoints)
                                            .font(.secondaryBold)
                                    }else {
                                        Text(mainViewModel.selectedChartMark.value.twoDecimalStr)
                                            .font(.secondaryBold)
                                    }
                                    
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom)
                        }
                        HStack {
                            Text("Recent Semesters")
                                .font(.primaryBold)
                            Spacer()
                            NavigateAbleIcon {
                                YearsListView()
                                    .navigationTitle("Semesters")
                            } label: {
                                Text("View All")
                                    .font(.primaryBold)
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                            }
                        }.padding(.bottom)
                        
                        //MARK: semester list & year section
                        ForEach(mainViewModel.allYears.indices.prefix(2), id: \.self) { mIndex in
                            let year = mainViewModel.allYears[mIndex]
                            Section {
                                VStack {
                                    ForEach(year.semesters.indices.prefix(2), id: \.self) { index in
                                        let semester = year.semesters[index]
                                        SemesterRowItem(semester: semester) { semester in
                                            activeSheet = .viewCourses(semesterId: semester.id)
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
                                HStack {
                                    Text(header)
                                        .font(.listHeaderText)
                                        .foregroundColor(Color(uiColor: .secondaryLabel))
                                        .padding(.leading)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text("add new semester")
                                        .font(.listHeaderText)
                                        .foregroundColor(.accentColor)
                                        .onTapGesture {
                                            activeSheet = .addSemester(yearId: year.id)
                                        }
                                }
                            }
                        }
                    }.overlay {
                        if mainViewModel.allYears.isEmpty {
                            Text("No Year added yet")
                                .offset(y: 120)
                                .font(.emptyChart)
                                .foregroundColor(Color(uiColor: .secondaryLabel))
                        }
                    }
                    .sheet(item: $activeSheet) { sheet in
                        switch sheet {
                        case .viewCourses(let semesterId): SemesterInfoView(semesterId: semesterId)
                                .presentationDetents([.height(560), .large])
                                .environmentObject(mainViewModel)
                        case .addSemester(let yearId):
                            EditCreateSemesterView(yearId: yearId)
                        }
                    }
                    .alert("Create Year", isPresented: $showAlert) {
                        TextField("what academic year?", text: $yearName)
                            .font(.primaryBold)
                        
                        Button("Proceed", action: {
                            guard !self.yearName.isEmpty else {
                                return
                            }
                            let year = Year(id: UUID().uuidString, yearName: self.yearName)
                            mainViewModel.saveYear(year)
                            activeSheet = .addSemester(yearId: year.id)
                            self.yearName = ""
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
