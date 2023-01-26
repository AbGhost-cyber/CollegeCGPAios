//
//  GPAProgessBar.swift
//  CollegeCGPAios
//
//  Created by dremobaba on 2023/1/26.
//

import SwiftUI

struct GPAProgressBar: View {
    @State private var color: Color = .red
    let semester: Semester
    let maxGPA:Float = 4.0
    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.4), lineWidth: 8)
            Circle()
                .trim(from: 0, to: CGFloat(semester.gpa / maxGPA))
                .stroke(style: .init(lineWidth: 8, lineCap: .round))
                .scale(x: -1)
                .foregroundColor(color)
                .animation(.easeOut, value: semester.gpa / maxGPA)
                .rotationEffect(.degrees(90))
            VStack {
                Text("\(semester.gpa.twoDecimalStr)")
                    .foregroundColor(.black)
                    .font(.headline)
                    .bold()
                Text("GPA")
                    .foregroundColor(Color(uiColor: .secondaryLabel))
                    .font(.subheadline)
            }.multilineTextAlignment(.center)
                .onAppear {
                    if semester.gpa >= 3.0 {
                        color = .blue
                    } else {
                        color = .red
                    }
                }
        }.frame(maxWidth: 70)
    }
}

struct GPAProgessBar_Previews: PreviewProvider {
    static var previews: some View {
        GPAProgressBar(semester: .init(yearId: "2022", id: UUID().uuidString))
    }
}
