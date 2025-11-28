//
//  TimeTool.swift
//  SwiftTrade
//
//  Created by Petr Homola on 22/09/2025.
//

import Foundation
import FoundationModels

@available(iOS 26, *)
struct TimeTool: Tool {
    let name = "timeTool"
    let description = "Provides the current date and time."
    
    @Generable
    struct Arguments {
    }
    
    func call(arguments: Arguments) async throws -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .medium
        let reply = formatter.string(from: .now)
        print("time tool current time: \(reply)")
        return reply
    }
}
