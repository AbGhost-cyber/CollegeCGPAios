//
//  SemesterRowItem.swift
//  CollegeCGPAios
//
//  Created by dremobaba on 2023/1/26.
//

import SwiftUI

struct SemesterRowItem: View {
    var body: some View {
        NavigationLink {
            //Destination
            Text("Hi")
        } label: {
            //Component
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("First Semester")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .bold()
                    Text("Maths, Biology, Chemistry")
                        .font(.subheadline)
                        .foregroundColor(Color(uiColor: .secondaryLabel))
                }
                Spacer()
                GPAProgressBar(semester: .init(yearId: "2012", id: "123"))
            }
        }
    }
}

struct SemesterRowItem_Previews: PreviewProvider {
    static var previews: some View {
        SemesterRowItem()
    }
}
