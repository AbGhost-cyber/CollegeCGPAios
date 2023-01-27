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
    var clicked:((String) -> Void)? = nil
    var body: some View {
        HStack {
            Button(action:{clicked?("Search")}) {
                icon(name: "magnifyingglass")
            }
            Spacer()
            Text(title)
                .font(.headerTitle)
            Spacer()
            
            Button(action:{clicked?("Add")}) {
                icon(name: "plus")
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
