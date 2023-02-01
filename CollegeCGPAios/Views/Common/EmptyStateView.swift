//
//  EmptyStateView.swift
//  CollegeCGPAios
//
//  Created by dremobaba on 2023/2/1.
//


import SwiftUI

struct EmptyStateView: View {
    
    let text: String
    
    var body: some View {
        HStack {
            Spacer()
            Text(text)
                .font(.emptyChart)
                .foregroundColor(Color(uiColor: .secondaryLabel))
            Spacer()
        }
        .padding(64)
        .lineLimit(3)
        .multilineTextAlignment(.center)
    }
}

struct EmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyStateView(text: "No data available")
            .previewLayout(.sizeThatFits)
    }
}

