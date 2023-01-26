//
//  CollegeCGPAiosApp.swift
//  CollegeCGPAios
//
//  Created by dremobaba on 2023/1/26.
//

import SwiftUI

@main
struct CollegeCGPAiosApp: App {
    @StateObject private var mainViewModel: MainViewModel = MainViewModel()
    var body: some Scene {
        WindowGroup {
           MainView()
                .environmentObject(mainViewModel)
        }
    }
//    init() {
//        for family in UIFont.familyNames.sorted() {
//            let names = UIFont.fontNames(forFamilyName: family)
//            print("Family: \(family) Font names: \(names)")
//        }
//    }
}
