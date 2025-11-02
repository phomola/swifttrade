//
//  StocksView.swift
//  SwiftTrade
//
//  Created by Petr Homola on 02/11/2025.
//

import SwiftUI

let allIntervals: [Interval] = [.hour1, .day1]
let allSymbols: [Symbol] = [Symbol(text: "AAPL"), Symbol(text: "MSFT"), Symbol(text: "GOOGL")]

struct StocksView: View {
    @State private var symbol: String = allSymbols[0].id
    @State private var from: Date = .now
    @State private var to: Date = .now
    @State private var interval: Interval = .day1
    @State private var isWorking = false
    @State private var errorWrapper: ErrorWrapper?

    var body: some View {
        VStack {
            //TextField("symbol", text: $symbol, prompt: Text("symbol"))
            Picker("symbol", selection: $symbol) {
                ForEach(allSymbols) { symbol in
                    Text(symbol.text)
                }
            }
            DatePicker("from", selection: $from, displayedComponents: .date)
            DatePicker("to", selection: $to, displayedComponents: .date)
            Picker("interval", selection: $interval) {
                ForEach(allIntervals) { interval in
                    Text(interval.localizedStringKey)
                }
            }
            Button("chart") {
                if let from = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: from)) {
                    if let to = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: to)) {
                        let to = to.addingTimeInterval(24 * 60 * 60 - 1)
                        Task {
                            do {
                                let (candles, meta) = try await fetchYahooData(symbol: symbol, from: from, to: to, interval: interval)
                                print("\(meta.currency) \(meta.fullExchangeName)")
                                for candle in candles {
                                    print("\(candle.timestamp) \(candle.volume) \(candle.low) \(candle.open) \(candle.close) \(candle.high)")
                                }
                                print(candles.count)
                            } catch {
                                print("error: \(error.localizedDescription)")
                                errorWrapper = ErrorWrapper(error: error, guidance: "Failed to fetch data.")
                            }
                        }
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(isWorking || symbol.isEmpty)
        }
        .padding()
        .sheet(item: $errorWrapper) { wrapper in
            ErrorView(errorWrapper: wrapper)
        }
    }
}

#Preview {
    StocksView()
}
