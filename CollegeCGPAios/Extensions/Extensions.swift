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

extension Int {
    var toCustomStr: String {
        switch self {
        case 1: return "1st"
        case 2: return "2nd"
        case 3: return "3rd"
        case 4..<20: return "\(self)th"
        default: return "none"
        }
    }
}

extension Float {
    var twoDecimalStr: String {
        return String(format: "%.2f", self)
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
//    static var primaryText: Font {
//        boldFont(18)
//    }
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

