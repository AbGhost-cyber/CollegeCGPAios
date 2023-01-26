//
//  CustomChartView.swift
//  CollegeCGPAios
//
//  Created by dremobaba on 2023/1/26.
//

import Foundation
import SwiftUI
import Charts

struct ChartDataPoint: Identifiable, Hashable {
    let title: String
    let value: Float
    let id: String
}
struct Options {
    var type: String
    var xLabel: String
    var yLabel: String
}

struct MyChartView: View {
    let data: [ChartDataPoint]
    @Binding var options: Options
    
    var body: some View {
        Chart {
            ForEach(Array(data.enumerated()), id: \.element) { index, item in
                let color = index % 2 == 0 ? Color.black : Color.blue
                BarMark(x: .value("Shape Type", item.title),
                        y: .value("Total count", item.value)
                )
                .foregroundStyle(color)
                .annotation(position: .top) {
                    Text(item.value.twoDecimalStr)
                        .font(.chartAnnotation)
                }
            }
        }
        .chartForegroundStyleScale(options.type == "semester" ? [
            "1st semester": .black, "2nd semester": .blue
        ] : [:])
        .chartYAxis {
            AxisMarks(position: .leading, values: .automatic) { value in
                AxisGridLine()
                if let value = value.as(Float.self) {
                    AxisValueLabel {
                        Text(value.twoDecimalStr)
                    }
                }
            }
        }
        .chartYAxisLabel(options.yLabel, position: .trailing, alignment: .center)
        .chartXAxisLabel(options.xLabel, position: .bottom, alignment: .center)
        .chartXAxis {
            AxisMarks(values: .automatic) {
                AxisValueLabel()
            }
        }
        .overlay {
            if data.isEmpty {
                Text("No data")
                    .font(.emptyChart)
                    .foregroundColor(Color(uiColor: .secondaryLabel))
            }
        }
    }
}
