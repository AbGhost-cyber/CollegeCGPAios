//
//  DummyView.swift
//  CollegeCGPAios
//
//  Created by dremobaba on 2023/2/1.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject private var viewmodel: MainViewModel
    @State private var filteredList: [Semester] = []
    @State private var activeSheet: SheetAction?
    
    
    var body: some View {
        NavigationStack {
            List(viewmodel.query.isEmpty ? viewmodel.allSemesters : filteredList) { semester in
                SemesterRowItem(semester: semester) {
                    activeSheet = .viewCourse(id: semester.id)
                }
            }
        }
        .searchable(text: $viewmodel.query)
        .onChange(of: viewmodel.query) { newValue in
            filteredList = viewmodel.allSemesters.filter({ semester in
                semester.semesterName.contains(newValue)
                || semester.courses.contains(where: {$0.courseName.contains(newValue)})
            })
        }
        .sheet(item: $activeSheet) { sheet in
            if case let .viewCourse(id) = sheet {
                SemesterInfoView(semesterId: id)
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    private static var vm: MainViewModel = {
        let vm = MainViewModel()
        return vm
    }()
    static var previews: some View {
        SearchView()
            .environmentObject(vm)
    }
}
extension SearchView {
    enum SheetAction: Identifiable {
        case viewCourse(id: String)
        
        var id: Int {
            return 0
        }
    }
}
