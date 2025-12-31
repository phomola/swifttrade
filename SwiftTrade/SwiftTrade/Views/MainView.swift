//
//  MainView.swift
//  SwiftTrade
//
//  Created by Petr Homola on 02/11/2025.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            //            Tab("stocks", systemImage: "chart.bar") {
            //                StocksView()
            //            }
            StocksView()
                .tabItem {
                    Label("stocks", systemImage: "chart.bar")
                }.tag(1)
        }
    }
}

#Preview {
    MainView()
}
