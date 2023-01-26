//
//  HeaderView.swift
//  CollegeCGPAios
//
//  Created by dremobaba on 2023/1/26.
//
import Foundation
import SwiftUI

struct HeaderView: View {
    let title: String
    var body: some View {
        HStack {
            Button(action:{}) {
                icon(name: "line.3.horizontal")
            }
            Spacer()
            Text(title)
                .font(.headerTitle)
            Spacer()
            
            Button(action:{}) {
                icon(name: "magnifyingglass")
            }
        }
    }
    
    @ViewBuilder
    func icon(name: String) -> some View {
        RoundedRectangle(cornerRadius: 6)
            .stroke(.primary.opacity(0.2))
            .foregroundColor(.primary)
            .frame(width: 35, height: 35)
            .bold()
            .overlay {
                Image(systemName: name)
                    //.renderingMode(.template)
                    .foregroundColor(.primary)
            }
    }
}
