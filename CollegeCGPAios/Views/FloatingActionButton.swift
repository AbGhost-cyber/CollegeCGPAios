//
//  FloatingActionButton.swift
//  CollegeCGPAios
//
//  Created by dremobaba on 2023/1/28.
//

import SwiftUI

struct NavigateAbleIcon<Content: View, Label: View>: View {
    private let destination: Content
    private let mLabel: Label
    
    init(@ViewBuilder destination: () -> Content, @ViewBuilder label: () -> Label) {
        self.destination = destination()
        self.mLabel = label()
    }
    var body: some View {
        NavigationStack {
            NavigationLink {
                destination
            } label: {
               mLabel
            }
        }

    }
}

struct FloatingActionButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigateAbleIcon {
            EmptyView()
        } label: {
            EmptyView()
        }
    }
}
