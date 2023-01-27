//
//  GPAProgessBar.swift
//  CollegeCGPAios
//
//  Created by dremobaba on 2023/1/26.
//

import SwiftUI

struct GPAProgressBar: View {
    @State private var color: Color = .red
    var gpa: Float
    let maxGPA: Float = 4.0
    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.4), lineWidth: 8)
            Circle()
                .trim(from: 0, to: CGFloat(gpa / maxGPA))
                .stroke(style: .init(lineWidth: 8, lineCap: .round))
                .scale(x: -1)
                .foregroundColor(color)
                .animation(.easeOut, value: gpa / maxGPA)
                .rotationEffect(.degrees(90))
            VStack {
                Text("\(gpa.twoDecimalStr)")
                    .foregroundColor(.primary)
                    .font(.primaryBold)
                    .bold()
                Text("GPA")
                    .foregroundColor(Color(uiColor: .secondaryLabel))
                    .font(.secondaryText)
            }.multilineTextAlignment(.center)
                .onAppear {
                    if gpa >= 3.0 {
                        color = .blue
                    } else {
                        color = .red
                    }
                }
        }.frame(maxWidth: 70, maxHeight: 70)
    }
}

struct GPAProgessBar_Previews: PreviewProvider {
    static var previews: some View {
        GPAProgressBar(gpa: 3.2)
    }
}
