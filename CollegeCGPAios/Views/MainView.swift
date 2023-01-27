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
    @State private var selectedTab = ""
    let tabData = ["Year", "Semester", "Course"]
    @State var chartOptions = Options(
        type: "Year", xLabel: "Academic Year", yLabel: "CGPA")
    @State private var activeSheet: SheetAction?
    
    @EnvironmentObject private var mainViewModel: MainViewModel
    
    
    var body: some View {
        VStack {
            HeaderView(title: "Academic Tracker") { which in
                if which == "Add" {
                    activeSheet = .add
                }else {
                    //TODO: enable search
                }
            }
            ScrollView(showsIndicators: false) {
                SegmentedPicker(selectedTab: $selectedTab, data: tabData)
                    .padding(.top)
                MyChartView(data: [], options: $chartOptions)
                    .frame(minHeight: 250)
                    .padding()
                    .animation(.easeInOut, value: selectedTab)
                HStack {
                    Text("Recent")
                        .font(.primaryText)
                    Spacer()
                    Button {
                        
                    } label: {
                        Text("View All")
                            .font(.primaryText)
                        Image(systemName: "chevron.right")
                            .font(.caption)
                    }
                }.padding(.bottom)
              
                //MARK: semester list & year section
                ForEach(Year.years) { year in
                    Section {
                        VStack {
                            ForEach(Array(year.semesters.enumerated()), id: \.element) { index, semester in
                                SemesterRowItem(semester: semester) { semester in
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
                        let headerText = "\(year.yearName.uppercased()), CGPA: \(year.cgpa.twoDecimalStr)"
                        Text(headerText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.listHeaderText)
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                            .padding(.leading)
                    }
                }
            }
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                case .add: EditCreateSemesterView()
                case .viewCourses(let semester): EditCreateSemesterView(semester: semester)
                }
            }
        }
        .onAppear {
            selectedTab = tabData[0]
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
