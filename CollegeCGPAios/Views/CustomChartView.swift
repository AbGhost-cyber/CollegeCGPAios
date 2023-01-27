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
    let extraName: String
    let id: String
}
struct Options: Equatable {
    var type: String
    var xLabel: String
    var yLabel: String
}

struct MyChartView: View {
    let data: [ChartDataPoint]
    @Binding var options: Options
    @Binding var selectedBarValue: String
    var body: some View {
        Chart {
            ForEach(Array(data.enumerated()), id: \.element) { index, datapoint in
                let color = selectedBarValue == datapoint.extraName ? Color.primary : Color.blue
                BarMark(x: .value("Value 1", datapoint.title),
                        y: .value("Value 2", datapoint.value)
                )
                .foregroundStyle(color)
                .annotation(position: .top) {
                    Text(datapoint.value.twoDecimalStr)
                        .font(.chartAnnotation)
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading, values: .stride(by: 1.5)) { value in
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
        .chartOverlay { proxy in
            GeometryReader { geometry in
                ZStackLayout(alignment: .top) {
                    Rectangle()
                        .fill(.clear).contentShape(Rectangle())
                        .onTapGesture { location in
                            let origin = geometry[proxy.plotAreaFrame].origin
                             let yPosition = location.y - origin.y
                            let xPosition = location.x - origin.x
                            
                            //check for values only lower or equal to the bar mark y value
                            let newPoint = CGPoint(x: xPosition, y: yPosition)
                            guard let (title, value) = proxy.value(at: newPoint, as: (String, Float).self) else {
                                return
                            }
                            if let index = data.firstIndex(where: {$0.title == title}) {
                                var selectedDatapoint = data[index]
                                if value <= selectedDatapoint.value {
                                    selectedBarValue = selectedDatapoint.extraName
                                }
                                
                            }
                        }
                }
            }
        }
    }
}
