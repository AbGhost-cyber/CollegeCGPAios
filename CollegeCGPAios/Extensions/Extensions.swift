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

extension Float {
    var twoDecimalStr: String {
        return String(format: "%.2f", self)
    }
}

extension Font {
   static var headerTitle: Font {
        .custom("CircularStd-Bold", size: 21)
    }
    static var tab: Font {
        mediumFontSize(21)
    }
    static var chartAnnotation: Font {
        mediumFontSize(12)
            .weight(.light)
    }
    static var recentText: Font {
        mediumFontSize(18)
    }
    static var emptyChart: Font {
        recentText
            .weight(.light)
    }
    private static func mediumFontSize(_ size: CGFloat) -> Font {
        return .custom("CircularStd-Medium", size: size)
    }
}

