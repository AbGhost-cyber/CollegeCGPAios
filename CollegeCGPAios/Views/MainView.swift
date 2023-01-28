//
//  ContentView.swift
//  CollegeCGPAios
//
//  Created by dremobaba on 2023/1/26.
//

import SwiftUI

enum SheetAction: Identifiable {
    case add
    case viewCourses(Semester)
    
    var id: Int {
        switch self {
        case .add:
            return 0
        case .viewCourses(_):
            return 1
        }
    }
}
struct MainView: View {
    let tabData = ["Year", "Semester", "Course"]
    @State private var activeSheet: SheetAction?
    
    @EnvironmentObject private var mainViewModel: MainViewModel
    
    
    var body: some View {
        VStack {
            HeaderView(title: "Academic Tracker") { which in
                if which == "Add" {
                    activeSheet = .add
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
                ForEach(Year.years) { year in
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
                case .add: SemesterInfoView()
                        .environmentObject(mainViewModel)
                case .viewCourses(let semester): SemesterInfoView(semester: semester)
                        .presentationDetents([.height(560)])
                        .environmentObject(mainViewModel)
                }
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
