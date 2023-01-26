//
//  ContentView.swift
//  CollegeCGPAios
//
//  Created by dremobaba on 2023/1/26.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab = ""
    let tabData = ["Year", "Semester", "Course"]
    @State var chartOptions = Options(
        type: "Year", xLabel: "Academic Year", yLabel: "CGPA")
    
    var body: some View {
        VStack {
            HeaderView(title: "Academic Tracker")
            ScrollView(showsIndicators: false) {
                SegmentedPicker(selectedTab: $selectedTab, data: tabData)
                    .padding(.top)
                MyChartView(data: [], options: $chartOptions)
                    .frame(minHeight: 250)
                    .padding()
                    .animation(.easeInOut, value: selectedTab)
                HStack {
                    Text("Recent")
                        .font(.recentText)
                    Spacer()
                    Button {
                        
                    } label: {
                        Text("View All")
                            .font(.recentText)
                        Image(systemName: "chevron.right")
                            .font(.caption)
                    }
                    
                }
            }
        }
        .onAppear {
            selectedTab = tabData[0]
        }
        .padding()
    }
}

struct MainView_Previews: PreviewProvider {
    private static var vm: MainViewModel = {
        let vm = MainViewModel()
        return vm
    }()
    static var previews: some View {
        MainView()
            .environmentObject(vm)
    }
}
