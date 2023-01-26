//
//  SegmentedPicker.swift
//  CollegeCGPAios
//
//  Created by dremobaba on 2023/1/26.
//

import Foundation
import SwiftUI

struct SegmentedPicker: View {
    @Binding var selectedTab: String
    let data: [String]
    @Namespace var animation
    
    var body: some View {
        VStack(alignment: .leading) {
            LazyHStack {
                ForEach(data, id: \.self) { tab in
                    Button {
                        withAnimation {
                            selectedTab = tab
                        }
                    } label: {
                        let isSelected = selectedTab == tab
                        VStack(alignment: .leading) {
                            Text(tab.capitalized)
                                .font(.tab)
                                .padding(.horizontal, 10)
                                .padding(.bottom)
                                .foregroundColor(isSelected ? .primary : .secondary)
                                .matchedGeometryEffect(id: tab, in: animation, isSource: true)
                        }.overlay(alignment: .bottom) {
                            Rectangle()
                                .frame(height: 2)
                                .foregroundStyle(Color.primary)
                                .matchedGeometryEffect(id: selectedTab, in: animation, isSource: false)
                        }
                    }.foregroundColor(.black)
                }
            }
            //MARK: TAB DEMARCATION
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color.secondary.opacity(0.2))
                .offset(y: -9)
        }
    }
}
struct PreviewData: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
