//
//  MockStubs.swift
//  CollegeCGPAios
//
//  Created by dremobaba on 2023/1/27.
//

import Foundation

extension Year {
    static var years: [Year] {
        var years = [Year] ()
        var year1 = Year(id: UUID().uuidString, yearName: "First Year")
        var firstSem = Semester(semesterName: "First Year, first semester", yearId: year1.id, id: UUID().uuidString)
        firstSem.courses.append(
            Course(courseName: "Mathematics", creditHours: 3.4, grade: .Bplus,
                   color: "blue", semesterId: firstSem.id, id: UUID().uuidString)
        )
        firstSem.courses.append(Course(courseName: "Physics", creditHours: 2.5, grade: .B,
                                        color: "blue", semesterId: firstSem.id, id: UUID().uuidString))
        var secondSem = Semester(semesterName: "First Year, second semester", yearId: year1.id, id: UUID().uuidString)
        secondSem.courses.append(
            Course(courseName: "Biology", creditHours: 4.0, grade: .Aplus,
                   color: "blue", semesterId: secondSem.id, id: UUID().uuidString)
        )
        year1.semesters.append(firstSem)
        year1.semesters.append(secondSem)
        
        var year2 = Year(id: UUID().uuidString, yearName: "Second Year")
        var secSemester = Semester(semesterName: "Second year, First semester", yearId: year2.id, id: UUID().uuidString)
        secSemester.courses.append(
            Course(courseName: "Computer Science", creditHours: 3.4, grade: .Bplus,
                   color: "blue", semesterId: secSemester.id, id: UUID().uuidString)
        )
        secSemester.courses.append(Course(courseName: "Data mining", creditHours: 2.5, grade: .D,
                                        color: "blue", semesterId: secSemester.id, id: UUID().uuidString))
        year2.semesters.append(secSemester)
         
        years.append(year1)
        years.append(year2)
        return years
    }
}
