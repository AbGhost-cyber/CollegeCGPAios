//
//  Semester.swift
//  CollegeCGPAios
//
//  Created by dremobaba on 2023/1/26.
//

import Foundation

struct Year: Codable, Identifiable {
    var semesters: [Semester] = []
    var id: String
    var yearName: String
    
    var cgpa: Float {
        let totalGPA = semesters.map { $0.gpa }.sum()
        let size = semesters.count
        return totalGPA / Float(size)
    }
}

struct Semester: Codable, Identifiable, Hashable, Equatable {
    static func == (lhs: Semester, rhs: Semester) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(id)
    }
    
    var courses: [Course] = []
    var semesterName: String
    var yearId: String
    var id: String
    
    var gpa: Float {
        let totalHours = courses.map { $0.creditHours }.sum()
        let totalPoints = courses.map { $0.qualityPoint }.sum()
        let gpa = totalPoints / totalHours
        if (gpa.isNaN) {
            return 0.00
        }
        return (gpa * 100.0).rounded() / 100.0
    }
    
    var threeCourseNames: String {
        var list = [String]()
        if courses.isEmpty {
            return "no course added yet"
        }
        courses.forEach { course in
            if list.count < 3 {
                list.append(course.courseName)
            }
        }
        return list.joined(separator: ", ")
    }
}

struct Course: Codable, Identifiable, Hashable {
    var courseName: String
    var creditHours: Float
    var grade: Grade
    var semesterId: String
    var id: String
    
    static func == (lhs: Course, rhs: Course) -> Bool {
        return lhs.id == rhs.id && lhs.semesterId == rhs.semesterId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(id)
    }
    
    var qualityPoint: Float {
        return creditHours * grade.rawValue
    }
}

enum Grade: Float, Codable, CaseIterable, Equatable {
    
    case Aplus = 4.0
    case Aminus = 3.7
    case Bplus = 3.3
    case B = 3.0
    case Bminus = 2.7
    case Cplus = 2.3
    case C = 2.0
    case Cminus = 1.7
    case Dplus = 1.3
    case D = 1.0
    case F = 0.0
    
    var id: Grade {
        self
    }
    var gradePoints: String {
        switch (self) {
        case .Aplus: return "A+"
        case .Aminus: return "A-"
        case .Bplus: return "B+"
        case .B : return "B"
        case .Bminus: return "B-"
        case .Cplus : return "C+"
        case .C: return "C"
        case .Cminus: return "C-"
        case .Dplus: return "D+"
        case .D: return "D"
        case .F: return "F"
        }
    }
    
}

