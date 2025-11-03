//
//  StocksView.swift
//  SwiftTrade
//
//  Created by Petr Homola on 02/11/2025.
//

import SwiftUI
import CloudKit
import Charts

let allIntervals: [Interval] = [.hour1, .day1]
let allSymbols: [Symbol] = [Symbol(text: "AAPL"), Symbol(text: "MSFT"), Symbol(text: "GOOGL")]

struct StocksView: View {
    @State private var symbol: String = allSymbols[0].id
    @State private var from: Date = .now
    @State private var to: Date = .now
    @State private var interval: Interval = .day1
    @State private var isWorking = false
    @State private var errorWrapper: ErrorWrapper?
    @State private var chartData: ChartData?

    var body: some View {
        VStack {
            if let data = chartData {
                Chart(data.candles) { candle in
                    //                    ForEach(candles) { candle in
                    LineMark(x: .value("timestamp", candle.timestamp), y: .value("close", candle.close))
                        .foregroundStyle(by: .value("type", "close"))
                    //                        .symbol(by: .value("type", "close"))
                    //                    }
                }
                .chartYScale(domain: data.minClose...data.maxClose)
            }
            //TextField("symbol", text: $symbol, prompt: Text("symbol"))
            Picker("symbol", selection: $symbol) {
                ForEach(allSymbols) { symbol in
                    Text(symbol.text)
                }
            }
            .onChange(of: symbol) {
                NSUbiquitousKeyValueStore.default.set(symbol, forKey: "symbol")
            }
            DatePicker("from", selection: $from, displayedComponents: [.date, .hourAndMinute])
//                .environment(\.timeZone, TimeZone(secondsFromGMT: 0)!)
                .onChange(of: from) {
                    NSUbiquitousKeyValueStore.default.set(from.timeIntervalSince1970, forKey: "from")
                }
            DatePicker("to", selection: $to, displayedComponents: [.date, .hourAndMinute])
//                .environment(\.timeZone, TimeZone(secondsFromGMT: 0)!)
                .onChange(of: to) {
                    NSUbiquitousKeyValueStore.default.set(to.timeIntervalSince1970, forKey: "to")
                }
            Picker("interval", selection: $interval) {
                ForEach(allIntervals) { interval in
                    Text(interval.localizedStringKey)
                }
            }
            Button("chart") {
                //                if let from = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: from)) {
                //                    if let to = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: to)) {
                //                        let to = to.addingTimeInterval(24 * 60 * 60 - 1)
                isWorking = true
                Task {
                    defer { isWorking = false }
                    do {
                        let (candles, meta) = try await fetchYahooData(symbol: symbol, from: from, to: to, interval: interval)
                        print("\(meta.currency) \(meta.fullExchangeName)")
                        for candle in candles {
                            print("\(candle.timestamp) \(candle.volume) \(candle.low) \(candle.open) \(candle.close) \(candle.high)")
                        }
                        print(candles.count)
                        chartData = ChartData(candles: candles)
                    } catch {
                        print("error: \(error.localizedDescription)")
                        errorWrapper = ErrorWrapper(error: error, guidance: "Failed to fetch data.")
                    }
                    //                        }
                    //                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(isWorking || symbol.isEmpty)
            Button("js_exper") {
                jsExper()
            }
            .buttonStyle(.bordered)
            Button("scanner_exper") {
                scannerExper()
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .onAppear {
            let store = NSUbiquitousKeyValueStore.default
            if let symbol = store.string(forKey: "symbol") {
                self.symbol = symbol
            }
            let from = store.double(forKey: "from")
            if from != 0 {
                self.from = Date(timeIntervalSince1970: from)
            }
            let to = store.double(forKey: "to")
            if to != 0 {
                self.to = Date(timeIntervalSince1970: to)
            }
        }
        .sheet(item: $errorWrapper) { wrapper in
            ErrorView(errorWrapper: wrapper)
        }
    }
}

#Preview {
    StocksView()
}
