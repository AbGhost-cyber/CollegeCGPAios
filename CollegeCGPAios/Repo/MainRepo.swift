//
//  MainRepo.swift
//  CollegeCGPAios
//
//  Created by dremobaba on 2023/1/26.
//

import Foundation

protocol MainRepo {
    func saveYears(_ current: [Year]) async throws
    
    func loadYears() async throws -> [Year]
}

class MainRepoImpl: MainRepo {
   private var years: [Year]?
    
    private var fileName: String
    private var yearUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appending(component: "\(fileName).plist")
    }
    
    init(fileName: String = "college_cgpa") {
        self.fileName = fileName
    }
    
    
    func saveYears(_ current: [Year]) async throws {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .binary
        let data  = try encoder.encode(current)
        try data.write(to: yearUrl)
    }
    
    func loadYears() async throws -> [Year] {
        let data = try Data(contentsOf: yearUrl)
        let years = try PropertyListDecoder().decode([Year].self, from: data)
        self.years = years
        return years
    }
}
