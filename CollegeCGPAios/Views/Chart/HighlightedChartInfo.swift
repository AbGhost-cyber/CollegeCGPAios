//
//  HighlightedChartInfo.swift
//  CollegeCGPAios
//
//  Created by dremobaba on 2023/2/1.
//

import SwiftUI

struct HighlightedChartInfo: View {
    let chartMark: ChartMarkData
    let currentTab: String
    let currentOption: Options
    
    var body: some View {
        if !chartMark.name.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Highlighted \(currentTab): ")
                        .foregroundColor(Color(uiColor: .secondaryLabel))
                        .font(.secondaryText)
                        .lineLimit(1)
                    Text(chartMark.name)
                        .font(.secondaryBold)
                }
                HStack {
                    Text("\(currentOption.yLabel): ")
                        .foregroundColor(Color(uiColor: .secondaryLabel))
                        .font(.secondaryText)
                        .lineLimit(1)
                    if currentOption.type == "Course" {
                        Text(chartMark.value.convertToGradePoints)
                            .font(.secondaryBold)
                    }else {
                        Text(chartMark.value.twoDecimalStr)
                            .font(.secondaryBold)
                    }
                    
                }
            }
        }
    }
}

struct HighlightedChartInfo_Previews: PreviewProvider {
    static var previews: some View {
        HighlightedChartInfo(chartMark: .init(name: "Mathematics", value: 3.0),
                             currentTab: "Year",
                             currentOption: .init(type: "Year", xLabel: "Year", yLabel: "CGPA"))
    }
}
