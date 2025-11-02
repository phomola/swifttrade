//
//  StocksView.swift
//  SwiftTrade
//
//  Created by Petr Homola on 02/11/2025.
//

import SwiftUI

struct StocksView: View {
    @State private var from: Date = .now
    @State private var to: Date = .now

    var body: some View {
        VStack {
            DatePicker("from", selection: $from, displayedComponents: .date)
            DatePicker("to", selection: $to, displayedComponents: .date)
            Button("chart") {
                if let from = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: from)) {
                    if let to = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: to)) {
                        let to = to.addingTimeInterval(24 * 60 * 60 - 1)
                        print("\(from)")
                        print("\(to)")
                    }
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    StocksView()
}
