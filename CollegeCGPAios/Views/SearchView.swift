//
//  DummyView.swift
//  CollegeCGPAios
//
//  Created by dremobaba on 2023/2/1.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject private var viewmodel: MainViewModel
    @State private var activeSheet: SheetAction?
    @ObservedObject private var searchViewmodel = SearchViewModel()
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(dataToDisplay()) { semester in
                        SemesterRowItem(semester: semester) {
                            activeSheet = .viewCourse(id: semester.id)
                        }
                    }.onDelete { indexSet in
                        viewmodel.deleteSemester(offsets: indexSet)
                    }
                }
                .overlay {
                    if dataToDisplay().isEmpty {
                        EmptyStateView(text: "no data available")
                    }
                    
                }
            }
            .searchable(text: $searchViewmodel.query)
            .sheet(item: $activeSheet) { sheet in
                if case let .viewCourse(id) = sheet {
                    SemesterInfoView(semesterId: id)
                }
            }
            .onAppear {
                searchViewmodel.setInitialList(list: viewmodel.allSemesters)
            }
            .toolbar {
                EditButton()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel"){
                        dismiss()
                    }
                }
            }
        }
    }
    
    func dataToDisplay() -> [Semester] {
        if searchViewmodel.query.isEmpty {
            return viewmodel.allSemesters
        } else {
            return searchViewmodel.filteredList
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
            switch self {
            case .viewCourse(_):
                return 0
            }
        }
    }
}
