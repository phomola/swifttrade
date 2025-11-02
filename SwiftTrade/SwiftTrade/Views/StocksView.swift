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
    @State private var interval: Interval = .day1
    let intervals: [Interval] = [.hour1, .day1]

    var body: some View {
        VStack {
            DatePicker("from", selection: $from, displayedComponents: .date)
            DatePicker("to", selection: $to, displayedComponents: .date)
            Picker("interval", selection: $interval) {
                ForEach(intervals) { interval in
                    Text(interval.localizedStringKey).tag(interval)
                }
            }
            .onChange(of: interval) {
                print("\(interval) \(YahooInterval(interval))")
            }
            Button("chart") {
                if let from = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: from)) {
                    if let to = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: to)) {
                        let to = to.addingTimeInterval(24 * 60 * 60 - 1)
                        Task {
                            do {
                                let (candles, meta) = try await fetchYahooData(symbol: "AAPL", from: from, to: to, interval: interval)
                                print("\(meta.currency) \(meta.fullExchangeName)")
                                for candle in candles {
                                    print("\(candle.timestamp) \(candle.volume) \(candle.low) \(candle.open) \(candle.close) \(candle.high)")
                                }
                            } catch {
                                print("error: \(error.localizedDescription)")
                            }
                        }
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
