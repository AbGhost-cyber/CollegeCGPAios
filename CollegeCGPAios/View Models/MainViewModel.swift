//
//  MainViewModel.swift
//  CollegeCGPAios
//
//  Created by dremobaba on 2023/1/26.
//

import Foundation

@MainActor
class MainViewModel: ObservableObject {
    
    @Published var allSemesters: [Semester] = []
    @Published var allCourses: [Course] = []
    
    @Published var currentTab: String = "" {
        didSet {
            mapChartDataAndSetOption()
        }
    }
    
    @Published var allYears: [Year] = [] {
        didSet {
            mapChartDataAndSetOption()
            saveProgress()
        }
    }
    
    @Published var selectedChartMark: ChartMarkData = ChartMarkData(name: "", value: 0.0)
    
    let repo: MainRepo
    
    @Published var currentChartData: [ChartDataPoint] = []
    @Published var currentOption: Options = Options(type: "Year", xLabel: "Academic Year", yLabel: "CGPA")
    
    init(repo: MainRepo = MainRepoImpl()) {
        self.repo = repo
        load()
    }
    
    func getYearById(_ id: String) -> Year? {
        return allYears.first(where: {$0.id == id})
    }
    
    func getSemesterById(_ id: String) -> Semester? {
        return allSemesters.first(where: {$0.id == id})
    }
    
    func getCourseById(_ id: String) -> Course? {
        return allCourses.first(where: {$0.id == id})
    }
    
    func saveYear(_ year: Year) {
        if getYearById(year.id) != nil {
            // year exist
            let index = allYears.firstIndex(where: {$0.id == year.id})!
            allYears[index] = year
        } else {
            //new insert
            allYears.append(year)
        }
    }
    
    func upsertSemester(_ semester: Semester) {
        if getSemesterById(semester.id) != nil {
            // semester exist
            let index = allSemesters.firstIndex(where: {$0.id == semester.id})!
            allSemesters[index] = semester
        } else {
            //new insert
            allSemesters.append(semester)
        }
        //update year
        if var parent = getYearById(semester.yearId) {
            // year exist, so we find the exact semester else append new
            if let semesterIndex = parent.semesters.firstIndex(where: {$0.id == semester.id}) {
                parent.semesters[semesterIndex] = semester
            }else {
                parent.semesters.append(semester)
            }
            saveYear(parent)
        } else {
            // this shouldn't happen
        }
    }
    
    func upsertCourse(_ course: Course) {
        if getCourseById(course.id) != nil {
            // course exist
            let index = allCourses.firstIndex(where: {$0.id == course.id})!
            allCourses[index] = course
        }else {
            //new insert
            allCourses.append(course)
        }
        //update semester
        if var parent = getSemesterById(course.semesterId) {
            // semester exist, so we find the exact course else append new
            if let courseIndex = parent.courses.firstIndex(where: {$0.id == course.id}) {
                parent.courses[courseIndex] = course
            }else {
                parent.courses.append(course)
            }
            upsertSemester(parent)
        } else {
            // this shouldn't happen
        }
    }
    
    
    private func setOptionXYLabel(xLabel: String, yLabel: String) {
        self.currentOption.xLabel = xLabel
        self.currentOption.yLabel = yLabel
    }
    
    func mapChartDataAndSetOption() {
        // guard !academicYears.isEmpty else { return }
        
        self.currentOption.type = currentTab
        self.selectedChartMark = ChartMarkData(name: "", value: 0)
        
        switch currentTab {
        case "Year":
            let yearlyData = allYears.map { year in
                ChartDataPoint(
                    title: year.yearName,
                    value: year.cgpa,
                    extraName: year.yearName,
                    id: year.id)
            }
            self.currentChartData = yearlyData.filter({$0.value > 0.0})
            setOptionXYLabel(xLabel: "Year (Academic)", yLabel: "CGPA")
        case "Semester":
            var datapoints = [ChartDataPoint]()
            var allSemesters = [Semester]()
            allYears.forEach { year in
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
            
            self.currentChartData = datapoints.filter({$0.value > 0.0})
            setOptionXYLabel(xLabel: "All Semesters", yLabel: "GPA")
        case "Course":
            var datapoints = [ChartDataPoint]()
            var allCourses = [Course]()
            allYears.forEach { year in
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
            self.currentChartData = datapoints.filter({$0.value > 0.0})
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
                try await repo.saveYears(self.allYears)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func load() {
        Task { [weak self] in
            guard let self  = self else { return }
            do {
                let data = try await repo.loadYears()
                self.allYears = data
                data.forEach { year in
                    allSemesters.append(contentsOf: year.semesters)
                    year.semesters.forEach { semester in
                        allCourses.append(contentsOf: semester.courses)
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
