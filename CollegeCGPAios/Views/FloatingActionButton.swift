//
//  FloatingActionButton.swift
//  CollegeCGPAios
//
//  Created by dremobaba on 2023/1/28.
//

import SwiftUI

struct FloatingActionButton: View {
    var action: (() -> Void)?
    var body: some View {
        Button {
            action?()
        } label: {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.purple)
                .shadow(color: .gray, radius: 0.2, x: 1, y: 1)
                .padding()
        }

    }
}

struct FloatingActionButton_Previews: PreviewProvider {
    static var previews: some View {
        FloatingActionButton()
    }
}
