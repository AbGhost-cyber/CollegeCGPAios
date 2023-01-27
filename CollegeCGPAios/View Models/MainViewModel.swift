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
    
    @Published var academicYears: [Year] = []
    @Published var selectedBarValue: String = ""
    
    let repo: MainRepo
    
    @Published var currentTab: String = "" {
        didSet {
            mapChartDataAndSetOption()
        }
    }
    
    @Published var currentChartData: [ChartDataPoint] = []
    @Published var currentOption: Options = Options(
        type: "Year", xLabel: "Academic Year", yLabel: "CGPA")
    
    init(repo: MainRepo = MainRepoImpl()) {
        self.repo = repo
    }
    
    
    private func setOptionXYLabel(xLabel: String, yLabel: String) {
        self.currentOption.xLabel = xLabel
        self.currentOption.yLabel = yLabel
    }
    
    func mapChartDataAndSetOption() {
        // guard !academicYears.isEmpty else { return }
        
        self.currentOption.type = currentTab
        self.selectedBarValue = ""
        
        switch currentTab {
        case "Year":
            let yearlyData = Year.years.map { year in
                ChartDataPoint(
                    title: year.yearName,
                    value: year.cgpa,
                    extraName: year.yearName,
                    id: year.id)
            }
            self.currentChartData = yearlyData
            setOptionXYLabel(xLabel: "Year (Academic)", yLabel: "CGPA")
        case "Semester":
            var datapoints = [ChartDataPoint]()
            var allSemesters = [Semester]()
            Year.years.forEach { year in
                year.semesters.forEach { semester in
                    allSemesters.append(semester)
                }
            }
            for i in allSemesters.indices {
                let semester = allSemesters[i]
                let datapoint = ChartDataPoint(
                    title: (i+1).toCustomStr,
                    value: semester.gpa,
                    extraName: semester.semesterName,
                    id: semester.id)
                datapoints.append(datapoint)
            }
            
            self.currentChartData = datapoints
            setOptionXYLabel(xLabel: "All Semesters", yLabel: "GPA")
        case "Course":
            var datapoints = [ChartDataPoint]()
            var allCourses = [Course]()
            Year.years.forEach { year in
                year.semesters.forEach { semester in
                    allCourses.append(contentsOf: semester.courses)
                }
            }
            for i in allCourses.indices {
                let course = allCourses[i]
                let datapoint = ChartDataPoint(
                    title: (i+1).toCustomStr,
                    value: course.grade.rawValue,
                    extraName: course.courseName,
                    id: course.id)
                datapoints.append(datapoint)
            }
            self.currentChartData = datapoints
            setOptionXYLabel(xLabel: "All Courses", yLabel: "Grade")
            //TODO: add course filter
        default:
            fatalError("\(currentTab) is invalid")
        }
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
        Task { [weak self] in
            guard let self  = self else { return }
            do {
                let data = try await repo.loadYear()
                self.academicYears = data
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
