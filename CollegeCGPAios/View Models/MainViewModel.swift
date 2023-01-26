//
//  MainViewModel.swift
//  CollegeCGPAios
//
//  Created by dremobaba on 2023/1/26.
//

import Foundation

@MainActor
class MainViewModel: ObservableObject {
    
    @Published var currentYear: Year?
    
    @Published var academicYears: [Year] = [] {
        didSet { saveProgress() }
    }
    
    let repo: MainRepo
    
    init(repo: MainRepo = MainRepoImpl()) {
        self.repo = repo
    }
    
    
    func saveProgress() {
        Task { [weak self] in
            guard let self  = self else { return }
            do {
             try await repo.saveYear(self.academicYears)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    func load() {
        
    }
}
