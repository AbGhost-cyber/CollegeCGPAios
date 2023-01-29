//
//  Extensions.swift
//  CollegeCGPAios
//
//  Created by dremobaba on 2023/1/26.
//

import Foundation
import SwiftUI

extension Array where Element == Float  {
    func sum() ->Float {
        return self.reduce(0, {$0 + $1})
    }
}

extension Semester {
    var totalCreditHours: Float {
        self.courses.map { course in
            course.creditHours
        }.sum()
    }
    var bestCourse: Course? {
        self.courses.max(by: {$0.grade.rawValue < $1.grade.rawValue})
    }
}

extension Color {
    static var random: Color {
        let colors = [blue, pink, pink, accentColor, orange, mint, teal, indigo, red, green]
        return colors.randomElement()!
    }
}

extension Int {
    var toCustomStr: String {
        switch self {
        case 1, 21, 31: return "\(self)st"
        case 2, 22, 32: return "\(self)nd"
        case 3, 23, 33: return "\(self)rd"
        case 4..<20: return "\(self)th"
        default: return "none"
        }
    }
}

extension Float {
    var twoDecimalStr: String {
        return String(format: "%.2f", self)
    }
    var oneDecimalStr: String {
        return String(format: "%.1f", self)
    }
}

extension Font {
   static var headerTitle: Font {
        boldFont(21)
    }
    static var tab: Font {
        regularFont(21)
    }
    static var chartAnnotation: Font {
        regularFont(14)
    }
    static var primaryLarge: Font {
        boldFont(24)
    }
    static var gradePoint: Font {
        regularFont(34)
    }
    static var secondaryMedium: Font {
        regularFont(18)
    }
    static var primaryBold: Font {
        boldFont(18)
    }
    static var secondaryText: Font {
        regularFont(16)
    }
    static var secondaryBold: Font {
        boldFont(16)
    }
    static var listHeaderText: Font {
        regularFont(14)
    }
    static var emptyChart: Font {
       regularFont(18)
    }
    
    private static func regularFont(_ size: CGFloat) -> Font {
        return .custom("ProximaNova-Regular", size: size)
    }
    private static func boldFont(_ size: CGFloat) -> Font {
        return .custom("ProximaNova-Bold", size: size)
    }
}

