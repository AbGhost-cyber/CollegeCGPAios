//
//  SearchViewModel.swift
//  CollegeCGPAios
//
//  Created by dremobaba on 2023/2/1.
//

import Foundation

class SearchViewModel: ObservableObject {
    
    @Published var filteredList: [Semester] = []
    
    private var initialList: [Semester] = []
    
    @Published var query: String = "" {
        didSet {
            if query.isEmpty {
                filteredList = initialList
            }else {
                let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                filteredList = initialList.filter { semester in
                    semester.semesterName.lowercased().contains(trimmedQuery)
                    || semester.courses.contains(where: {$0.courseName.lowercased().contains(trimmedQuery)})
                }
            }
        }
    }
    
    func setInitialList(list: [Semester]) {
        self.initialList = list
    }
    
    
}
