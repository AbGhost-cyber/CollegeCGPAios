//
//  CustomIconBackground.swift
//  CollegeCGPAios
//
//  Created by dremobaba on 2023/1/28.
//

import SwiftUI

struct CustomIconBackground: View {
    let systemName: String
    var action: (()-> Void)? = nil
    
    var body: some View {
        Button {
            action?()
        } label: {
            Circle()
                .frame(width: 36)
                .foregroundColor(.gray.opacity(0.1))
                .overlay {
                    Image(systemName: systemName)
                        .font(.system(size: 18).bold())
                        .foregroundColor(Color(uiColor: .secondaryLabel))
                }
        }
        .buttonStyle(.plain)
    }
}
struct CustomIconBackground_Previews: PreviewProvider {
    static var previews: some View {
        CustomIconBackground(systemName: "plus")
    }
}
