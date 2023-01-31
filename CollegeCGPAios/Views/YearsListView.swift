//
//  YearsListView.swift
//  CollegeCGPAios
//
//  Created by dremobaba on 2023/1/30.
//

import SwiftUI

struct YearsListView: View {
    @EnvironmentObject private var viewmodel: MainViewModel
    @State private var activeSheet: SheetAction?
    
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewmodel.allYears){ year in
                        Section {
                            ForEach(year.semesters) {semester in
                                SemesterRowItem(semester: semester) { semester in
                                    activeSheet = .viewCourses(semesterId: semester.id)
                                }
                            }
                        } header: {
                            let header = "\(year.yearName.uppercased()), CGPA: \(year.cgpa.twoDecimalStr)"
                            Text(header)
                                .font(.listHeaderText)
                        }
                        .listSectionSeparator(.hidden)
                    }
                }
            }
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                case .viewCourses(let semesterId): SemesterInfoView(semesterId: semesterId)
                        .presentationDetents([.height(560), .large])
                }
            }
            .overlay {
                if viewmodel.allYears.isEmpty {
                    Text("No semester added yet")
                        .font(.emptyChart)
                        .foregroundColor(Color(uiColor: .secondaryLabel))
                }
            }
            .navigationViewStyle(.stack)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct YearsListView_Previews: PreviewProvider {
    private static var vm: MainViewModel = {
        let vm = MainViewModel()
        return vm
    }()
    
    static var previews: some View {
        YearsListView()
            .environmentObject(vm)
    }
}

extension YearsListView {
    enum SheetAction: Identifiable {
        case viewCourses(semesterId: String)
        var id: Int {
            switch self {
            case .viewCourses(_):
                return 0
            }
        }
    }
}
